---
title: MySQL组复制
date: 2020-03-29 13:13:00
categories: MySQL
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [group replication（组复制基础）](#group-replication组复制基础)
- [实验](#实验)
  - [配置文件](#配置文件)
  - [创建用于复制的用户](#创建用于复制的用户)
  - [重启服务检查组复制插件是否加载](#重启服务检查组复制插件是否加载)
  - [自举组启动并检查](#自举组启动并检查)
  - [其他节点加入](#其他节点加入)
- [验证](#验证)
<!-- TOC END -->
<!--more-->

# group replication（组复制基础）

  - ## what is 组复制
      组复制是一种可用于实施容错系统的技术。**复制组是一组服务器，每个服务器都有自己的完整数据副本（无共享复制方案），并通过消息传递相互交互**。

      MySQL组复制建立在这些属性和抽象之上，并在所有复制协议中实现**多主机更新**。**一个复制组由多个服务器组成**，该组中的每个服务器可以随时独立执行事务。但是，**所有读写事务仅在获得组批准后才提交**。换句话说，对于任何读写事务，该组都需要决定是否提交，因此提交操作不是来自原始服务器的单方面决定。**只读事务不需要组内的协调并立即提交**。

      当读写事务准备好在原始服务器上提交时，服务器自动广播写值（已更改的行）和相应的write set（已更新的行的唯一标识符）。**事务是通过原子广播发送，因此该组中的所有服务器要么全部收到，要不都收不到**。

      ![group-replication-process](http://study.jeffqi.cn/mysql/group-replication-process.png)

  - ## 传统主从复制提交流程
      - 异步复制
      ![async-replication-process](http://study.jeffqi.cn/mysql/async-replication-process.png)

      - 半同步复制
      ![semisync-replication-process](http://study.jeffqi.cn/mysql/semisync-replication-process.png)

  - ## 组复制有什么用
      通过组复制，可以通过将系统状态复制到一组服务器来创建具有冗余的容错系统。即使某些服务器随后发生故障，只要不是全部或大多数，该系统仍然可用。

  - ## 使用场景
      1.  弹性复制：需要非常流畅的复制基础结构的环境，其中服务器的数量必须动态增加或减少，并且副作用要尽可能少。例如，用于云的数据库服务。

      2.  高度可用的分片：分片是实现写入横向扩展的一种流行方法。使用MySQL组复制来实现高度可用的分片，其中每个分片都映射到一个复制组。

      3.  主从复制的替代方法：在某些情况下，使用单个主服务器使其成为单个竞争点。在某些情况下，写给整个小组可能会更具扩展性。

      4.  自治系统：另外，您可以纯粹为复制协议中内置的自动化功能部署MySQL组复制。

  - ## 工作模式
      - 组复制的工作模式由参数 group_replication_single_primary_mode 来决定

      - on：单主模式

      - off：多主模式

      - **所有的成员的模式必须相同且组复制工作室不可修改；可以通过group_replication_switch_to_single_primary_mode()和 group_replication_switch_to_multi_primary_mode()函数来动态切换状态。**

        ![group_replication_work_status](http://study.jeffqi.cn/mysql/group_replication_work_status.jpg)

# 实验

## 配置文件
- mysql配置文件，master与slave不同在与server-id，和通信地址
    ```sh
    # 组复制适用于innodb，所以使用其他的存储引擎可能会出现以外
    disabled_storage_engines="MyISAM,BLACKHOLE,FEDERATED,ARCHIVE,MEMORY"

    server_id=x

    # 本机配置，开启gtid
    gtid_mode=ON
    enforce_gtid_consistency=ON

    # 将二进制日志校验和关闭，不写入日志
    binlog_checksum=NONE

    # 二进制日志格式设置，名称，格式
    log_bin=binlog
    log-index=binlog.index
    binlog_format=ROW

    # 从服务器将应用的relay-log语句写入本地的二进制日志中
    log_slave_updates=ON

    # 设置本地的中继日志
    relay-log=relay-log
    relay-log-index=relay-log.index

    master_info_repository=TABLE
    relay_log_info_repository=TABLE

    # 开机启动自动添加group_replication.so插件，如果配置文件中没有，在启动时性需要手动安装
    plugin_load_add='group_replication.so'    # 登入mysq>>>INSTALL PLUGIN group_replication SONAME 'group_replication.so';

    # 指明当前服务器不是引导组，在第一次开启组的时候需要将这个配置设置为on，完成后需要恢复为off
    group_replication_bootstrap_group=off

    # 组复制的uuid，全局唯一，可以使用select UUID() 生成的 uuid
    group_replication_group_name="UUID"

    # 以off指示插件在服务器启动时不自动启动操作。当你配置完成服务器后可以通过手工开启组服务器
    group_replication_start_on_boot=off

    # 组复制内部通信使用的ip地址和端口，不可以与提供服务的端口冲突（port配置参数的端口）
    group_replication_local_address= "s1:33061"

    # 组复制种子成员的ip地址与端口
    group_replication_group_seeds= "s1:33061,s2:33061,s3:33061"

    # 指明为每个事物收集 write set 并使用 XXHASH64 进行hash
    transaction_write_set_extraction=XXHASH64
    ```

## 创建用于复制的用户
- 需要创建用于组复制的用户，并分配相应的权限，然后指向复制组
    ```sql
    set sql_log_bin=0;
    create user 'repl'@'192.168.80.%' identified WITH 'mysql_native_password' BY 'Hjqme525+';
    GRANT replication slave, replication client, backup_admin on *.* to 'repl'@'192.168.80.%';
    flush privileges;
    set sql_log_bin=1;

    change master to
    master_user='repl',
    master_password='Hjqme525+' for channel 'group_replication_recovery';
    ```

## 重启服务检查组复制插件是否加载
- 通过过检查是否成功加载 group_replication 组复制插件；文章末尾有验证图；可在每个服务器服务启动后检查。
    ```sql
    show plugins;
    ```

- 查看组复制插件

## 自举组启动并检查
- group_replication_bootstrap_group 系统变量来引导组；自检组角色为 primary，其他节点为 secondary。验证图中有结果。
    ```sql
    # 只有自举组才需要暂时开启这一步，开启引导组时才需要
    set global group_replication_bootstrap_group=on;
    start group_replication;
    # 开启后关闭
    set global group_replication_bootstrap_group=off;

    # 查询是否加入到组中
    select * from performance_schema.replication_group_members;
    ```

## 其他节点加入
- 配置文件需要修改server-id与group_replication_local_address

- 重启检查插件，创建组复制用户，分配权限，指向复制组

- 加入组中
    ```sql
    start group_replication;

    select * from performance_schema.replication_group_members;
    ```

# 验证
- **是否成功加载插件**

    ![group_replication_show_plugins](http://study.jeffqi.cn/mysql/group_replication_show_plugins.jpg)

- **节点是否加入到组中，并查看其优先级**

    ![group_replication_select_replication_group_members](http://study.jeffqi.cn/mysql/group_replication_select_replication_group_members.jpg)

- **主服务器操作**

    ![group_replication_node2_create_database_table](http://study.jeffqi.cn/mysql/group_replication_node2_create_database_table.jpg)
    ![group_replication_master_show_binlog](http://study.jeffqi.cn/mysql/group_replication_master_show_binlog.jpg)

- **从服务器操作验证**

    ![group_replication_slave_status](http://study.jeffqi.cn/mysql/group_replication_slave_status.jpg)
    ![group_replication_show_databases](http://study.jeffqi.cn/mysql/group_replication_show_databases.jpg)
    ![group_replication_select_table](http://study.jeffqi.cn/mysql/group_replication_select_table.jpg)
    ![group_replication_slave_mysqlbinlog_relay_log](http://study.jeffqi.cn/mysql/group_replication_slave_mysqlbinlog_relay_log.jpg)
    ![group_replication_slave_mysqlbinlog_relay_log_2](http://study.jeffqi.cn/mysql/group_replication_slave_mysqlbinlog_relay_log_2.jpg)
