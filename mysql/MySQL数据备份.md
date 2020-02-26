---
title: MySQL数据备份
date: 2019-11-26 19:00:00
categories: MySQL
---

## MySQL备份

### 物理备份

#### 备份方式
- 全量备份
- 增量备份

#### 热备份

#### 冷备份

### 逻辑备份

#### mysqldump备份与还原数据
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

#### 利用mysqlbinlog备份数据
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
