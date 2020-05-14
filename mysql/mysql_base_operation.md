---
title: MySQL基本操作
date: 2020-04-05 19:00:00
categories: MySQL
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [数据库、表编码](#数据库表编码)
- [索引操作](#索引操作)
<!-- TOC END -->
<!--more-->

#  数据库、表编码
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

# 索引操作
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
