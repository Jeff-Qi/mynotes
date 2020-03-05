---
title: docker machine
date: 2020-02-24 13:42:00
categories: Docker
---

## docker machine

### 简介
- 短时间内在本地或云环境中搭建一套 Docker 主机集群；负责实现对Docker 运行环境进行安装和管理
- 基本功能
    1.  在指定节点或平台上安装Docker 引擎，配置其为可使用的Docker 环境；
    2.  集中管理（包括启动、查看等）所安装的 Docker 环境

### 安装Machine
1.  下载编译好的二进制文件
    - docker machine安装教程 git 网址：https://github.com/docker/machine/releases/
    ```
    curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` > /tmp/docker-machine &&
    chmod +x /tmp/docker-machine &&
    sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
    ```

3.  检查安装是否完成
    ```
    docker-machine version
    ```

2.  创建docker主机
    ```
    docker-machine -d 驱动 --generic-ip-address='ip' name
    ```
