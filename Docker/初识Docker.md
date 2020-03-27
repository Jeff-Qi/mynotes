---
title: 初始Docker
date: 2019-11-29 11:07:00
categories: Docker
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [Docker第一步](#docker第一步)
  - [安装Docker](#安装docker)
  - [创建docker用户组](#创建docker用户组)
- [Docker国内镜像加速](#docker国内镜像加速)
- [Dockerfile](#dockerfile)
  - [定制](#定制)
  - [FROM 与 RUN 构建](#from-与-run-构建)
    - [FROM指定基础对象](#from指定基础对象)
    - [RUN执行命令](#run执行命令)
  - [命令](#命令)
    - [构建上下文Context](#构建上下文context)
  - [Dockerfile指令详解](#dockerfile指令详解)
    - [copy](#copy)
    - [add](#add)
    - [cmd](#cmd)
    - [entrypoint](#entrypoint)
    - [env与arg设置变量参数](#env与arg设置变量参数)
    - [volume](#volume)
    - [expose](#expose)
    - [workdir与user](#workdir与user)
    - [healthcheck](#healthcheck)
<!-- TOC END -->
<!--more-->

# Docker第一步

## 安装Docker
1. 安装必要工具
  ```sh
  yum install -y yum-utils \
  device-mapper-persistent-data.x86_64 \
  lvm2
  ```

2. 创建yum源repo文件
  ```sh
  yum-config-manager \
  --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo
  ```

3. 更新并安装
  ```sh
  yum update
  yum list docker-ce --showduplicates | sort -r
  yum install docker-ce-19.03.2-3.el7
  ```

## 创建docker用户组
- 默认情况下，docker 命令会使用Unix socket与Docker引擎通讯。而只有root用户和docker 组的用户才可以访问Docker引擎的Unix socket
- 使普通用户也能使用docker所以需要将用户加入docker用户组中

# Docker国内镜像加速
1. 镜像加速页
  - https://cr.console.aliyun.com/

2. 选择镜像加速服务

3. 启用
  ```sh
  sudo mkdir -p /etc/docker
  sudo tee /etc/docker/daemon.json \<<-'EOF'
  {
    "registry-mirrors": ["https://3hijzt0l.mirror.aliyuncs.com"]
  }
  EOF
  sudo systemctl daemon-reload
  sudo systemctl restart docker
  ```

# Dockerfile

## 定制
- 定制每一层所添加的配置、文件

## FROM 与 RUN 构建

### FROM指定基础对象
- Dockerfile 中FROM 是必备的指令，并且必须是第一条指令

### RUN执行命令
- 执行命令行命令
- 每一个指令都会建立一层
- 确保每一层只添加真正需要添加的东西，任何无关的东西都应该清理掉


## 命令
- 创建一个镜像
  ```sh
  docker build [option] <context上下文路劲>
  ```

### 构建上下文Context
- 一切都是使用的远程调用形式在服务端（Docker 引擎）完成
- docker build 命令得知这个路径后，会将路径下的所有内容打包，然后上传给Docker 引擎

## Dockerfile指令详解

### copy
- 格式
  ```sh
  COPY <源路径>... <目标路径>
  ```

- 使用COPY 指令，源文件的各种元数据都会保留。比如读、写、执行权限、文件变更时间等

### add
- 与copy相似
- ADD 指令将会自动解压缩这个压缩文件到<目标路径>
- ADD 指令会令镜像构建缓存失效，从而可能会令镜像构建变得比较缓慢

### cmd
- 用于指定默认的容器主进程的启动命令
- 对于容器而言，其启动程序就是容器应用进程，容器就是为了主进程而存在的，主进程退出，容器就失去了存在的意义，从而退出

### entrypoint
- 指定容器启动程序及参数
- 指定了ENTRYPOINT 后，CMD 的含义就发生了改变，不再是直接的运行其命令，而是将CMD 的内容作为参数传给ENTRYPOINT 指令

### env与arg设置变量参数
- ARG 所设置的构建环境的环境变量，在将来容器运行时是不会存在这些环境变量的

### volume
- 尽量保持容器存储层不发生写操作
- 数据持久化
- 格式
  ```sh
  VOLUME ["<路径1>", "<路径2>"...]
  VOLUME <路径>
  ```

- 匿名卷：任何写入操作都写入宿主机中不写入容器存储层。从而实现数据持久化

### expose
- 声明运行时容器提供服务端口，在运行时并不会开启这个端口的服务
- \-p参数是映射宿主端口和容器端口；EXPOSE 仅仅是声明容器打算使用什么端口而已，并不会自动在宿主进行端口映射

### workdir与user
- workdir:指定工作目录
- user:指定当前用户

### healthcheck
- 健康检查
- 如果程序进入死锁状态，或者死循环状态，应用进程并不退出，但是该容器已经无法提供服务
- HEALTHCHECK 支持下列选项：
  1. \--interval=<间隔> ：两次健康检查的间隔，默认为30 秒；
  2. \--timeout=<时长> ：健康检查命令运行超时时间，如果超过这个时间，本次健康检查就被视为失败，默认30 秒；
  3. \--retries=<次数> ：当连续失败指定次数后，则将容器状态视为unhealthy ，默认3 次
