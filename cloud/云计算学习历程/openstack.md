---
title: openstack起步
date: 2020-05-13 23:00:00
categories: Cloud
---
<!-- TOC -->

- [多平台](#多平台)
- [云平台](#云平台)
- [openstack](#openstack)
- [openstack基础环境搭建](#openstack基础环境搭建)
    - [实验准备](#实验准备)
    - [环境构建](#环境构建)
- [openstack keystone认证服务](#openstack-keystone认证服务)
    - [概念](#概念)
    - [keystone认证过程](#keystone认证过程)
    - [openstack keystone 认证服务部署](#openstack-keystone-认证服务部署)
- [openstack glance镜像服务](#openstack-glance镜像服务)
    - [概念](#概念-1)
    - [核心架构](#核心架构)
    - [安装部署](#安装部署)
- [openstack后续服务](#openstack后续服务)
- [参考文档](#参考文档)

<!-- /TOC -->
<!--more-->

# 多平台

1.  多主机/多用户：资源相互依赖影响，无隔离

2.  多单机/多虚拟机：资源共享，虚拟机相互隔离

3.  多主机/多虚拟机：资源调度、业务流程、用户和权限管理

# 云平台

- ## IaaS（基础设施即服务）
    
    1.  laaS负责管理虚机的生命周期，包括创建、修改、备份、起停、销毁等

    2.  使用者需要关心虚机的类型（OS）和配置（CPU、内存、磁盘），并且自己负责部署上层的中间件及用

- ## PaaS（平台即服务）
    
    1.  提供的服务是应用的运行环境和一系列中间件服务（比如数据库、消息日志）使用着只需要专注应用的开发，并将自己的应用和数据部署到PaaS环境中

    2.  面向开发人员

- ## SaaS（软件即服务）
    
    1.  使用者只需要登录使用应用，无需关心应用使用什么技术实现，也不需要关系应用部署在哪里

# openstack

- 定义：OpenStack对数据中心的计算、存储和网络资源进行同一管理，由此可见，OpenStack针对IT基础设施、是laaS这个层次的云操作系统。

- OpenStack为虚拟机提供并管理三大类资源：计算、网络和存储

- openstack 核心架构

    ![openstack-core]()

- ## 核心服务

    名称 | 服务
    ---|---
    Keystone | 认证服务，为各种服务提供认证和权限管理服务
    Glance | 镜像服务，管理VM启动时的镜像
    Nova | 计算服务，管理VM的生命周期
    Neutron | 网络服务，提供网络连接服务，负责为VM创建L2和L3网络
    Cinder | 块存储服务，Cinder的每一个Volume对于VM都像一块Disk
    Swift | 对象存储服务，VM通过Restful API存储对象数据（可选）

- ## 可选服务
    
    名称 | 服务
    ---|---
    Ceilometer | 监控计量服务，为报警、统计或计费提供
    Heat | 编排服务，管理编排资源，完成编排
    Horizon | 为Openstack用户提供一个Web的自服务Port
    Trove | 数据库服务，为数据库引擎提供云部署的
    Telemetry | 收集服务，对计量数据进行

- ## neutron组成架构

    1.  服务各个组成部分以及组件之间的逻辑关系，各个组件也能部署到不同的物理节点上

    2.  Openstack本身是一个分布式系统，不仅各服务可以分布部署，服务中的各个组件也可以分布部署。

    3.  极大的灵活性、伸缩性和高可用性，学习难度变大


# openstack基础环境搭建

## 实验准备
1.  centos7 * 2,每台两张网卡
2.  修改 /etc/hosts 文件，主机名解析
    1.  node1 controller
    2.  node2 computer
3.  关闭防火墙与selinux
4.  配置yum阿里源

## 环境构建

1.  设置时间同步

    ```sh
    yum install -y chrony

    # 修改配置文件（控制节点）
    vim /etc/chrony.conf
    server time1.aliyun.com iburst
    server 210.72.145.44 iburst
    server s1a.time.edu.cn iburst
    allow  192.168.31.0/24

    # 修改配置文件（计算节点）
    server controller iburst

    # 设置开机启动
    systemctl enable chronyd && systemctl restart chronyd

    # 测试同步
    chronyc sources

    # 修改时区命令
    时区修改命令：timedatectl set-timezone 'Asia/Shanghai'
    ```
    
2.  安装Opnestack包（Q版本）： 所有节点
    ```sh
    yum install centos-release-openstack-queens
    
    # 编辑配置文件修改baseurl国内源
    vim /etc/yum.repo.d/centos-openstack-queens
    [centos-openstack-queens]
    name=CentOS-7 - OpenStack queens
    #baseurl=http://mirror.centos.org/$contentdir/$releasever/cloud/$basearch/openstack-queens/
    baseurl=https://mirrors.aliyun.com/centos/7/cloud/x86_64/openstack-queens/

    # 安装客户端
    yum install python-openstackclient
    ```

3.  安装数据库（控制节点）
    ```sh
    yum install -y mariadb mariadb-server python2-PyMySQL

    # 修改编辑mariadb配置文件
    vim /etc/my.cnf.d/openstack.cnf
    [mysqld]
    bind-address = 0.0.0.0 // 绑定IP地址选择管理网络IP地址
    default-storage-engine = innodb
    innodb_file_per_table = on
    max_connections = 4096
    collation-server = utf8_general_ci
    character-set-server = utf8

    # 运行数据库
    systemctl enable mariadb && systemctl start mariadb

    # 初始化数据库
    mysql_secure_installation

    # 登录验证
    mysql -uroot -p
    ```

4.  安装消息队列（控制节点）
    ```sh
    yum install -y rabbitmq-server

    # 启动服务
    systemctl enable rabbitmq-server.service && systemctl start rabbitmq-server.service

    # 添加openstack用户（密码为openstack）
	rabbitmqctl add_user openstack openstack
	
    # 对openstack进行授权（rwx）
	rabbitmqctl set_permissions openstack ".*" ".*" ".*"

    # 检查默认监听的5672端口
    ss -ant | grep 5672
    ```

5.  安装缓存服务
    ```sh
    yum install -y memcached python-memcached

    # 修改配置文件
    vim /etc/sysconfig/memcached
    OPTIONS="-l 127.0.0.1,::1,controller"       # 启用其他节点访问

    # 启动服务
    systemctl enable memcached.service && systemctl start memcached.service

    # 检查监听默认11211端口
    ss -ant | grep 11211
    ```

6.  安装etcd服务
    ```sh
    yum install etcd

    # 修改配置文件
    vim /etc/etcd/etcd.conf
    ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
    ETCD_LISTEN_PEER_URLS="http://192.168.100.10:2380"
    ETCD_LISTEN_CLIENT_URLS="http://192.168.100.10:2379"
    ETCD_NAME="controller"
    ETCD_INITIAL_ADVERTISE_PEER_URLS="http://192.168.100.10:2380"
    ETCD_ADVERTISE_CLIENT_URLS="http://192.168.100.10:2379"
    ETCD_INITIAL_CLUSTER="controller=http://192.168.100.10:2380"
    ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
    ETCD_INITIAL_CLUSTER_STATE="new"

    # 启动服务
    systemctl enable etcd && systemctl start etcd

    # 检查默认端口2379和2380
    ss -ant | grep -E '2379|2380'
    ```

# openstack keystone认证服务

- keystone主要为openstack提供认证授权服务

## 概念

1.  User
    - 指代任何使用OpenStack 的实体，可以是真正的用户，其他系统或者服务

2.  Credentials
    - User 用来证明自己身份的信息，类比身份证。可以是：1. 用户名/密码2. Token 3. API Key 4. 其他高级方式

3.  Authentication
    - Keystone 验证User 身份的过程

4.  Token
    - token是由数字和字母组成的字符串，User 成功Authentication 后由Keystone 分配给User。类比通行证

5.  Project
    - 用于将OpenStack 的资源（计算、存储和网络）进行分组和隔离

    - 资源的所有权属于project

    - 每个user必须挂载在一个project上才能访问里面的资源

6.  Service
    - OpenStack 的Service 包括Compute (Nova)、Block Storage (Cinder)、bject Storage (Swift)、Image Service(Glance) 、Networking Service (Neutron) 等。

    - 每个Service 都会提供若干个Endpoint，User 通过Endpoint 访问资源和执行操作

7.  Endpoint
    - 是一个网络上可访问的地址，通常是一个URL。Service 通过Endpoint 暴露自己的API

8.  Role
    - 安全包含两部分：Authentication（认证）和Authorization（鉴权）Authentication 解决的是“你是谁？”的问题Authorization 解决的是“你能干什么？”的问题

    - 一个用户可被分配多个角色

    - Service 决定每个Role 能做什么事情Service 通过各自的policy.json 文件对Role 进行访问控制

## keystone认证过程
1.  用户使用credentials想keystone服务发起认证
2.  keystone认证完成后，返回token
3.  用户询问可以访问的project，keystone返回可访问的清单
4.  用户询问访问service的入口endpoint，keystone查询后返回结果
5.  用户拿着token去访问endpoint的服务
6.  service向keystone询问改token是否合法，然后提供或拒绝服务请求

## openstack keystone 认证服务部署

1.  创建keyston用户和keystone库
    ```sh
    mysql -uroot -p

    create database keystone;
    GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '1';
    GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '1';
    ```

2.  安装openstack-keystone httpd mod_wsgi
    ```sh
    yum install openstack-keystone httpd mod_wsgi

    # 修改keystone配置文件
    [database]
    ...
    connection = mysql://keystone:KEYSTONE_DBPASS@controller/keystone
    [memcache]
    ...
    servers = localhost:11211
    [token]
    ...
    provider = fernet
    [revoke]
    ...
    driver = sql

    # 认证身份初始化数据库
    su -s /bin/sh -c "keystone-manage db_sync" keystone

    # 登录查看数据库
    mysql -ukeystone -p
    use keystone;
    show tables;

    # 配置http服务
    vim /etc/httpd/conf/httpd.conf
    ServerName controller

    # 修改http配置
    ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/

    # 重启服务
    systemctl enable httpd.service && systemctl start httpd.service
    ```

3.  初始化fernet秘钥存储库
    ```sh
    keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
    keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
    ```

4.  引导身份认证（设置admin密码）（也可向官网那样，创建访问点endpoint，然后创建用户）
    ```sh
    keystone-manage bootstrap --bootstrap-password 000000 \
		  --bootstrap-admin-url http://controller:5000/v3/ \
		  --bootstrap-internal-url http://controller:5000/v3/ \
		  --bootstrap-public-url http://controller:5000/v3/ \
		  --bootstrap-region-id RegionOne
    ```

5.  导入系统变量
    ```sh
    export OS_USERNAME=admin
    export OS_PASSWORD=0        # （设置的admin的密码）
    export OS_PROJECT_NAME=admin
    export OS_USER_DOMAIN_NAME=Default
    export OS_PROJECT_DOMAIN_NAME=Default
    export OS_AUTH_URL=http://controller:5000/v3
    export OS_IDENTITY_API_VERSION=3
    ```

6.  创建project
    ```sh
    # 创建service project
	openstack project create --domain default --description "Service Project" service

	# 创建demo project
	openstack project create --domain default --description "Demo Project" demo
    ```

7.  创建demo用户,user角色
    ```sh
    # 创建demo用户
    openstack user create --domain default \
        --password-prompt demo
    
    # 闯将user角色
    openstack role create user

    # 授予user角色到demo项目和用户
    openstack role add --project demo --user demo user
    ```

8.  验证
    ```sh
    openstack token issue       # 确保环境变量导入真确
    ```

9.  扩展（通过脚本导入变量验证）
    ```sh
    vim admin-openstack-env.sh
    export OS_PROJECT_DOMAIN_NAME=Default
    export OS_USER_DOMAIN_NAME=Default
    export OS_PROJECT_NAME=admin
    export OS_USERNAME=admin
    export OS_PASSWORD=1        # 你设置的admin用户的密码
    export OS_AUTH_URL=http://controller:5000/v3
    export OS_IDENTITY_API_VERSION=3
    export OS_IMAGE_API_VERSION=2

    # 验证
    source admin-openstack-env.sh && openstack token issue
    ```

# openstack glance镜像服务

## 概念
-   OpenStack 的镜像服务 (glance) 允许用户发现、注册和恢复虚拟机镜像。它提供了一个 REST API，允许您查询虚拟机镜像的 metadata 并恢复一个实际的镜像。您可以存储虚拟机镜像通过不同位置的镜像服务使其可用，就像 OpenStack 对象存储那样从简单的文件系统到对象存储系统。

- 镜像：Image 是一个模板，里面包含了基本的操作系统和其他的软件

## 核心架构

- 核心架构图

    ![openstack-glance]()

1.  glance api
    - glance-api 是系统后台运行的服务进程。对外提供REST API，响应image 查询、获取和存储的调用

    - 不会真正处理请求。如果是与image metadata（元数据）相关的操作，glance-api 会把请求转发给glance-registry；如果是与image 自身存取相关的操作，glance-api 会把请求转发给该image 的store backend。

2.  glance-registry
    - glance-registry 是系统后台运行的服务进程。负责处理和存取image 的metadata，例如image 的大小和类型

    - 支持多种image格式

3.  Database
    - Image 的metadata会保持到database中

4.  Store backend
    - 存放image的地方

## 安装部署

1.  创建glance数据库和glance用户
    ```sh
    mysql -u root -p

    create database glance;
    GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '1';
    GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '1';
    ```

2.  导入环境变量获取admin用户权限
    ```sh
    source admin-openstack-env.sh
    ```

3.  创建glance用户,添加admin角色
    ```sh
    openstack user create --domain default --password-prompt glance
    openstack role add --project service --user glance admin
    ```

4.  创建服务实体
    ```sh
    # 创建service
    openstack service create --name glance --description "OpenStack Image service" image

    # 创建endpoint
    openstack endpoint create --region RegionOne image public http://controller:9292
    openstack endpoint create --region RegionOne image internal http://controller:9292
    openstack endpoint create --region RegionOne image admin http://controller:9292

    # 检查endpoint
    openstack endpoint list
    ```

5.  安装openstack-glance python-glance python-glanceclient
    ```sh
    yum install openstack-glance python-glance python-glanceclient

    # 修改/etc/glance/glance-api.conf配置文件
    vim /etc/glance/glance-api.conf
    [database]
    ...
    connection = mysql://glance:1@controller/glance
    [keystone_authtoken]
    ...
    auth_uri = http://controller:5000
    auth_url = http://controller:35357
    auth_plugin = password
    project_domain_id = default
    user_domain_id = default
    project_name = service
    username = glance
    password = 123      # 用户设置的openstack中glance用户的密码
    [paste_deploy]
    ...
    flavor = keystone
    [glance_store]
    ...
    default_store = file
    filesystem_store_datadir = /var/lib/glance/images/
    [DEFAULT]
    ...
    notification_driver = noop

    # 编辑/etc/glance/glance-registry.conf配置文件
    vim /etc/glance/glance-registry.conf
    [database]
    ...
    connection = mysql://glance:1@controller/glance
    [keystone_authtoken]
    ...
    auth_uri = http://controller:5000
    auth_url = http://controller:35357
    auth_plugin = password
    project_domain_id = default
    user_domain_id = default
    project_name = service
    username = glance
    password = 123      # 用户设置的openstack中glance用户的密码
    [paste_deploy]
    ...
    flavor = keystone
    [DEFAULT]
    ...
    notification_driver = noop

    # 同步数据库    
    su -s /bin/sh -c "glance-manage db_sync" glance

    # 登录验证数据库

    # 启动服务
    systemctl enable openstack-glance-api.service openstack-glance-registry.service
    systemctl start openstack-glance-api.service openstack-glance-registry.service
    ```

6.  导入环境变量
    ```sh
    export OS_IMAGE_API_VERSION=2   # 可加入前面的脚本中
    ```

7.  下载实验镜像
    ```sh
    wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.5-x86_64-disk.img
    ```

8.  上传镜像
    ```sh
    openstack image create "cirros" --file cirros-0.3.5-x86_64-disk.img --disk-format qcow2 --container-format bare --public
    ```

9.  验证
    ```sh
    openstack image list
    ```

# openstack后续服务


# 参考文档
- [openstack官方网站](https://www.openstack.org/)
- [openstack官方文档](https://docs.openstack.or)
    