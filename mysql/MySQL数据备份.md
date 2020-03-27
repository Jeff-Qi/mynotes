---
title: MySQL数据备份
date: 2019-11-26 19:00:00
categories: MySQL
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [物理备份](#物理备份)
  - [备份方式](#备份方式)
  - [热备份](#热备份)
  - [冷备份](#冷备份)
- [逻辑备份](#逻辑备份)
  - [mysqldump备份与还原数据](#mysqldump备份与还原数据)
  - [利用mysqlbinlog备份数据](#利用mysqlbinlog备份数据)
<!-- TOC END -->
<!--more-->

# 物理备份

## 备份方式
- 全量备份
- 增量备份

## 热备份

## 冷备份
- 将服务器关机，将数据复制到从服务器上。主服务器重启时会产生一个新的二进制日志文件。change master to 这个二进制日志文件。**明显的缺点，关机期间服务不可用**。


# 逻辑备份

## mysqldump备份与还原数据
1. 备份单/多库保留建库语句
  ```sql
  mysqldump -uroot -p --databases database_1_name [database_2_name] > /some/path/to/save
  ```
2. 备份多库与全库
  ```sql
  mysqldump -uroot -p --all-databases > /some/path/to/save
  ```
3. 还原数据库
  ```sql
  mysql -uroot -p < /file/to/return
  ```

## 利用mysqlbinlog备份数据
1. 查看二进制日志文件
  ```sql
  mysqlbinlog /binary/log
  mysqlbinlog --base64-output=decode-rows --verbose /binary/log/path
  ```
  - at：可以理解为事务的执行点

2. 选择还原点还原
  ```sql
  mysqlbinlog --stop-positon='point(at_point)' /binary/log/path
  ```

# 开源热备工具

## percona xtrabakup
