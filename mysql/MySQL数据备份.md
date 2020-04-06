---
title: MySQL数据备份
date: 2020-3-23 19:00:00
categories: MySQL
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [备份与恢复类型](#备份与恢复类型)
  - [热备份（联机备份）](#热备份联机备份)
  - [冷备份（脱机备份）](#冷备份脱机备份)
  - [远程备份与本地备份](#远程备份与本地备份)
  - [快照备份](#快照备份)
  - [全量备份与增量备份](#全量备份与增量备份)
  - [物理备份](#物理备份)
  - [逻辑备份](#逻辑备份)
- [备份工具方法](#备份工具方法)
  - [mysqldump备份与还原数据](#mysqldump备份与还原数据)
  - [复制文件进行备份（myisam引擎）](#复制文件进行备份myisam引擎)
  - [创建文本数据备份](#创建文本数据备份)
  - [二进制日志增量备份](#二进制日志增量备份)
- [开源热备工具](#开源热备工具)
  - [percona xtrabakup（捉急需要了解）](#percona-xtrabakup捉急需要了解)
- [备份与恢复](#备份与恢复)
  - [备份策略](#备份策略)
  - [数据恢复](#数据恢复)
<!-- TOC END -->
<!--more-->

# 备份与恢复类型
## 热备份（联机备份）
- 备份 **对其他客户端的干扰较小**，其他客户端可以在备份期间连接到MySQL服务器，并且可以根据其需要执行的操作来访问数据。

- **必须注意施加适当的锁定**，以免发生会损害备份完整性的数据修改。

## 冷备份（脱机备份）
- 将服务器关机，将数据复制到从服务器上。主服务器重启时会产生一个新的二进制日志文件。change master to 这个二进制日志文件。**明显的缺点，关机期间服务不可用**。

- 复制过程简单，数据不会受影响。但是客户端无法使用。

## 远程备份与本地备份
- mysqldump 可以连接到**本地或远程服务器**。对于SQL输出（CREATE和 INSERT语句），备份拿出来的**数据文件可以在本地或远程主机上**。

- select ... into outfile可以**连接到本地或远程服务器**，但**生成的备份文件只能在服务器上**。

- 物理备份方法**通常在MySQL服务器主机上**，以便使服务器脱机，尽管复制文件的目的地可能是远程的。

## 快照备份
- **基于某一个时间点对数据的逻辑备份**。MySQL本身不提供获取文件系统快照的功能。它可以通过Veritas，LVM或ZFS等第三方解决方案获得。

## 全量备份与增量备份
- 完全备份包括在给定时间点由MySQL服务器管理的所有数据。

- 增量备份包括在给定时间段（从一个时间点到另一个时间点）内对数据所做的更改。

- MySQL有执行完全备份的方法有多重。通过启用服务器的二进制日志（服务器用于记录数据更改），可以进行增量备份。

## 物理备份
- 物理备份 **由存储数据库内容的目录和文件的原始副本组成**。这种类型的备份适用于 **大型的重要数据库**，这些数据库在出现问题时需要快速恢复。

- ## 物理备份特点
    - 备份由数据库目录和文件的精确副本组成。通常，这是全部或部分MySQL数据目录的副本。

    - 物理备份方法比逻辑备份方法快，因为它们仅涉及文件复制而不进行转换。

    - 输出比逻辑备份更紧凑。

    - 备份和还原的 **粒度范围从整个数据目录级别到单个文件级别**。是否有表级别粒度，具体取决于存储引擎。例如， InnoDB每个表可以位于单独的文件中，或与其他InnoDB表共享文件存储 ；例如，每个 MyISAM表唯一地对应于一组文件。

    - 除了数据库之外，备份 **还可以包括任何相关文件，例如日志或配置文件**。

    - 备份只能移植到具有相同或相似硬件特性的其他计算机上。

    - **备份工具** 包括对于企业版mysql的innodb引擎或者其他表的 **mysqlbackup**，或者是对于备份myisam表的 **系统命令(cp、scp、tar)**。

- ## 还原物理备份数据
    - mysqlbackup工具还原
    - ndb_restore还原 NDB表。
    - 可以使用文件系统命令将在文件系统级别复制的文件复制回其原始位置。

## 逻辑备份
- 逻辑备份保存表示为 **逻辑数据库结构**（CREATE DATABASE， CREATE TABLE语句）和 **内容**（INSERT语句或定界文本文件）的信息。这种类型的备份适用于 **少量数据**，您可以在其中编辑数据值或表结构，或在其他计算机体系结构上重新创建数据。

- ## 逻辑备份特点
    - 通过查询MySQL服务器以获得数据库结构和内容信息来完成备份。

    - 备份比物理方法慢，因为服务器必须访问数据库信息并将其转换为逻辑格式。如果输出是在客户端编写的，则服务器还必须将其发送到备份程序。

    - 备份产生的文件比较大

    - 备份和还原粒度在服务器级别（所有数据库），数据库级别（特定数据库中的所有表）或表级别可用。无论存储引擎如何，都是如此。**相比于物理备份更加细粒度**

    - **备份无日志等其他文件，至于数据库数据有关的数据才会保留**。

    - 可移植性更高

    - 在物理机运行时可备份。

    - **备份工具** 包括 **mysqldump** 和 select ... into outfile。**适用于任何存储引擎**

# 备份工具方法

## mysqldump备份与还原数据
- mysqldump创建数据库副本可以使您以一种格式捕获数据库中的所有数据，该格式可以将信息导入到MySQL Server的另一个实例中

- 由于信息的格式为SQL语句，因此在需要紧急访问数据时，可以轻松地将该文件分发并应用于正在运行的服务器。但是，如果数据集的大小很大，则mysqldump可能不切实际。

- **使用mysqldump时，应在开始转储过程之前停止从属服务器上的复制，以确保转储包含一致的数据集**


1. 备份单/多库保留建库语句
  ```sql
  mysqldump -uroot -p --databases database_1_name [database_2_name] > /some/path/to/save

  # 备份单库是可以忽略 --databases 参数，备份文件不会携带 create database 或者 use 语句。所以在使用该文件恢复数据是需要先 create database 和 use db_name
  mysqldump -uroot -p database_1_name > /some/path/to/save

  # 也可以备份一库多表
  mysqldump -uroot -p database_1_name table_1_name table_2_name > /some/path/to/save
  ```

2. 备份全库
  ```sql
  mysqldump -uroot -p --all-databases > /some/path/to/save
  ```

![mysqldump_with_gtid](http://study.jeffqi.cn/mysql/mysqldump_with_gtid.jpg)

![mysqldump_without_gtid](http://study.jeffqi.cn/mysql/mysqldump_without_gtid.jpg)

3. 还原数据库
  ```sql
  # 外部命令行
  mysql -uroot -p < /file/to/return

  # 内部命令
  source /file/to/return
  ```

## 复制文件进行备份（myisam引擎）
- 可以通过复制表文件（\*.MYD，\*.MYI文件和关联 \*.sdi文件）来备份MyISAM表。要获得一致的备份，请停止服务器或锁定并刷新相关表。
    ```sql
    FLUSH TABLES tbl_list WITH READ LOCK; # 锁表
    ```

## 创建文本数据备份
- 要创建包含表数据的文本文件，来对数据进行备份。

- **此方法适用于任何类型的数据文件，但仅保存表数据，而不保存表结构。**
    ```sql
    SELECT * INTO OUTFILE '/path/to/save/file' FROM tbl_name
    ```

    ![select_into_outfile](http://study.jeffqi.cn/mysql/select_into_outfile.jpg)

- 恢复数据
    ```sql
    # load data命令
    load data infile '/path/for/file/to/return' into table table_name;

    # mysqlimport
    mysqlimport -u root -p --local table_name /path/for/file/to/return
    ```

    ![load_data_infile_into_table](http://study.jeffqi.cn/mysql/load_data_infile_into_table.jpg)

## 二进制日志增量备份
- 二进制日志文件为您提供了将更改复制到数据库的信息，这些更改是在执行备份之后进行的。

- 开启二进制日志
    ```sql
    log_bin=/path/to/save/binlog
    ```

1. 查看二进制日志文件
  ```sql
  mysqlbinlog /binary/log
  mysqlbinlog --base64-output=decode-rows --verbose /binary/log/path
  ```
  - at：可以理解为事务的执行点

2. 选择还原点还原
    1.  基于时间点恢复：使用 --start-datetime和 --stop-datetime 选项来指定时间
        ```sql
        mysqlbinlog --stop-datetime="2005-04-20 9:59:59"  /var/log/mysql/bin.123456 | mysql -u root -p
        ```

    2.  基于位点的恢复：使用 --start-position 和 --stop-position 选项可用于指定日志位置。
        ```sql
        mysqlbinlog --stop-position=368312 /var/log/mysql/bin.123456 | mysql -u root -p
        ```
# 开源热备工具

## percona xtrabakup（捉急需要了解）

# 备份与恢复

## 备份策略
- 对于数据需要有周期性的备份操作。这里针对 mysqldump 展开。

1.  可以每天在业务低峰期对于数据进行一次定时任务进行全量备份
    ```sql
    mysqldump --all-databases --single-transaction > /some/place/to/save/file
    ```
    - 首先会对于全库进行锁表操作（flash tables with read lock）。一旦或得到这个锁就会读取二进制日志坐标，并释放这个锁。如果因为有长事务更新，可能会不能获得到锁，会暂停备份，直到长事务结束。之后，转储将变为无锁状态，并且不会干扰对表的读写。

    -  --single-transaction 参数使用一致的读取并保证mysqldump看到的数据 不会更改。

2.  全库备份是必须的，但是备份出来的文件比较大，不方便，同时也会占用性能，需要花费较长时间。所以一般采用长时间的全库备份，加上短期的增量备份。需要的额外代价是，在恢复数据时，需要使用全库备份文件和增量备份文件来恢复。

3.  增量备份通过二进制日志来进行。需要告知服务器开启二进制日志。在全量备份时刷新二进制日志。
    ```sql
    mysqldump --single-transaction --flush-logs --master-data=2 --all-databases > /some/place/to/save/file
    ```
    - --flush-logs 选项导致服务器刷新其日志。--master-data选项使 mysqldump将二进制日志信息写入其输出。

## 数据恢复
1.  首先使用全量备份文件进行恢复数据
    ```sql
    mysql -uroot -p < /file/to/return
    ```

2.  使用增量binlog恢复
    ```sql
    mysqlbinlog binglog_1_name [binlog_2_name] | mysql -uroot -p
    ```
