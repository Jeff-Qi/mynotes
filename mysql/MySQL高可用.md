---
title: MySQL高可用
date: 2020-02-20 19:53:00
categories: MySQL
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [MySQL高可用](#mysql高可用)
  - [主备延迟](#主备延迟)
  - [主备切换策略](#主备切换策略)
<!-- TOC END -->
<!--more-->

# MySQL高可用

## 主备延迟

- 主备延迟，就是同一个事务，在备库执行完成的时间和主库执行完成的时间之间的差值；
- 查看主备延迟
  ```sql
  show slave stauts;  /*second_behind_master 参数*/
  ```
- 关于 seconds_behind_master 参数
  - sbm参数事从服务器落后与主服务器的时间
  - 由于主服务器性能或者网络等问题，可能导致，主服务器的日志到达从服务器的时候就已经很慢，不能通过这个时间直接判断
    1. sbm出现NULL值：
        - 出现空值时主从复制就断了或者停止工作
    2. sbm值大于等于0：
        - 大于0时，则主从服务器已经数据不一致，有滞后现象
        - 等于0时，只能说明SQL解析线程relay_log到目前为止没有延迟
  - 稍微准确的方法
    1. 首先查看master_log_file参数，同relay_master_log_file参数的差异，比较日志的同步情况
    2. 其次查看read_master_log_pos和exec_master_log_pos参数的差异，比较日志的读取和执行差异
    3. 最后查看seconds_behind_master参数
  - 较新的GTID和pt工具
    1. 较新的GIID的复制方式有更好的方式来判断时间点主从复制的差异
    2. pt工具中的beatheart判断
      - pt工具：在主服务器上有一个库表，定时写入数据，从服务器读取来分析差异

- 主备延迟来源：
  1.  主备数据库服务器性能差距大
  2.  备库压力大，大量 DML 操作
  3.  大事务的执行是将过长
  4.  大表做 DDL 操作

- 主备延迟——过期读
  1.  强制走主库
  2.  sleep方法
  3.  判断主备延迟方法
  3.  配合使用semi-sync（半同步复制）
  4.  等主库位点
  5.  等GTID方法

## 主备切换策略
1.  可靠性优先策略
    - 数据一致性良好，但是可能照成数据库处于不可用状态。还可能照成数据暂时性丢失；
2.  可用性优先策略
    - 数据库不存在不可用状态，但是会造成数据不一致；
