---
title: 从删库到跑路到恢复数据
date: 2020-03-28 10:21:00
categories: MySQL
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [删数据情况](#删数据情况)
<!-- TOC END -->
<!--more-->

# 删数据情况
1.  使用 **delete** 语句误删数据行；
2.  使用 **drop table** 或者 **truncate table** 语句误删数据表；
3.  使用 **drop database** 语句误删数据库；
4.  使用 **rm** 命令误删整个 MySQL 实例。

  - ## 删除行数据
      在进行dml操作后，如果意外的更新删除了错误的数据可以使用flashback工具进行恢复

      [flashback工具](https://mariadb.com/kb/en/flashback/)

      **当前仅在DML语句（INSERT，DELETE，UPDATE）上支持闪回**。即将发布的MariaDB版本将通过将当前表复制或移动到保留和隐藏的数据库，然后在使用闪回时复制或移回来增加对DDL语句（DROP，TRUNCATE，ALTER)支持。

      **flashback只适用于row格式日志和full记录**
          ```sql
          binlog_format=row
          binlog_row_image=full
          ```

      ![flashback_row_full.jpg](http://study.jeffqi.cn/mysql/flashback_row_full.jpg)

      **工作机制**：flash的实际工作由mysqlbinlog与--flashback一起完成。这将导致事件被转换：从INSERT到DELETE，从DELETE到INSERT，并且对于UPDATE，交换之前和之后的图像。

      ```sh
      mysqlbinlog /path/to/binlog -vv -d db_name -T table_name \
      --start-datetime '2020-02-03 17:00:00' --flashback > flash.sql
      mysql < flash.sql
      ```

      避免数据的误操作，我们急需做的是预防；
          1.  sql_safe_updates 参数设置为 on；对于语句进行检查，需要添加where才能使用
          2.  上线前对sql进行审计

  - ## 误删表/库
      使用全量备份，加增量日志；**这个方案要求线上有定期的全量备份，并且实时备份 binlog**。

      1.  取最近一次全量备份，假设这个库是一天一备，上次备份是当天 0 点；
      2.  用备份恢复出一个临时库；从日志备份里面，取出凌晨 0 点之后的日志；
      3.  把这些日志，除了误删除数据的语句外，全部应用到临时库。

      ![data_repair_after_drop_tables_or_databases](http://study.jeffqi.cn/mysql/data_repair_after_drop_tables_or_databases.png)

      - 可以在使用 mysqlbinlog 命令时，加上一个–database 参数，用来指定误删表所在的库。避免在恢复数据时还要应用其他库日志的情况。

      - 使用-stop-position与-start-position来跳过误操作；或者使用GTID方案

      - **加速恢复**：在用备份恢复出临时实例之后，将这个临时实例设置成线上备库的从库；在 start slave 之前，先通过执行﻿﻿change replication filter replicate_do_table = (tbl_name) 命令，就可以让临时库只同步误操作的表；这样做也可以用上并行复制技术，来加速整个数据恢复过程。（需要注意可能备库上没有需要的增量日志需要从备库系统下载，然后添加日志信息到master.index中，让数据库能够识别）

      ![data_repair_use_replecation.png](http://study.jeffqi.cn/mysql/data_repair_use_replecation.png)

  - ## 延迟复制备库
      延迟复制的备库是一种特殊的备库，通过 CHANGE MASTER TO MASTER_DELAY = N 命令，可以指定这个备库持续保持跟主库有 N 秒的延迟。
  - ## rm 删除数据
      集群就是做一个高可用只要不是删除了集群这个数据库的信息HA就能够工作选出新的主库
