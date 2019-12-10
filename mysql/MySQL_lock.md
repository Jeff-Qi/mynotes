---
title: MySQL全局锁与表锁
date: 2019-12-10 19:26:00
tags: MySQL知识
categories: MySQL
---

## MySQL锁
- MySQL 里面的锁大致可以分成全局锁、表级锁和行锁三类

### 全局锁
- 命令
  ```sql
  flush tables with read lock;
  #此时整个库处于只读状态
  ```
- 不加锁的话，备份系统备份的得到的库不是一个逻辑时间点，这个视图是逻辑不一致的
- MySQL中的innodb支持事务：当 mysqldump 使用参数：–single-transaction 的时候，导数据之前就会启动一个事务，来确保拿到一致性视图；同时过程中数据可更新
- 推荐使用ftwrl命令，少用set global variable readonly=true
  1. readonly 的值会被用来做其他逻辑，比如用来判断一个库是主库还是备库
  2. 执行 FTWRL 命令之后由于客户端发生异常断开，那么 MySQL 会自动释放这个全局锁；而后者则会一直持有锁不会自动释放

### 表级锁

#### 表锁
- 语法
  ```sql
  lock tables … read/write #加锁
  unlock tables #释放
  ```

#### 元数据锁
- 访问一个表的时候会被自动加上。MDL 的作用是，保证读写的正确性
- 当对一个表做增删改查操作的时候，加 MDL 读锁；当要对表做结构变更操作的时候，加 MDL 写锁
  - 读锁之间不互斥，因此你可以有多个线程同时对一张表增删改查
  - 读写锁之间、写锁之间是互斥的，用来保证变更表结构操作的安全性
  - **事务中的 MDL 锁，在语句执行开始时申请，但是语句结束后并不会马上释放，而会等到整个事务提交后再释放**，需要小心使用避免误操作使数据库挂掉。在拿不到MDL使需要进行处理
    - 这个指定的等待时间里面能够拿到 MDL 写锁最好，拿不到也不要阻塞后面的业务语句，先放弃
    - DDL NOWAIT/WAIT n 语法
      ```sql
      ALTER TABLE tbl_name NOWAIT add column ...
      ALTER TABLE tbl_name WAIT N add column ...
      ```

### 小结
- MySQL全局锁与表级锁
- 备库时看是否支持事务，选择锁库方式
- 注意MDL元数据表锁的使用
- 数据库出现 lock tables 语句时，需要引起注意。检查存储引擎和业务代码
