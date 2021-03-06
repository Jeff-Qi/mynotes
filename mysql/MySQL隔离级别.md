---
title: MySQL隔离级别
date: 2019-12-09 20:50:00
categories: MySQL
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [隔离性与隔离级别](#隔离性与隔离级别)
  - [隔离级别](#隔离级别)
    - [视图](#视图)
    - [事务隔离实现](#事务隔离实现)
  - [小结](#小结)
<!-- TOC END -->
<!--more-->

# 隔离性与隔离级别
- 当数据库上有多个事务同时执行的时候，就可能出现脏读（dirty read）、不可重复读（non-repeatable read）、幻读（phantom read）的问题

## 隔离级别
- 读未提交：一个事务还没提交时，它做的变更就能被别的事务看到
- 读提交：一个事务提交之后，它做的变更才会被其他事务看到
- 可重复读：一个事务执行过程中看到的数据，总是跟这个事务在启动时看到的数据是一致的。当然在可重复读隔离级别下，未提交变更对其他事务也是不可见的
- 串行化：对于同一行记录，“写”会加“写锁”，“读”会加“读锁”。当出现读写锁冲突的时候，后访问的事务必须等前一个事务执行完成，才能继续执行
- **隔离级别越高，并发性能越低**

### 视图
- 数据库在事务启动时会创建一个视图，整个事务过程都需要使用
- “读未提交”隔离级别下直接返回记录上的最新值，没有视图概念
- “串行化”隔离级别下直接用加锁的方式来避免并行访问
- 事务启动时的视图可以认为是静态的，不受其他事务更新的影响

### 事务隔离实现
- 实现：每条记录在更新时都记录有一条回滚操作，记录上的新值通过回滚操作回到上一个状态的值
- 回滚日志删除：系统判断没有比当前回滚日志更早的视图时自动删除
- **避免使用长事务**：长事务会使系统存在很老的视图，所以会一直保留回滚日志。照成较大的存储空间浪费；同时还有可能照成锁的占用，拖垮数据库

#### 事务启动方式
1. 显示启动事务：通过begin或者start transaction来启动事务，通过commit提交或rollback回滚

2. 隐式自动提交事务：系统设置 set autocommit=1 自动提交事务
  - 显示开启事务：使用 commit work and chain 来提交事务并自动开启下一个事务

3. 查看时间超过60s的长事务
    ```sql
    select * from information_schema.innodb_trx
    where TIME_TO_SEC(timediff(now(),trx_started))>60
    ```

## 小结
- 参数：transaction_isolation：查看数据库当前隔离状态
- 参数：MAX_EXECUTION_TIME：set MAX_EXECUTION_TIME来设置事务最大执行时间
