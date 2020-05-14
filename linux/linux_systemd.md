---
title: Linux systemd 机制初探
date: 2020-04-01 17:40:00
categories: Linux
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [systemd 是啥？](#systemd-是啥)
- [为什么是用 systemd 作为开机启动进程](#为什么是用-systemd-作为开机启动进程)
- [systemd启动过程](#systemd启动过程)
- [systemd使用](#systemd使用)
- [systemd定义开机自启动程序](#systemd定义开机自启动程序)
- [参考文档](#参考文档)
<!-- TOC END -->
<!--more-->

# systemd 是啥？
- systemd 是 Linux 内核发起的第一个程序，并且它还扮演多种角色。它会启动系统服务、处理用户登录.

- ## unit 单元
    1. systemd的核心是一个叫单元 unit的概念，它是一些存有关于服务service（在运行在后台的程序）、设备、挂载点、和操作系统其他方面信息的配置文件。

    2. 在/usr/lib/systemd/system下有许多，server，其中包括要被运行的二进制文件（“ExecStart”那一行），相冲突的其他单元（即不能同时进入运行的单元），以及需要在本单元执行前进入运行的单元（“After”那一行）。一些单元有附加的依赖选项，例如“Requires”（必要的依赖）和“Wants”（可选的依赖）。

    ![systemd_service](http://study.jeffqi.cn/linux/systemd_service.jpg)

- ## target 目标
    1. 启动目标 target是一种将多个单元聚合在一起以致于将它们同时启动的方式。

    2. 一个服务会通过 WantedBy 选项让自己成为启动目标的依赖

    3. 文本模式的 multi-user.target 类似于源init启动的第3运行级，graphical.target 类似于第5运行级，reboot.target 类似于第6运行级，诸如此类。

    ![systemd_multi-user_target](http://study.jeffqi.cn/linux/systemd_multi-user_target.jpg)

# 为什么是用 systemd 作为开机启动进程

- ## init进程
    1.  内核记载完成后会马上查找/sbin下的“init”程序并执行它。从这里开始init成为了Linux系统的父进程。init读取的第一个文件是/etc/inittab，通过它init会确定我们Linux操作系统的运行级别。它会从文件/etc/fstab里查找分区表信息然后做相应的挂载。然后init会启动/etc/init.d里指定的默认启动级别的所有服务/脚本。所有服务在这里通过init一个一个被初始化。关机过程差不多是相反的过程，首先init停止所有服务，最后阶段会卸载文件系统。

    2. Linux系统的启动方式有点复杂，而且总是有需要优化的地方。传统的Linux系统启动过程主要由著名的init进程（也被称为SysV init启动系统）处理，而基于init的启动系统被认为有效率不足的问题，程序启动时串行化的，init每次只启动一个服务，所有服务/守护进程都在后台执行并由init来管理。

- ## systemd进程
    1. systemd能够更快地启动，更简单地管理那些有依赖的服务程序，提供强大且安全的日志系统等。

    2. 主要是引入了并行启动的概念。它会为每个需要启动的守护进程建立一个套接字，这些套接字对于使用它们的进程来说是抽象的，这样它们可以允许不同守护进程之间进行交互。Systemd会创建新进程并为每个进程分配一个控制组（cgroup）。处于不同控制组的进程之间可以通过内核来互相通信。

- ## systemd对于init的优化
    1. 和init比起来引导过程简化了很多
    1. Systemd支持并发引导过程从而可以更快启动
    1. 通过控制组来追踪进程，而不是PID
    1. 优化了处理引导过程和服务之间依赖的方式
    1. 支持系统快照和恢复
    1. 监控已启动的服务；也支持重启已崩溃服务
    1. 包含了systemd-login模块用于控制用户登录
    1. 支持加载和卸载组件
    1. 低内存使用痕迹以及任务调度能力
    1. 记录事件的Journald模块和记录系统日志的syslogd模块

# systemd启动过程
1. BIOS加电自检
2. 开始grub引导内核加入
3. **启动systemd进程**
    1.  default.target：实际上default.target是指向graphical.target的软链接。 文件Graphical.target的实际位置是/usr/lib/systemd/system/graphical.target。在这个阶段，会启动multi-user.target

        ![systemd_graphical_target](http://study.jeffqi.cn/linux/systemd_graphical_target.jpg)

    2.  multi-user.target：这个target将自己的子单元放在目录“/etc/systemd/system/multi-user.target.wants”里。这个target为多用户支持设定系统环境。非root用户会在这个阶段的引导过程中启用。防火墙相关的服务也会在这个阶段启动。"multi-user.target"会将控制权交给另一层“basic.target”。

        ![systemd_multi-user_target](http://study.jeffqi.cn/linux/systemd_graphical_target.jpg)

    3.  basic.target：用于启动普通服务特别是图形管理服务。它通过/etc/systemd/system/basic.target.wants目录来决定哪些服务会被启动，basic.target之后将控制权交给sysinit.target。

        ![systemd_basic_target](http://study.jeffqi.cn/linux/systemd_basic_target.jpg)

    4. sysinit.target:启动重要的系统服务例如系统挂载，内存交换空间和设备，内核补充选项等等。sysinit.target在启动过程中会传递给local-fs.target。

        ![systemd_sysinit_target](http://study.jeffqi.cn/linux/systemd_sysinit_target.jpg)

    5. local-fs.target，这个target单元不会启动用户相关的服务，它只处理底层核心服务。这个target会根据/etc/fstab和/etc/inittab来执行相关操作。

        ![systemd_local-fs_target](http://study.jeffqi.cn/linux/systemd_local-fs_target.jpg)

# systemd使用

- ## systemctl

    systemctl 是与 Systemd 交互的主要工具

    启用与禁止服务：可以使用**下面的命令**：这种做法会为该单元创建一个符号链接，并将其放置在当前启动目标的 .wants 目录下，这些 .wants 目录在/etc/systemd/system 文件夹中。

    ```sh
    systemctl enable/disable xxx.service
    ```

    ![systemd_enable_disable_service_unite](http://study.jeffqi.cn/linux/systemd_enable_disable_service_unite.jpg)

    服务运行与停止：
    ```sh
    systemctl start/restart/stop xxx.service
    ```

- ## timer定时器单元
    **取代cron**：在很大程度上，它能够完成 cron 的工作，而且可以说是以更灵活的方式（并带有更易读的语法）。cron 是一个以规定时间间隔执行任务的程序——例如清除临时文件，刷新缓存等。

    ![systemd_timer_unit](http://study.jeffqi.cn/linux/systemd_timer_unit.jpg)

- ##  journal日志文件
    **缺点**：这是个**二进制日志**，因此您不能使用常规的命令行文本处理工具来解析它；
    **优点**：日志可以被更系统地组织，带有更多的元数据，因此可以更容易地根据可执行文件名和进程号等过滤出信息。

    查看日志：
    ```sh
    journalctl
    # -b:至那一次启动以来的日志，默认为0最近一次启动以来，-1为上一次启动
    # --since=”2020-04-24 16:38”:至那个时间点以来的日志
    # -u mysql.service：某一个服务的日志
    # _PID=890：某一个进程的日志
    ```

    ![systemd_journalctl](http://study.jeffqi.cn/linux/systemd_journalctl.jpg)

# systemd定义开机自启动程序
- ## 服务权限
    systemd有系统和用户区分；系统（/user/lib/systemd/system/）、用户（/etc/lib/systemd/user/）。一般系统管理员手工创建的单元文件建议存放在/etc/systemd/system/目录下面。

- ## xxx.service 文件
    1.  实例nginx为例子

        ![systemd_service_start]()

    2.  参数参考
        ```
        [Unit]
        Description : 服务的简单描述
        Documentation ： 服务文档
        Before、After:定义启动顺序。Before=xxx.service,代表本服务在xxx.service启动之前启动。After=xxx.service,代表本服务在xxx.service之后启动。
        Requires：这个单元启动了，它需要的单元也会被启动；它需要的单元被停止了，这个单元也停止了。
        Wants：推荐使用。这个单元启动了，它需要的单元也会被启动；它需要的单元被停止了，对本单元没有影响。
        ```

        ```
        [Service]
        Type=simple（默认值）：systemd认为该服务将立即启动。服务进程不会fork。如果该服务要启动其他服务，不要使用此类型启动，除非该服务是socket激活型。
        Type=forking：systemd认为当该服务进程fork，且父进程退出后服务启动成功。对于常规的守护进程（daemon），除非你确定此启动方式无法满足需求，使用此类型启动即可。使用此启动类型应同时指定 PIDFile=，以便systemd能够跟踪服务的主进程。
        Type=oneshot：这一选项适用于只执行一项任务、随后立即退出的服务。可能需要同时设置 RemainAfterExit=yes 使得 systemd 在服务进程退出之后仍然认为服务处于激活状态。
        Type=notify：与 Type=simple 相同，但约定服务会在就绪后向 systemd 发送一个信号。这一通知的实现由 libsystemd-daemon.so 提供。
        Type=dbus：若以此方式启动，当指定的 BusName 出现在DBus系统总线上时，systemd认为服务就绪。
        Type=idle: systemd会等待所有任务(Jobs)处理完成后，才开始执行idle类型的单元。除此之外，其他行为和Type=simple 类似。
        PIDFile：pid文件路径
        ExecStart：指定启动单元的命令或者脚本，ExecStartPre和ExecStartPost节指定在ExecStart之前或者之后用户自定义执行的脚本。Type=oneshot允许指定多个希望顺序执行的用户自定义命令。
        ExecReload：指定单元停止时执行的命令或者脚本。
        ExecStop：指定单元停止时执行的命令或者脚本。
        PrivateTmp：True表示给服务分配独立的临时空间
        Restart：这个选项如果被允许，服务重启的时候进程会退出，会通过systemctl命令执行清除并重启的操作。
        RemainAfterExit：如果设置这个选择为真，服务会被认为是在激活状态，即使所以的进程已经退出，默认的值为假，这个选项只有在Type=oneshot时需要被配置。
        ```

        ```
        [Install]
        Alias：为单元提供一个空间分离的附加名字。
        RequiredBy：单元被允许运行需要的一系列依赖单元，RequiredBy列表从Require获得依赖信息。
        WantBy：单元被允许运行需要的弱依赖性单元，Wantby从Want列表获得依赖信息。
        Also：指出和单元一起安装或者被协助的单元。
        DefaultInstance：实例单元的限制，这个选项指定如果单元被允许运行默认的实例。
        ```

    3.  添加完成后可看看笔记前面systemctl使用方法

# 参考文档
- [走进Linux之systemd启动过程](https://linux.cn/article-5457-1.html)
- [systemd教程](https://linux.cn/article-6888-1.html)
