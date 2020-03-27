---
title: MySQL高可用之主从复制搭建
date: 2019-11-07 18:21:07
categories: MySQL
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [配置主服务器](#配置主服务器)
<!-- TOC END -->
<!--more-->

# 配置主服务器
1. 修改master配置文件

  ```
  [mysqld]
  user=mysql
  pid-file=/var/run/mysqld/mysqld.pid

  socket=/var/lib/mysql/mysql.sock
  port=3306  

  basedir=/usr
  datadir=/var/lib/mysql

  tmpdir=/tmp
  server-id=1

  log-bin=master-bin
  log-bin-index=master-bin.index
  log-error=/var/log/mysqld.log
  bind-address=0.0.0.0
  ```

2. 创建一个用于复制的用户
  ```
  create user 'repl_user'@'%' identified with 'mysql_native_password' by '123456';
  grant replication slave on *.* to 'repl_user'@'%';
  ```

3. 重启master服务器的MySQL服务
  ```
  systemctl restart mysqld
  ```

4. 配置slave配置文件
  ```
  [mysqld]
  user=mysql
  pid-file=/var/run/mysqld/mysqld.pid

  socket=/var/lib/mysql/mysql.sock
  port=3306  

  basedir=/usr
  datadir=/var/lib/mysql

  tmpdir=/tmp
  server-id=2

  relay-log=slave-relay-bin
  relay-log-index=slave-relay-bin.index
  log-error=/var/log/mysqld.log
  bind-address=0.0.0.0
  ```

5. 重启slave服务器MySQL服务
  ```
  systemctl restart mysqld
  ```

6. slave切换master（MySQL服务中）
  ```
  change master to
    master_host='ip',
    master_port=3306,
    master_user='repl_user'
    master_password='123456',
    <!-- Master_log_file='',
    master_log_pos='' -->
    master_auto_position=1;

  start slave
  ```

7. 查看状态
  ```
  mysql> show slave status\G

               Slave_IO_State: Waiting for master to send event   //检查
                  Master_Host: xxx.xxx.xxx.xxx
                  Master_User: repl_user
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: master-bin.000001
          Read_Master_Log_Pos: 3117
               Relay_Log_File: slave-relay-bin.000002
                Relay_Log_Pos: 3333
        Relay_Master_Log_File: master-bin.000001
             Slave_IO_Running: Yes                                //检查
            Slave_SQL_Running: Yes                                //检查
                   Last_Errno: 0
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 3117
              Relay_Log_Space: 3541
              Until_Condition: None
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
               Last_SQL_Errno: 0
             Master_Server_Id: 1
                  Master_UUID: 74be5d5f-9fe5-11e9-8853-e02651c
             Master_Info_File: mysql.slave_master_info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for more updates //检查
           Master_Retry_Count: 86400
                Auto_Position: 0
        Get_master_public_key: 0
1 row in set (0.00 sec)
  ```
