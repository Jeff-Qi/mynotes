---
title: redis 安装
data: 2020-02-22 22:48:00
categories: Redis
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [install redis on centos7](#install-redis-on-centos7)
- [参考文档](#参考文档)
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

    安装报错
    ```
    make[1]: Entering directory `/root/softwares/redis-5.0.8/src'
    You need tcl 8.5 or newer in order to run the Redis test
    make[1]: *** [test] Error 1
    解决：更新tcl
    wget http://downloads.sourceforge.net/tcl/tcl8.6.1-src.tar.gz  
    sudo tar xzvf tcl8.6.1-src.tar.gz  -C /usr/local/  
    cd  /usr/local/tcl8.6.1/unix/  
    sudo ./configure  
    sudo make  
    sudo make install   

    或者直接安装tcl
    yum install -y tcl(注意版本要满足要求)
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

# 参考文档
- [tcl报错](https://blog.csdn.net/zhangshu123321/java/article/details/51440106)
