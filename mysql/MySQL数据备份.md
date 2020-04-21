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
  - [percona xtrabakup](#percona-xtrabakup)
- [备份与恢复](#备份与恢复)
  - [备份策略](#备份策略)
  - [数据恢复](#数据恢复)
- [参考文档](#参考文档)
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

## percona xtrabakup

- ### xtrabackup
    **工作机制**：xtrabackup的工作基于**innodb存储引擎的崩溃恢复功能力**进行的。复制完数据库的数据之后，通过崩溃恢复的功能来进行数据的恢复。保持数据的一致性。崩溃护肤功能基于innodb的内置的redo-log日志。**在恢复数据时对于已经提交的事务直接重做应用；未提交的事务进行回滚**。相比于mysqldump等工具来说，xtrabackup工具是**物理备份**，对于数据直接拷贝。同时对系统的影响较小，基本不会阻塞线上的业务的运行。

    **工作流程**：

        1.  启动xtra进程开启一个子进程对redo-log进行持续复制。如果redo-log发生了改动，也会进行复制操作。

        2.  启动另一个子进程，对innodb存储引擎的数据库的数据和日志进行复制

        3.  复制完所有innodb/xtradb数据和日志后，对所有myisam和其他非innodb表执行锁定操作（LOCK BINLOG FOR BACKUP）；进行数据的复制（此阶段数据库短暂不可写）

        4.  非事务表复制完成后，会停止复制线程，记录日志的坐标。同时停止redo-log日志的复制。

        5.  对于上锁的数据进行解锁

        6.  完成复制

    **恢复数据**：

        1.  首先读取配置文件 my.cnf 检查相应的文件是否存在

        2.  之后会首先复制恢复非事务表和数据

        3.  恢复innodb表和数据

        4.  最后是二进制日志

        5.  需要修改文件的权限归属等信息

    ![xtrabakup_process](http://study.jeffqi.cn/mysql/xtrabackup-process.png)

- ### 安装
    1.  安装rpm包
        ```sh
        yum install https://repo.percona.com/yum/percona-release-latest.noarch.rpm
        # 也可以从官网下载rpm的安装包进行直接安装
        ```

    2.  启用存储库
        ```sh
        percona-release enable-only tools release
        ```

    3.  安装xtrabackup
        ```sh
        yum install percona-xtrabackup-80
        ```

    4.  卸载xtrbackup
        ```sh
        yum remove percona-xtrabackup
        ```

- ### 基本使用
    ```sh
    xtrabackup \
    --user=user_name \
    --password=password \
    --host=host_ip \
    --port=port_number \
    --socket=/path/to/socker \
    --backup \
    --target-dir=/data/bkps/
    ```

    **创建备份用户，分配必要权限**
    ```sql
    create user 'bkpuser'@'%' identified with 'mysql_native_password' by 'Hjqme525+';
    grant reload,lock tables,backup_admin,replication client,create \
    tablespace,process,super,create,insert, select on *.* to 'bkpuser'@'%';
    ```

- #### 全量备份

    **创建全量备份**
    ```sh
    xtrabackup --backup \
    --host=xxx.xxx.xxx.xxx --user=bkpuser --port=3306 --password \
    --target-dir=/tmp/xtrabackup.test
    ```

    **准备备份**
    ```sh
    xtrabackup --prepare --target-dir=/tmp/xtrabackup.test
    ```

    **恢复备份**
    ```sh
    xtrabackup --copy-back --target-dir=/mysql/data/dir   # --move-back：删除备份数据
    ```

    --copy-back参数与--move-back参数的区别：**copyback在复制完数据后，会保存当前的文件，而moveback在复制完成后会删除备份文件**

    **重启数据库**
    ```sh
    chmod -R mysql:mysql /mysql/data/dir
    systemctl restart mysqld
    ```

- #### 增量备份（基于全量备份）
    **创建全量备份**
    ```sh
    xtrabackup --backup \
    --host=xxx.xxx.xxx.xxx --user=bkpuser --port=3306 --password \
    --target-dir=/root/data2.data
    ```

    **基于全量备份的增量备份**
    ```sh
    xtrabackup --backup --host=192.168.80.128 --user=root --password \
    --target-dir=/root/data2.increment.data \
    --incremental-basedir=/root/data2.data/
    ```

    **增量备份时需要指定基础的文件**

    **插入**
    ```sql
    delimiter //
    create procedure xtratest2()
        begin
        declare i int;
        declare a int;
        set i=1;
        set a=1;
            begin
            while i<=10000 do
            insert into d3.t1(id,a) values (i,a);
            set i=i+1;
            set a=a+1;
            end while;
            end;
        end
        //
      delimiter ;
      call xtratest2();
      ```

    **基于增量备份的增量备份**
    ```sh
    xtrabackup --backup --host=192.168.80.128 --user=root --password \
    --target-dir=/root/data2.increment2.data \
    --incremental-basedir=/root/data2.increment.data/
    ```

    **准备全量备份**
    ```sh
    xtrabackup --prepare --apply-log-only --target-dir=/root/dada2.data/
    ```

    **对于需要恢复增量备份的数据，其全量备份还原时需要添加 --apply-log-only 参数，否则后续增量备份不可用**

    **恢复增量备份**
    ```sh
    xtrabackup --prepare --apply-log-only --target-dir=/root/data2.data/ \
    --incremental-dir=/root/data2.increment.data/
    ```

    ```sh
    xtrabackup --prepare --apply-log-only --target-dir=/root/data2.data/ \
    --incremental-dir=/root/data2.increment2.data/    
    ```

    **一个增量备份文件只恢复一次不要重复恢复**

    **恢复备份**
    ```sh
    xtrabackup --copy-back --target-dir=/root/dada2.data/
    chown -R mysql:mysql /var/lib/mysql
    ```

- #### 压缩备份
    **压缩备份**
    ```sh
    xtrabackup --backup --host=192.168.80.128 --user=root --password \
    --compress --compress-threads=2 \
    --target-dir=/root/data3.data
    ```

    **解压备份**
    ```sh
    yum install qpress-11-1.el7.x86_64    # 注意安装qpress软件，可以通过安装rpm来找到相应的软件
    xtrabackup --decompress --target-dir=/root/data3.data/
    ```

    **准备备份**

    **恢复备份**


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

# 参考文档
- [xtrabakup备份入门](https://www.cnblogs.com/linuxk/p/9372990.html)
- [percona-xtrabakup-documents](https://www.percona.com/doc/percona-xtrabackup/8.0/index.html)
- [xtrabakup流处理](https://www.percona.com/doc/percona-xtrabackup/2.4/howtos/recipes_ibkx_stream.html)
- [mysqldump文档](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html)
- [mysqlbinlog文档](https://dev.mysql.com/doc/refman/8.0/en/mysqlbinlog.html)
- [mysql数据备份](https://dev.mysql.com/doc/refman/8.0/en/backup-and-recovery.html)
