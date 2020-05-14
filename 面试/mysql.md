---
title: mysql问题
date: 2020-03-20 20:00:00
categories: MySQL
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [mysql执行过程](#mysql执行过程)
- [两个日志](#两个日志)
- [讲讲mysql的mvcc并发控制](#讲讲mysql的mvcc并发控制)
- [mysql 的 myisam 引擎和 innodb 引擎的不同应该如何选择](#mysql-的-myisam-引擎和-innodb-引擎的不同应该如何选择)
- [主备切换](#主备切换)
- [并行复制](#并行复制)
- [判断主库是否出问题](#判断主库是否出问题)
- [数据库操作](#数据库操作)
  - [修改库表编码](#修改库表编码)
  - [索引添加](#索引添加)
  - [数据库备份操作及mysqldump使用](#数据库备份操作及mysqldump使用)
<!-- TOC END -->
<!--more-->

# mysql执行过程
1.  客户端与连接器简历建立连接，连接器会查询mysql库进行一个权限的验证。通过之后会建立连接。发送一条sql语句后，会首先查询缓存，缓存命中则会检验对于这样表是否有权限进行读取操作的权限；如果没有缓存那么就走普通的逻辑；先通过分析器，进行一个词法语法的分析。然后就会识别名称判断表是否存在。接下来，会到优化器，在优化器中，数据库会决定使用那些索引，或者怎么对表进行连接；最后会到达执行器，执行器执行sql语句之前会验证数据库和表的权限。然后调用相应的数据库引擎进行读取数据，返回客户端

# 两个日志
1.  redolog与binlog；二进制日志binlog是用来做归档的；而redolog是innodb引擎特有的；redolog通过记录对于数据的改动，记录的物理日志；而binlog记录的是每一条sql语句的是一个逻辑的日志；redolog循环写，binlog追加写；
2.  两阶段提交：一条语句执行完成后，redolog会进入准备状态，innodb会告诉执行器做完了随时可以提交；然后执行器会写binlog，写完后通知innodb，redolog变成commit状态；

# 讲讲mysql的mvcc并发控制
1.  mvcc多版本并发控制，就是对于一条数据有多个不同的版本；每个事物在启动的时候，就会生成一个快照，然后事物的所有读都是基于当前快照来读取的，如果这个数据是在这个快照之前生成的那么就是可见的，如果是在快照之后生成的那就是不可见的；多版本的数据在数据库中可以看成是一个链表，每次改动之后就会为最新的版本记录下修改的事务id，并记录下一个回滚日志undolog，如果有事务想要读取一个数据，就按照最新的版本往前去查看，如果数据中记录的事务id不满满足条件就根据undolog来计算出上一个版本号的数据知道满足条件为止；InnoDB 的行数据有多个版本，每个数据版本有自己的 row trx_id，每个事务或者语句有自己的一致性视图。普通查询语句是一致性读，一致性读会根据 row trx_id 和一致性视图确定数据版本的可见性。

# mysql 的 myisam 引擎和 innodb 引擎的不同应该如何选择
1.  myisam 不支持事务，innodb 支持事务，能够进行事务的回滚
2.  myisam 不支持外键索引；innodb 支持
3.  myisam 非聚簇索引；innodb 是聚簇索引
4.  myisam 会保存行数；innodb 不会，通过 select count(\*) from table 来获取行数
5.  myisam 只有表锁，并发度不好；innodb 支持行锁
6.  如何选择：
    1.  是否要支持事务，如果要请选择 InnoDB，如果不需要可以考虑 MyISAM
    2.  如果表中绝大多数都只是读查询，可以考虑 MyISAM，如果既有读写也挺频繁，请使用InnoDB
    3.  崩溃恢复 myisam 比较困难

# 主备切换
1.  可靠性优先：互为主备切换时，等到主备延迟小于一个时间比如5秒，设置主库为readonly然后等待备库延迟降为0，再讲备库readonly取消，切换任务到备库上
2.  可用性优先：主备切换时，先将备库取消readonly状态，然后直接切换任务到备库上；不等主备数据同步；这样可能会导致主备数据不一致
3.  基于位点：pos
4.  基于GTID：
    1.  实例 B 指定主库 A’，基于主备协议建立连接。实例 B 把 set_b 发给主库 A’。实例 A’算出 set_a 与 set_b 的差集，也就是所有存在于 set_a，但是不存在于 set_b 的 GTID 的集合，判断 A’本地是否包含了这个差集需要的所有 binlog 事务。
      1.  如果不包含，表示 A’已经把实例 B 需要的 binlog 给删掉了，直接返回错误；
      2.  如果确认全部包含，A’从自己的 binlog 文件里面，找出第一个不在 set_b 的事务，发给 B；之后就从这个事务开始，往后读文件，按顺序取 binlog 发给 B 去执行。

# 并行复制
1.  按表分发：维持一个hash表；键为库表，值为计数
    1.  如果跟所有 worker 都不冲突，coordinator 线程就会把这个事务分配给最空闲的 woker;
    2.  如果跟多于一个 worker 冲突，coordinator 线程就进入等待状态，直到和这个事务存在冲突关系的 worker 只剩下 1 个；
    3.  如果只跟一个 worker 冲突，coordinator 线程就会把这个事务分配给这个存在冲突关系的 worker。
2.  按行分配：维持hash表；库，表，唯一索引，索引值，值：计数
    1.  要能够从 binlog 里面解析出表名、主键值和唯一索引的值。也就是说，主库的 binlog 格式必须是 row；
    2.  表必须有主键；
    3.  不能有外键。表上如果有外键，级联更新的行不会记录在 binlog 中，这样冲突检测就不准确。
    4.  如果有大事务，就退化为单线程复制；然后再恢复
3.  按库分配
4.  按组提交分配
    1.  同时处于 prepare 状态的事务，在备库执行时是可以并行的；
    2.  处于 prepare 状态的事务，与处于 commit 状态的事务之间，在备库执行时也是可以并行的。
5.  mysql最新并行策略
    1.  COMMIT_ORDER，表示的就是前面介绍的，根据同时进入 prepare 和 commit 来判断是否可以并行的策略。
    2.  WRITESET，表示的是对于事务涉及更新的每一行，计算出这一行的 hash 值，组成集合 writeset。如果两个事务没有操作相同的行，也就是说它们的 writeset 没有交集，就可以并行。
    3.  WRITESET_SESSION，是在 WRITESET 的基础上多了一个约束，即在主库上同一个线程先后执行的两个事务，在备库执行的时候，要保证相同的先后顺序。

# 判断主库是否出问题
1.  select 1 方法：通过向主库查询select 1 的返回值来检查；简单快速；但是不能真实反应主库的状况，如并发进程较多时，无法判断主机出了故障，还以为主机正常
2.  查表法：通过查询一个表来弥补上面的缺点，能够判断主机CPU是否正常；但是无法判断磁盘空间是否出问题
3.  更新法：通过更新一个表的数据来检查数据库是否还活着；但是判断慢，如果数据库服务器压力大，写入得数据一直多，就会造成数据库的磁盘io被占满，从而导致判断出现失误
4.  根据内部的performance_schema的相关表来进行查询

# 数据库操作

##  修改库表编码
1.  修改某一个库
    ```sql
    # 数据库中所有表被改动
    alter database db_name default character set charset_name collate charset_name;

    # 创建库时指定
    create database db_name default character set charset_name collate charset_name;
    ```

2. 修改某个表
    ```sql
    # 把表默认的字符集和所有字符列（CHAR,VARCHAR,TEXT）改为新的字符集
    alter table t_name convert to character set charset_name collate charset_name;

    # 只修改表的默认字符集
    alter table t_name default character set charset_name collate charset_name;
    ```

3.  修改某个列
    ```sql
    alter table t_name change column_name column_name 类型（必须字符类型） character set charset_name collate charset_name;
    ```

4.  查看字符集
    ```sql
    show create database db_name;
    show create table table_name;
    show full columns from table_name;
    ```

## 索引添加
1.  create table
    ```sql
    create table TABLE_NAME
      (
        COLUMN_NAME type
        index index_name (COLUMN_NAME)
      )engine=xx default charset=xxx;
    ```

2. create index
    ```sql
    create index index_name on TABLE_NAME(COLUMN_NAME);（无法创建唯一索引）
    drop index index_name on TABLE_NAME;
    ```

3.  alter table
    ```sql
    alter table table_name add primary key/fulltext/unique/index/ index_name (COLUMN_NAME);
    alter table table_name drop index index_name;
    ```

## 数据库备份操作及mysqldump使用
1.  数据导出
    ```sql
    # 直接导出数据
    select * from table_name
    into outfile '/path/to/some/file';

    # 导出文件使用分隔符
    select * from table_name
    into outfile '/path/to/some/file'
    fields terminated by ',' optionally enclosed by ''''
    lines terminated by '\n';
    ```
