### 讲讲mysql的mvcc并发控制
1.  mvcc 多版本并发控制；就是一个数据具有多个不同数据版本；在 mysql 中，每次在事务开始的时候，就是对当前的数据库状态记录下一个快照；以后所有的操作就是对于这个快照来进行的；这个体现了事物的隔离性；在拍快照时，这个事务会记录下当前所有正在活跃的事务的事务 ID；按照这个记录来划分高水位和低水位；比记录里最小的事务哈小的记为gao'shui

### mysql 的 myisam 引擎和 innodb 引擎的不同应该如何选择
1.  myisam 不支持事务，innodb 支持事务，能够进行事务的回滚
2.  myisam 不支持外键索引；innodb 支持
3.  myisam 非聚簇索引；innodb 是聚簇索引
4.  myisam 会保存行数；innodb 不会，通过 select count(\*) from table 来获取行数
5.  myisam 只有表锁，并发度不好；innodb 支持行锁
6.  如何选择：
    1.  是否要支持事务，如果要请选择 InnoDB，如果不需要可以考虑 MyISAM
    2.  如果表中绝大多数都只是读查询，可以考虑 MyISAM，如果既有读写也挺频繁，请使用InnoDB
    3.  崩溃恢复 myisam 比较困难

###
