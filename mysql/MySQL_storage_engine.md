---
title: MySQL存储引擎
date: 2020-03-27 16:56
categories: MySQL
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [myisam引擎](#myisam引擎)
- [innodb引擎](#innodb引擎)
- [myisam与innodb对比](#myisam与innodb对比)
  - [事务性](#事务性)
<!-- TOC END -->
<!--more-->

# myisam引擎

# innodb引擎

# myisam与innodb对比

## 事务性
- **事务**：MyISAM不支持事务，InnoDB是事务类型的存储引擎

- **锁机制**：MyISAM只支持**表级锁**，BDB支持页级锁和表级锁默认为**页级锁**，而InnoDB支持行级锁和表级锁默认为**行级锁**
    - innodb锁加载索引上，[加锁规则](http://www.jeffqi.cn/2020/02/12/mysql/MySQL_lock/)；

- **外键**：MyISAM引擎不支持外键，InnoDB支持外键

- MyISAM引擎的表在大量高并发的读写下会经常出现表损坏的情况；相比于innodb来说更加脆弱
    - 修复：Mysql自带的myisamchk工具： myisamchk -r tablename  或者 myisamchk -o tablename（比前者更保险） 对表进行修复

- 对于count函数的支持，myisam有单独的计数，比innodb更快

- myisam支持fulltext全文索引，innodb无
