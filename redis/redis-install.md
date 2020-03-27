---
title: redis 安装
data: 2020-02-22 22:48:00
categories: Redis
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [install redis on centos7](#install-redis-on-centos7)
<!-- TOC END -->
<!--more-->

# install redis on centos7

1.  下载安装包
    ```
    redis官网：http://download.redis.io/
    wget http://download.redis.io/releases/redis-5.0.7.tar.gz
    tar -xzvf redis-5.0.7.tar.gz
    ```
2.  编译安装
    ```
    cd redis-5.0.7
    make
    make test
    ```

3.  运行
    ```
    cd /src
    ./redis-server  # 默认配置启动
    ./redis-server &  # 后台启动
    # ./redis-server ../redis.conf  # redis.conf 为默认配置文件，可以修改
    ```

4.  测试
    ```
    ./redis-cli
    commond
    ```
