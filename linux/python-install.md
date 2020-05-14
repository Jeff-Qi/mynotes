---
title: linux替换python3
date: 2020-02-21 10:56:00
catogories: Linux
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->

<!-- TOC END -->
<!--more-->

# python安装
1.  安装python
    ```
    yum install epel-release
    yum install python36 python36-devel
    ```

2.  替换bin文件
    ```
    mv /usr/bin/python /usr/bin/python.bak
    ln -s /usr/bin/python3.6 /usr/bin/python
    ```

3.  修改yum配置
    ```
    vim /usr/bin/yum
    vim /usr/libexec/urlgrabber-ext-down
    将文件 #!/usr/bin/python修改为#!/usr/bin/python2即可
    ```

4.  安装pip
    ```
    wget https://bootstrap.pypa.io/get-pip.py
    python get-pip.py
    ```


    ```sh
    yum -y install epel-release
    yum install -y python36 python36-devel
    mv /usr/bin/python /usr/bin/python.bak
    ln -s /usr/bin/python3.6 /usr/bin/python
    sed -i 's/python2/python/' /usr/bin/yum
    sed -i 's/python2/python/' /usr/libexec/urlgrabber-ext-down
    wget https://bootstrap.pypa.io/get-pip.py
    python get-pip.py
    ```

# 升级python版本
1.  下载[官网](https://www.python.org/ftp/python/)Python安装包

2.  解压并进入解压目录
    ```sh
    tar -xvf xxx
    cd xxx
    ```

3.  创建python安装目录
    ```sh
    mkdir /usr/local/python3.x
    ```

4.  编译(解压目录下)
    ```sh
    ./configure --prefix=/usr/local/python38
    ```

5.  安装
    ```sh
    make
    sudo make install
    ```

6.  备份就Python3文件
    ```sh
    mv /usr/bin/python3 /usr/bin/python3.backup
    ln -s /usr/local/python38/bin/python3 /usr/bin/python3
    ```

7.  检查
    ```sh
    python3 -V
    ```

8.  可能出现新建项目时无法使用pip，需要移动一个文件
    ```sh
    # 报错
    # （Error: Command '['/home/jerqi/untitled/bin/python3', '-Im', 'ensurepip', '--upgrade', '--default-pip']' returned non-zero exit status 2.）
    sudo rm /usr/bin/lsb_release
    ```
