---
title: docker compose
date: 2020-02-23 11:04:00
categories: Docker
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [docker compose](#docker-compose)
  - [简介](#简介)
  - [安装](#安装)
  - [文件及目录创建](#文件及目录创建)
    - [项目目录](#项目目录)
- [测试](#测试)
<!-- TOC END -->
<!--more-->

# docker compose

## 简介
- 负责实现对Docker 容器集群的快速编排
- 允许用户通过一个单独的docker-compose.yml 模板文件（YAML 格式）来定义一组相关联的应用容器为一个项目（project）
- compose 中有两个重要的概念：
    1.  任务（task）：一个容器被称为一个任务。任务拥有独一无二的ID ，在同一个服务中的多个任务序号依次递增。
    2.  服务（service）：某个相同应用镜像的容器副本集合，一个服务可以横向扩展为多个容器实例。
    3.  服务栈（stack）：由多个服务组成，相互配合完成特定业务，如Web 应用服务、数据库服务共同构成Web 服务钱，一般由一个docker-cornpose . yaml 文件定义

-   Compose 掌管运行时的编排能力。使用Compose模板文件，用户可以编写包括若干服务的一个模板文件快速启动服务栈；分发给他人，也可快速创建一套相同的服务栈。

## 安装
- pip安装
    ```
    pip install -U docker-compose
    docker-compose version
    ```

## 文件及目录创建

### 项目目录

1. 编写 docker-compose.yml 文件
```
version: '2'
services:
    mysql:
        network_mode: "bridge"
        environment:
            MYSQL_ROOT_PASSWORD: "Hjqme525-"
            MYSQL_USER: "jerqi"
            MYSQL_PASS: "Hjqme525+"
        image: "docker.io/mysql:latest"
        restart: always
        volumes:
            - "./data:/var/lib/mysql"
            - "./conf/my.cnf:/etc/my.cnf"
            - "./init:/docker-entrypoint-initdb.d/"
        ports:
            - "6363:3306"
```

2. 编写 my.cnf 配置文件（安装MySQL）
```
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid

[mysqld]
user=mysql
default-storage-engine=INNODB
character-set-server=utf8
[client]
default-character-set=utf8
[mysql]
default-character-set=utf8
```
3. 编写初始化文件 init.sql（MySQL初始化）
```
use mysql;
alter user 'root'@'localhost' identified with 'mysql_native_password' by 'Hjqme525-';
update user set host = '%' where user = 'root';
flush privileges;
update mysql set host = '%' where user = 'root';
create database `test`;
use test;
create table `t1`
(
id int primary key auto_increment,
age int check 'age >= 1'
);
insert into `t1`
values
(1,1),(2,2),(3,3),(4,4);
```

4. 文件目录
```
docker_mysql
├── conf
│   └── my.cnf
├── data
├── docker-compose.yml
└── init
    └── init.sql
```

# 测试
1. 下拉镜像
    ```
    docker-compose pull
    ```

2. 运行
    ```
    docker-compose up -d
    ```
