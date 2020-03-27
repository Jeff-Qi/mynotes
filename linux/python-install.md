---
title: linux替换python3
date: 2020-02-21 10:56:00
catogories: Linux
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->

<!-- TOC END -->
<!--more-->

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
