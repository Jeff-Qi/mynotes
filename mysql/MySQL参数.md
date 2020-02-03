---
title: MySQL参数
date: 2020-2-3 13:50:00
tags: MySQL知识
categories: MySQL
---

# MySQL参数表

## 性能

| 名称 | 参数 | 详解 |
|---|---|---|
磁盘IO能力 | innodb_io_capacity | 传递给MySQL的磁盘IO能力，用于判断系统的能力
脏页比例 | innodb_max_dirty_pages_pct | 默认值是 75%。InnoDB 会根据当前的脏页比例（假设为 M），算出一个范围在 0 到 100 之间的数字。用于判断刷脏页的辅助判断
脏页邻居刷新 | innodb_flush_neighbors | 在准备刷一个脏页的时候，如果这个数据页旁边的数据页刚好是脏页，就会把这个“邻居”也带着一起刷掉。具有连坐特性。设为 0 则不刷新邻居脏页
刷新日志 | innodb_flush_log_at_trx_commit | 设置为1时在事务提交的时候需要将日志写入磁盘



## 系统

| 名称 | 参数 | 详解
|---|---|---|
脏页数 | Innodb_buffer_pool_pages_dirty |
buff pool 总页数 | Innodb_buffer_pool_pages_total |
表数据存储位置 | innodb_file_per_table | 设置为 OFF 表示的是，表的数据放在系统共享表空间，也就是跟数据字典放在一起；设置为 ON 表示的是，每个 InnoDB 表数据存储在一个以 .ibd 为后缀的文件中。当存在于共享表空间中时通过drop操作无法释放表空间。
