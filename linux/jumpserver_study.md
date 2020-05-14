---
title: jumpserver基础学习
date: 2020-4-21 9:16:00
categories: Linux
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [jumpserver简介](#jumpserver简介)
- [jumpserver安装使用](#jumpserver安装使用)
- [参考文档](#参考文档)
<!-- TOC END -->
<!--more-->

# jumpserver简介
    1. JumpServer 是全球首款完全开源的堡垒机, 使用 GNU GPL v2.0 开源协议；
    2. 使用 Python / Django 进行开发, 遵循 Web 2.0 规范
    3. JumpServer 采纳分布式架构, 支持多机房跨区域部署, 中心节点提供 API, 各机房部署登录节点, 可横向扩展、无并发访问限制
    4. JumpServer 现已支持管理 SSH、 Telnet、 RDP、 VNC 协议资产
    5. jumpserver核心功能包括身份认证、账号管理、权限控制和安全审计
    6. 同时jumpserver还具有分布式、云存储等特点；有丰富便捷的可视化图形web界面

    - [jumpserver官网](https://www.jumpserver.org/)

# jumpserver安装使用
- jumpserver提供多种安装方式，直接安装或者通过docker安装（后续实验我们采用docker进行安装）

- 环境要求：
    1.  硬件配置: 2个CPU核心, 4G 内存, 50G 硬盘（最低）
    1.  操作系统: Linux 发行版 x86_64
    1.  Python = 3.6.x
    1.  Mysql Server ≥ 5.6
    1.  Mariadb Server ≥ 5.5.56
    1.  Redis

- ## 安装
    1.  安装python3 mysql redis
        ```
        自行查阅文档安装
        ```

    2.  创建Python虚拟环境
        ```sh
        python3 -m venv /opt/py3
        ```

    3.  载入虚拟环境
        ```sh
        source /opt/py3
        # 注意，以后每次操作jumpserver的时候都需要载入python的这个虚拟环境
        ```

    4.  git获取jumpserver代码
        ```sh
        cd /opt
        git clone --depth=1 https://github.com/jumpserver/jumpserver.git
        ```

    5.  安装环境依赖
        ```sh
        cd /opt/jumpserver/requirements
        pip3 install wheel && pip3 install --upgrade pip setuptools && pip3 install -r requirements.txt
        # 被反复折磨，网络超时，还是清华源；反复折磨知道去世
        # 如有依赖问题可google
        ```

        下面我遇到的几个报错
        ```
        报错：No package 'gss' found Command "python setup.py egg_info" failed with error
        解决：yum install krb5-devel


        报错：安装python-ldap模块报错无法找到 lber.h 文件
        解决：yum install openldap-devel

        报错：gcc
        ```

    6.  修改配置文件（参考官网）
        ```
        # SECURITY WARNING: keep the secret key used in production secret!
        # 加密秘钥 生产环境中请修改为随机字符串，请勿外泄, 可使用命令生成
        # cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 49;echo
        SECRET_KEY: W5Ic3fMXNZ0p5RIy5DhJYJllppTfcfkW8Yuf94VBMfpcssbfu

        # SECURITY WARNING: keep the bootstrap token used in production secret!
        # 预共享Token coco和guacamole用来注册服务账号，不在使用原来的注册接受机制
        BOOTSTRAP_TOKEN: zxffNymGjP79j6BN

        # Development env open this, when error occur display the full process track, Production disable it
        # DEBUG 模式 开启DEBUG后遇到错误时可以看到更多日志
        DEBUG: false

        # DEBUG, INFO, WARNING, ERROR, CRITICAL can set. See https://docs.djangoproject.com/en/1.10/topics/logging/
        # 日志级别
        LOG_LEVEL: ERROR
        # LOG_DIR:

        # Session expiration setting, Default 24 hour, Also set expired on on browser close
        # 浏览器Session过期时间，默认24小时, 也可以设置浏览器关闭则过期
        # SESSION_COOKIE_AGE: 86400
        SESSION_EXPIRE_AT_BROWSER_CLOSE: true

        # Database setting, Support sqlite3, mysql, postgres ....
        # 数据库设置
        # See https://docs.djangoproject.com/en/1.10/ref/settings/#databases

        # SQLite setting:
        # 使用单文件sqlite数据库
        # DB_ENGINE: sqlite3
        # DB_NAME:

        # MySQL or postgres setting like:
        # 使用Mysql作为数据库
        DB_ENGINE: mysql
        DB_HOST: 127.0.0.1
        DB_PORT: 3306
        DB_USER: jumpserver
        DB_PASSWORD: rBi41SrDqlX4zsx9e1L0cqTP
        DB_NAME: jumpserver

        # When Django start it will bind this host and port
        # ./manage.py runserver 127.0.0.1:8080
        # 运行时绑定端口
        HTTP_BIND_HOST: 0.0.0.0
        HTTP_LISTEN_PORT: 8080
        WS_LISTEN_PORT: 8070

        # Use Redis as broker for celery and web socket
        # Redis配置
        REDIS_HOST: 127.0.0.1
        REDIS_PORT: 6379
        REDIS_PASSWORD: ZhYnLrodpmPncovxJTnRyiBs
        # REDIS_DB_CELERY: 3
        # REDIS_DB_CACHE: 4

        # Use OpenID authorization
        # 使用OpenID 来进行认证设置
        # BASE_SITE_URL: http://localhost:8080
        # AUTH_OPENID: false  # True or False
        # AUTH_OPENID_SERVER_URL: https://openid-auth-server.com/
        # AUTH_OPENID_REALM_NAME: realm-name
        # AUTH_OPENID_CLIENT_ID: client-id
        # AUTH_OPENID_CLIENT_SECRET: client-secret
        # AUTH_OPENID_IGNORE_SSL_VERIFICATION: True
        # AUTH_OPENID_SHARE_SESSION: True

        # Use Radius authorization
        # 使用Radius来认证
        # AUTH_RADIUS: false
        # RADIUS_SERVER: localhost
        # RADIUS_PORT: 1812
        # RADIUS_SECRET:

        # CAS 配置
        # AUTH_CAS': False,
        # CAS_SERVER_URL': "http://host/cas/",
        # CAS_ROOT_PROXIED_AS': 'http://jumpserver-host:port',  
        # CAS_LOGOUT_COMPLETELY': True,
        # CAS_VERSION': 3,

        # LDAP/AD settings
        # LDAP 搜索分页数量
        # AUTH_LDAP_SEARCH_PAGED_SIZE: 1000
        #
        # 定时同步用户
        # 启用 / 禁用
        # AUTH_LDAP_SYNC_IS_PERIODIC: True
        # 同步间隔 (单位: 时) (优先）
        # AUTH_LDAP_SYNC_INTERVAL: 12
        # Crontab 表达式
        # AUTH_LDAP_SYNC_CRONTAB: * 6 * * *
        #
        # LDAP 用户登录时仅允许在用户列表中的用户执行 LDAP Server 认证
        # AUTH_LDAP_USER_LOGIN_ONLY_IN_USERS: False
        #
        # LDAP 认证时如果日志中出现以下信息将参数设置为 0 (详情参见：https://www.python-ldap.org/en/latest/faq.html)
        # In order to perform this operation a successful bind must be completed on the connection
        # AUTH_LDAP_OPTIONS_OPT_REFERRALS: -1

        # OTP settings
        # OTP/MFA 配置
        # OTP_VALID_WINDOW: 0
        # OTP_ISSUER_NAME: Jumpserver

        # Perm show single asset to ungrouped node
        # 是否把未授权节点资产放入到 未分组 节点中
        # PERM_SINGLE_ASSET_TO_UNGROUP_NODE: false
        #
        # 启用定时任务
        # PERIOD_TASK_ENABLE: True
        #
        # 启用二次复合认证配置
        # LOGIN_CONFIRM_ENABLE: False
        #
        # Windows 登录跳过手动输入密码
        WINDOWS_SKIP_ALL_MANUAL_PASSWORD: True
        ```

    7.  启动jumpserver
        ```sh
        cd /opt/jumpserver
        ./jms start
        ```

    8.  部署koko组件
        ```sh
        cd /opt
        # 下载koko的release压缩包
        wget https://github.com/jumpserver/koko/releases/download/1.5.8/koko-master-linux-amd64.tar.gz
        tar -xf koko-master-linux-amd64.tar.gz && \  
        chown -R root:root kokodir && \  
        cd kokodir

        cp config_example.yml config.yml && \  
        vim config.yml
        ```

    9.  配置内容
        ```
        # 项目名称, 会用来向Jumpserver注册, 识别而已, 不能重复
        # NAME: {{ Hostname }}

        # Jumpserver项目的url, api请求注册会使用
        CORE_HOST: http://127.0.0.1:8080

        # Bootstrap Token, 预共享秘钥, 用来注册coco使用的service account和terminal
        # 请和jumpserver 配置文件中保持一致，注册完成后可以删除
        BOOTSTRAP_TOKEN: zxffNymGjP79j6BN

        # 启动时绑定的ip, 默认 0.0.0.0
        # BIND_HOST: 0.0.0.0

        # 监听的SSH端口号, 默认2222
        # SSHD_PORT: 2222

        # 监听的HTTP/WS端口号，默认5000
        # HTTPD_PORT: 5000

        # 项目使用的ACCESS KEY, 默认会注册,并保存到 ACCESS_KEY_STORE中,
        # 如果有需求, 可以写到配置文件中, 格式 access_key_id:access_key_secret
        # ACCESS_KEY: null

        # ACCESS KEY 保存的地址, 默认注册后会保存到该文件中
        # ACCESS_KEY_FILE: data/keys/.access_key

        # 设置日志级别 [DEBUG, INFO, WARN, ERROR, FATAL, CRITICAL]
        LOG_LEVEL: ERROR

        # SSH连接超时时间 (default 15 seconds)
        # SSH_TIMEOUT: 15

        # 语言 [en,zh]
        # LANG: zh

        # SFTP的根目录, 可选 /tmp, Home其他自定义目录
        # SFTP_ROOT: /tmp

        # SFTP是否显示隐藏文件
        # SFTP_SHOW_HIDDEN_FILE: false

        # 是否复用和用户后端资产已建立的连接(用户不会复用其他用户的连接)
        # REUSE_CONNECTION: true

        # 资产加载策略, 可根据资产规模自行调整. 默认异步加载资产, 异步搜索分页; 如果为all, 则资产全部加载, 本地搜索分页.
        # ASSET_LOAD_POLICY:

        # zip压缩的最大额度 (单位: M)
        # ZIP_MAX_SIZE: 1024M

        # zip压缩存放的临时目录 /tmp
        # ZIP_TMP_PATH: /tmp

        # 向 SSH Client 连接发送心跳的时间间隔 (单位: 秒)，默认为30, 0则表示不发送
        # CLIENT_ALIVE_INTERVAL: 30

        # 向资产发送心跳包的重试次数，默认为3
        # RETRY_ALIVE_COUNT_MAX: 3

        # 会话共享使用的类型 [local, redis], 默认local
        SHARE_ROOM_TYPE: redis

        # Redis配置
        REDIS_HOST: 127.0.0.1
        REDIS_PORT: 6379
        REDIS_PASSWORD: ZhYnLrodpmPncovxJTnRyiBs
        # REDIS_CLUSTERS:
        REDIS_DB_ROOM: 6
        ```

    10. docker部署koko
        ```sh
        docker run --name jms_koko -d \
        -p 2222:2222 -p 127.0.0.1:5000:5000 \
        -e CORE_HOST=http://<Jumpserver_url> \
        -e BOOTSTRAP_TOKEN=<Jumpserver_BOOTSTRAP_TOKEN> \
        -e LOG_LEVEL=ERROR \
        --restart=always \
        jumpserver/jms_koko:<Tag>
        # <Jumpserver_url> 为 jumpserver 的 url 地址, <Jumpserver_BOOTSTRAP_TOKEN> 需要从 jumpserver/config.yml 里面获取, 保证一致, <Tag> 是版本
        ```

# 参考文档
- [jumpsever官方文档](https://jumpserver.readthedocs.io/zh/master/index.html)
- [gss报错解决网址](https://blog.csdn.net/weixin_39269896/article/details/89486357)
- [python-ldap报错解决网址](https://blog.csdn.net/qq_20105831/article/details/89361472)
