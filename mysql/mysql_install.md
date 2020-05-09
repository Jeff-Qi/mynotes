---
title: MySQL数据库安装
date: 2019-03-12 13:25:00
categories: MySQL
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [MySQL数据yum源安装](#mysql数据yum源安装)
  - [安装](#安装)
<!-- TOC END -->
<!--more-->

# MySQL数据yum源安装
- centos7下安装

## 安装

- ### 在线安装

1.  安装mysql的rpm包[rpm下载地址](https://dev.mysql.com/downloads/repo/yum/)
    ```sh
    # 安装rmp
    sudo yum localinstall mysql80-community-release-el7-{version-number}.noarch.rpm
    # 查看enable的安装包
    yum repolist enabled | grep "mysql.*-community.*"
    # 调整安装版本
    yum-config-manager --disable/--enable mysqlxx-community
    ```

    ![mysql_install_rpm_list]()

2.  在线安装mysql
    ```sh
    sudo yum install mysql-community-server
    ```

- ### 离线安装

1.  [下载安装包](https://dev.mysql.com/downloads/mysql/)
    ```sh
    wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.20-linux-glibc2.12-x86_64.tar.xz
    ```

2.  解压
    ```sh
    tar -xvf mysql-8.0.20-linux-glibc2.12-x86_64.tar.xz
    ```

3.  创建mysql用户和用户组
    ```sh
    grpadd -g 27 mysql
    useradd -u 27 -g 27 -s /sbin/nologin mysql
    ```

4.  修改mysql文件权限
    ```sh
    chown -R mysql:mysql /usr/local/mysql
    ```

5.  创建配置文件
    ```sh
    vim /etc/my.cnf

    [mysqld]
    basedir=/usr/local/mysql
    datadir=/usr/local/mysql/data
    socket=/var/lib/mysql/mysql.sock
    pid-file=/var/run/mysqld/mysqld.pid
    log-error=/var/log/mysqld.log
    bind-address=0.0.0.0
    port=3306
    #skip-grant-tables
    user=mysql
    tmpdir=/tmp
    log-bin=master-bin
    log-bin-index=master-bin.index
    server-id=1
    ```

6.  MySQL初始化
    ```sh
    /usr/local/mysql/bin/mysqld --initialize --user=mysql
    # 网上教程坑了，不需提前创建data数据目录。初始化会自动创建
    # 如果报错文件不存在，创建相应文件夹，修改权限，属主合所属组
    # 报错查看错误日志
    ```

7.  添加服务开机只启动
    ```sh
    cp /usr/local/mysql/support-files/mysql.server /etc/rc.d/init.d/mysqld
    systemctl enable mysqld.server
    # chkconfig --add mysqld
    ```

8.  启动服务
    ```sh
    systemctl start mysqld.server
    ```

9.  添加mysql环境变量
    ```sh
    echo "export PATH=$PATH:/usr/local/mysql/bin" >> /etc/bashrc
    source /etc/bashrc
    ```

10. 首次登陆密码位于mysql日志中，通过查看MySQL日志来获取
    ```sh
    mysql -uroot -p
    alter user 'root'@'localhost' identified with 'mysql_native_password' by 'password'
    ```
