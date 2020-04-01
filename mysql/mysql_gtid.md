---
title: MySQL GTID
date: 2020-03-28 17:33:44
categories: MySQL
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [gtid](#gtid)
- [gtid集合](#gtid集合)
- [gtid主从自动定位](#gtid主从自动定位)
- [基于gtid的主从复制](#基于gtid的主从复制)
- [使用gtid的限制](#使用gtid的限制)
<!-- TOC END -->
<!--more-->

# gtid
- 全局事务标识符（GTID）是创建的唯一标识符，并且与在源服务器（主服务器）上提交的每个事务相关联。该标识符不仅对于它起源的服务器是唯一的，而且在给定复制拓扑中的所有服务器上也是唯一的。

- GTID**单调递增**，生成的数字之间没有间隙。如果将客户端**事务提交**到主服务器上，则将为其**分配一个新的GTID**，前提是该事务已写入二进制日志中。事务失败也会保留GTID

- GTID的自动跳过功能意味着在主服务器上提交的事务只能在从服务器上应用一次。

- GTID格式
    ```sql
    GTID = source_id:transaction_id
    ```

# gtid集合
- GTID集是包括一个或多个单个GTID或一系列GTID的集

- MySQL系统表 mysql.gtid_executed 用于保留MySQL服务器上应用的所有事务的已分配GTID，但存储在当前活动的二进制日志文件中的事务除外；该表记录和GTID的状态。保证GTID的值记录。使用 reset master 会清空该表

    ![gtid_executed](http://study.jeffqi.cn/mysql/gtid_executed.jpg)

# gtid主从自动定位
- 在主从复制中可以通过gtid来进行日志的自动定位；无需再指定日志的偏移量
    ```sql
    change master to
      ...
      master_auto_position
      ...
    ```

    ![gtid_in_binlog](http://study.jeffqi.cn/mysql/gtid_in_binlog.jpg)

# 基于gtid的主从复制
1.  同时开启只读模式，让从库追上主库
    ```sql
     SET @@GLOBAL.read_only = ON;
    ```

2.  关闭主从服务器
    ```sh
    mysqladmin -uusername -p shutdown
    ```

3.  修改配置文件启动
    ```sql
    gtid_mode=on
    enforce_gtid_consistency=on
    ```

4.  配置主从复制
    ```sql
    CHANGE MASTER TO
      MASTER_HOST = host,
      MASTER_PORT = port,
      MASTER_USER = user,
      MASTER_PASSWORD = password,
      MASTER_AUTO_POSITION = 1;
    ```

5.  设置从库只读，启动复制
    ```sql
    set @@GLOBAL.read_only=on;
    start slave;
    ```

6.  跳过某个事物
    ```sql
    SET GTID_NEXT='aaa-bbb-ccc-ddd:N';
    BEGIN;
    COMMIT;
    SET GTID_NEXT='AUTOMATIC';
    ```

# 使用gtid的限制
- **涉及非事务性存储引擎的更新**：在同一事务中对使用非事务性存储引擎的表的更新与对使用事务性存储引擎的表的更新混合在一起可能导致将多个GTID分配给同一事务。

- CREATE TABLE ... SELECT语句：CREATE TABLE ... SELECT使用基于GTID的复制时，不允许使用这些语句

- 临时表：使用GTID（即，将系统变量设置为）时，事务，过程，函数和触发器内部不支持CREATE TEMPORARY TABLEand DROP TEMPORARY TABLE语句 。

- 跳过交易：sql_slave_skip_counter使用GTID时不支持。如果需要跳过事务，请改用master gtid_executed变量的值 。跳过空事务
