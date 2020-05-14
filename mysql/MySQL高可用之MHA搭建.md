---
title: MySQL高可用之MHA搭建
date: 2020-02-20 20:46:00
catogories: MySQL
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [MHA](#mha)
  - [简介](#简介)
  - [组成与工作原理](#组成与工作原理)
  - [工作过秤](#工作过秤)
  - [MHA软件](#mha软件)
- [部署MHA](#部署mha)
  - [配置主从复制](#配置主从复制)
    - [注意](#注意)
    - [节点配置](#节点配置)
  - [配置MHA](#配置mha)
- [检验](#检验)
<!-- TOC END -->
<!--more-->

# MHA

## 简介
- MHA（Master High Availability）目前在MySQL高可用方面是一个相对成熟的解决方案；是一套优秀的作为MySQL高可用性环境下故障切换和主从提升的高可用软件。在MySQL故障切换过程中，MHA能做到在0~30秒之内自动完成数据库的故障切换操作，并且在进行故障切换的过程中，MHA能在最大程度上保证数据的一致性，以达到真正意义上的高可用；

## 组成与工作原理
- 该软件由两部分组成：MHA Manager（管理节点）和MHA Node（数据节点）
- MHA Manager会定时探测集群中的master节点，当master出现故障时，它可以自动将最新数据的slave提升为新的master，然后将所有其他的slave重新指向新的master。整个故障转移过程对应用程序完全透明；
- 在MHA自动故障切换过程中，MHA试图从宕机的主服务器上保存二进制日志，最大程度的保证数据的不丢失；但是如果发生了硬件故障等就无法获取到日志，导致数据丢失。MHA可以与半同步复制结合起来。如果只有一个slave已经收到了最新的二进制日志，MHA可以将最新的二进制日志应用于其他所有的slave服务器上，因此可以保证所有节点的数据一致性；
- 至少需要三台服务器完成

## 工作过秤
1.  从宕机崩溃的master保存二进制日志事件（binlog events）;
2.  识别含有最新更新的slave；
3.  应用差异的中继日志（relay log）到其他的slave；
4.  应用从master保存的二进制日志事件（binlog events）；
5.  提升一个slave为新的master；
6.  使其他的slave连接新的master进行复制；

## MHA软件
- MHA软件由两部分组成，Manager工具包和Node工具包
  1.  Manager工具包
  ```
  masterha_check_ssh              检查MHA的SSH配置状况
  masterha_check_repl             检查MySQL复制状况
  masterha_manager                启动MHA
  masterha_check_status           检测当前MHA运行状态
  masterha_master_monitor         检测master是否宕机
  masterha_master_switch          控制故障转移（自动或者手动）
  masterha_conf_host              添加或删除配置的server信息
  ```
  2.  Node工具包
  ```
  save_binary_logs                保存和复制master的二进制日志
  apply_diff_relay_logs           识别差异的中继日志事件并将其差异的事件应用于其他的slave
  filter_mysqlbinlog              去除不必要的ROLLBACK事件（MHA已不再使用这个工具）
  purge_relay_logs                清除中继日志（不会阻塞SQL线程）
  ```
- 为了尽可能的减少主库硬件损坏宕机造成的数据丢失，因此在配置MHA的同时建议配置成MySQL 5.5的半同步复制

# 部署MHA

- 准备：四台服务器（一个manager节点，一个master节点，两个slave节点

## 配置主从复制
### 注意
  1.  开启二进制日志功能与中继日志
  2.  从节点显示开启read-only只读设置，并设置relay_log_purge = 0 清理中继日志的功能
  3.  每个节点的server-id不同

### 节点配置
- master节点配置
  ```sql
  server-id=1
  port=3306
  bind-address=0.0.0.0
  user=mysql
  log_bin=master-bin
  log-bin-index=master-bin.index
  relay-log=relay-bin
  relay-log-index=relay-bin.index
  binlog_format=row
  basedir=/usr
  tmpdir=/tmp
  relay_log_purge=0
  ```

- slave-1节点配置
  ```sql
  server-id=2
  port=3306
  bind-address=0.0.0.0
  user=mysql
  log_bin=master-bin
  log-bin-index=master-bin.index
  relay-log=relay-bin
  relay-log-index=relay-bin.index
  binlog_format=row
  basedir=/usr
  tmpdir=/tmp
  read-only
  relay_log_purge=0
  ```

- slave-2节点配置
  ```sql
  server-id=3
  port=3306
  bind-address=0.0.0.0
  user=mysql
  log_bin=master-bin
  log-bin-index=master-bin.index
  relay-log=relay-bin
  relay-log-index=relay-bin.index
  binlog_format=row
  basedir=/usr
  tmpdir=/tmp
  read-only
  relay_log_purge=0
  ```

- 配置完成后重启 MySQL 服务

## 配置MHA
- 管理节点安装manager和node软件；数据库节点安装node软件
- 软件地址：
  - mha4mysql-manager
    ```
    https://github.com/yoshinorim/mha4mysql-manager
    ```
  - mha4mysql-node
    ```
    https://github.com/yoshinorim/mha4mysql-node
    ```
-   安装rpm包
    ```
    yum localinstall ...
    ```

-   配置manager节点mha配置文件
  ```
  vim /etc/mha/cluster1.conf #没有文件需要自己创建

  [server default]
  user=test    #管理用户为数据库上的账户
  password=Hjqme525+   #管理密码
  manager_workdir=/data/mastermha/cluster1/     #mha工作路径
  manager_log=/data/mastermha/cluster1/manager.log   #mha日志文件
  remote_workdir=/data/mastermha/cluster1/      #每个远程主机的工作目录
  ssh_user=root
  repl_user=repl_user        #主从复制用户名称
  repl_password=Hjqme525+    #复制用户数据库密码
  ping_interval=1            #ping时间时长


  [server1]
  hostname=192.168.80.129  #主服务器IP地址
  candidate_master=1  #优先选为master节点
  [server2]
  hostname=192.168.80.130   #候选主服务器IP地址
  candidate_master=1  #优先选为master节点
  [server3]
  hostname=192.168.80.131
  ```

- 配置上所有节点见免密登陆，通过密钥对进行登陆

# 检验

1. 检验SSH登陆
    ```
    masterha_check_ssh --conf=/etc/mha/cluster1.cnf
    ```

2.   检验主从复制状况
    ```
    masterha_check_repl --conf=/etc/mha/cluster1.cnf
    ```

3.  启动MHA(前台开启)
    ```
    masterha_manager --conf=/etc/mha/cluster1.cnf
    ```

4.  查看MHA运行状态
    ```
    masterha_check_status --conf=/etc/mha/cluster1.cnf
    ```

# 参考文档
- [MySQL高可用之MHA搭建](https://www.cnblogs.com/xuanzhi201111/p/4231412.html)
