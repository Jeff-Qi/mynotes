---
title: MySQL Join 知识点
date: 2020-03-25 23:50:00
categories: MySQL
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [join语句](#join语句)
- [join连接算法](#join连接算法)
  - [NLJ](#nlj)
  - [Simple Nested-Loop Join](#simple-nested-loop-join)
  - [BNL](#bnl)
- [join小结](#join小结)
- [join优化](#join优化)
  - [Multi-Range Read （MRR算法）](#multi-range-read-mrr算法)
  - [Batched Key Access（BKA算法）](#batched-key-accessbka算法)
  - [对于BNL的优化](#对于bnl的优化)
- [参考文档](#参考文档)
<!-- TOC END -->
<!--more-->

# join语句
- 使用join语句可以将不同的表按照设置的条件进行连接操作，通过一次查询操作可以得到更多的信息
    ```sql
    SELECT * FROM TABLE_NAME t1 JOIN(straight_join) TABLE_NAME t2 ON CONDITION;
    ```
    - straight_join 让 MySQL 使用固定的连接方式执行查询，这样优化器只会按照我们指定的方式去 join。在这个语句里，t1 是驱动表，t2 是被驱动表。

    ![sql_join](http://study.jeffqi.cn/mysql/sql_join.jpg)

# join连接算法
- Index Nested-Loop Join（NLJ）
- Simple Nested-Loop Join（基本不会使用了，性能太差）
- Block Nested-Loop Join（BNL）

## NLJ
- **运行过程**：是先遍历表 t1，然后根据从表 t1 中取出的每行数据中的 a 值，去表 t2 中查找满足条件的记录。在形式上，这个过程就跟我们写程序时的嵌套查询类似，**并且可以用上被驱动表的索引**
    ![NLJ](http://study.jeffqi.cn/mysql/NLJ.jpg)

## Simple Nested-Loop Join
- 直接将驱动表和被驱动表一一连接在判断条件

## BNL
- **运行流程**：先将驱动表数据读入到join_buffer中，扫描表 t2，把表 t2 中的每一行取出来，跟 join_buffer 中的数据做对比，满足 join 条件的，作为结果集的一部分返回。
    ![BNL](http://study.jeffqi.cn/mysql/BNL.jpg)

- **join_buffer由join_buffer_size决定，如果数据太大，就需要分多次操作装入，复用join_buffer**

# join小结
- 在决定哪个表做驱动表的时候，应该是两个表按照各自的条件过滤，过滤完成之后，计算参与 join 的各个字段的总数据量，数据量小的那个表，就是“小表”，应该作为驱动表。

# join优化

## Multi-Range Read （MRR算法）
- MRR 的全称是 Multi-Range Read Optimization，是优化器**将随机IO转化为顺序IO**以降低查询过程中 IO 开销的一种手段，提高素具库的性能。

- 大多数的数据都是按照主键递增顺序插入得到的，所以我们可以认为，如果按照主键的递增顺序查询的话，对磁盘的读比较接近顺序读，能够提升读性能。

- random io and seq io

    ![seq_and_random_io](http://study.jeffqi.cn/mysql/seq_and_random_io.jpg)

- **运行流程**：根据索引 a，定位到满足条件的记录，将 id 值放入 read_rnd_buffer 中 ;将 read_rnd_buffer 中的 id 进行递增排序；排序后的 id 数组，依次到主键 id 索引中查记录，并作为结果返回。

    ![mrr_process](http://study.jeffqi.cn/mysql/mrr_process.jpg)

- **未使用MRR时读取数据**

    ![no_mrr_access](http://study.jeffqi.cn/mysql/no-mrr-access-pattern.png)

- **使用MRR时读取数据**

    ![mrr_access](http://study.jeffqi.cn/mysql/mrr-access-pattern.png)

## Batched Key Access（BKA算法）
- BKA算法是对join的优化，利用到了join_buffer，进而利用MRR的特性对于被驱动表上的索引的利用

- **工作流程**
    1.  BKA使用join buffer保存由join的第一个操作产生的符合条件的数据，**这个数据是顺序读到join_buffer中的**

    2.  然后BKA算法构建key来访问被连接的表，并批量使用MRR接口提交keys到数据库存储引擎去查找查找。（通过对join_buffer中的驱动表的数据，按照被驱动表尚可利用的索引进行排序，调用MRR接口进行顺序读，提高join性能）

    3.  提交keys之后，MRR使用最佳的方式来获取行并反馈给BKA

- **BKA使用join buffer size来确定buffer的大小，buffer越大，访问被join的表/内部表就越顺序。**

- 未使用BKA算法

    ![key_sort_regular_nlj](http://study.jeffqi.cn/mysql/key-sorting-regular-nl-join.png)

- 使用BKA算法

    ![key_sort_join](http://study.jeffqi.cn/mysql/key-sorting-join.png)

- mysql中BKA的启动
    ```sql
    set optimizer_switch='mrr=on,mrr_cost_based=off,batched_key_access=on';
    ```

- **BKA流程**

    ![bka_process](http://study.jeffqi.cn/mysql/BKA_process.png)

## 对于BNL的优化
- **BNL导致的性能问题**
    1. 如果一个使用 BNL 算法的 join 语句，多次扫描一个冷表，而且这个语句执行时间超过 1 秒，就会在再次扫描冷表的时候，把冷表的数据页移到 LRU 链表头部。
    2. 如果这个冷表的数据量过大，因为mysql的LRU算法，会导致热点数据被淘汰，导致内存命中率下降。只能通过后面的查询进行恢复内存命中率，这是一个持续的影响（详解需要了解mysql的LRU算法）
    3. 数据表过大，会给系统io造成较大的压力。这个是暂时的join完成后就结束了
    4. **为了减少这个影响，可以调大join_buffer_size的大小减少扫描的次数**

- BNL优化
    1. 在被驱动表上创建索引，使其能够使用到MRR优化
    2. 如果是部分数据，可以对其创建内存零时表，然后创建索引列，使用MRR优化

- Hash-join优化
    1. join_buffer维护的一个无需数组，这时性能低的原因之一；如果维护一个hash表，那么扫描对比的次数就会大大减少
    2. 目前mysql没有实现hash-join，可以通过将数据交给后端处理
        1. select * from t1;取得表 t1 的全部 1000 行数据，在业务端存入一个 hash 结构，比如 C++ 里的 set、PHP 的数组这样的数据结构。
        2. select * from t2 where b>=1 and b<=2000; 获取表 t2 中满足条件的 2000 行数据。
        3. 把这 2000 行数据，一行一行地取到业务端，到 hash 结构的数据表中寻找匹配的数据。满足匹配的条件的这行数据，就作为结果集的一行。

# 参考文档
- [ICP、MRR、BKA特性](https://www.cnblogs.com/chenpingzhao/p/6720531.html)
- [极客时间JOIN优化](https://time.geekbang.org/column/article/80147)
- [极客时间JOIN语句](https://time.geekbang.org/column/article/79700)
- [mariadb MRR](https://mariadb.com/kb/en/multi-range-read-optimization/#case-3-key-sorting-for-batched-key-access)
