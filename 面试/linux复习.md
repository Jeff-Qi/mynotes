<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [Day 1](#day-1)
  - [进程/线程/协程是什么](#进程线程协程是什么)
  - [进程和程序之前的关系](#进程和程序之前的关系)
  - [进程和线程通信机制](#进程和线程通信机制)
  - [进程类型](#进程类型)
  - [进程调度](#进程调度)
  - [Linux网络IO模型](#linux网络io模型)
  - [文件描述符](#文件描述符)
  - [select/poll/epoll](#selectpollepoll)
  - [COW技术](#cow技术)
- [Day 2](#day-2)
  - [文件操作](#文件操作)
  - [时间](#时间)
  - [权限管理](#权限管理)
  - [文件系统](#文件系统)
  - [计划任务](#计划任务)
  - [文本三剑客 grep、sed、awk](#文本三剑客-grepsedawk)
    - [grep](#grep)
    - [sed](#sed)
    - [awk](#awk)
    - [其他](#其他)
  - [启动流程](#启动流程)
- [Day 3](#day-3)
  - [selinux](#selinux)
  - [iptables](#iptables)
  - [ﬁrewalld](#ﬁrewalld)
  - [SSL/TLS](#ssltls)
  - [对称和非对称加密](#对称和非对称加密)
- [Day 3](#day-3-1)
  - [内存](#内存)
  - [CPU](#cpu)
  - [进程](#进程)
  - [网络](#网络)
  - [磁盘](#磁盘)
- [Day 4](#day-4)
  - [shell脚本](#shell脚本)
    - [基础、调试](#基础调试)
    - [变量和表达式](#变量和表达式)
    - [条件测试](#条件测试)
    - [控制分支](#控制分支)
    - [函数](#函数)
  - [服务相关](#服务相关)
    - [FTP服务原理（20（数据）、21（命令））](#ftp服务原理20数据21命令)
    - [DNS服务原理（53）](#dns服务原理53)
    - [DHCP服务原理（67接收、68发送）](#dhcp服务原理67接收68发送)
    - [NFS服务原理](#nfs服务原理)
- [Day 5](#day-5)
  - [MySQL](#mysql)
- [Day 6 7](#day-6-7)
  - [Redis](#redis)
- [Day 8 9](#day-8-9)
  - [http/https（请求流程/头部信息/状态码/1.1和2.0）](#httphttps请求流程头部信息状态码11和20)
  - [Apache](#apache)
  - [Nginx](#nginx)
    - [反向代理](#反向代理)
  - [vrrp](#vrrp)
  - [Keepalived](#keepalived)
  - [heartbeat](#heartbeat)
    - [keepalived与heartbeat的异同](#keepalived与heartbeat的异同)
  - [负载均衡](#负载均衡)
    - [Nginx](#nginx-1)
    - [Haproxy（软负载均衡器）](#haproxy软负载均衡器)
    - [LVS](#lvs)
- [Day 10](#day-10)
  - [ansible](#ansible)
  - [zabbix](#zabbix)
<!-- TOC END -->

# Day 1

## 进程/线程/协程是什么
1.  进程：程序在自身的虚拟地址空间中的一次执行活动；在内存中形成一个自己的内存体，有自己的地址空间和栈；是计算机分配资源的最小单位；
2.  线程：线程是资源利用的最小单位；
3.  协程：协程是一种用户态的线程；有程序来决定；运行于一个线程中，没有协程切换的开销；在子程序运行的过程中可以中断去做其他的子程序；

## 进程和程序之前的关系
1.  程序与进程：程序是静态的指令+数据的集合；进程是一个动态的执行果过程，具有生命周期；
2.  进程能够申请、调度和独立运行；程序不能调用资源，也不能被系统调用；
3.  程序与进程无一一对应关系；程序能够被多个进程公用，一个进程也能顺序运行多个程序；

## 进程和线程通信机制
1.  进程间通信：
    1.  管道：半双工通信，管道通信允许具有亲缘关系的进程之间进行通信
    2.  命名管道：允许没有亲缘关系的进程间通信
    3.  信号：一种复杂的通信方式，通过通知接收进程某事件已经完成；
    4.  信号量：实质上是一种计数器，通过计数来标记资源是否可使用，来控制进程间对于资源的访问，作为一种锁机制，确保进程在使用时不会被其他进程影响；是进程间或同一进程下的不同线程之间的同步的一种手段
    5.  共享内存：一个进程创建的一块共享内存，可以被其他的一些进程所访问，实现进程间通信；通常和其他的通信方式配合使用比如信号量；是最快的IPC通信方式
    6.  消息队列：
    7.  套接字：可是在不同的主机上的进程之间的通信
2.  线程之间的通信：
    1.  互斥锁：通过对资源加上互斥锁来防止对过线程对同一资源的访问；
    2.  共享锁：对资源加上共享锁后，进程对于该资源的读操作不收影响，但是会排斥写操作；
    3.  信号量：有名信号量和无名信号量；实质是一个计数器，通过计数来标识该资源是否可被使用，如果为0则资源当前不可用；
    4.  条件变量 + 互斥锁来控制资源的访问；以原子的方式阻塞线程，知道条件为真为止

## 进程类型
1. R运行(正在运行或在运行队列中等待)
2. S中断(休眠中, 受阻, 在等待某个条件的形成或接受到信号)
3. D不可中断(收到信号不唤醒和不可运行, 进程必须等待直到有中断发生)
4. Z僵死(进程已终止, 但进程描述符存在, 直到父进程调用wait4()系统调用后释放)
5. S停止(进程收到SIGSTOP, SIGSTP, SIGTIN, SIGTOU信号后停止运行运行)
6. X死亡
7. t停止追踪

## 进程调度

## Linux网络IO模型
1.  阻塞io：当进程发起调用后，系统没有将资源准备好，进程就会一直等待系统回复信号，等待系统将数据从硬件设备拷贝到内核空间，然后拷贝数据到用户空间，完成后系统才会返回信号；进程继续执行；此期间，该进程一直被挂起，不能做任何事情
2.  非阻塞io：当系统发起调用后，系统没有将资源准备好，但是会立即回复error，进程收到后知道数据没有准备好，于是会不断的询问，但是系统不会被阻塞，资源准备好后会将资源拷贝到用户空间；但会造成cpu空轮询，造成资源浪费；这时候一个进程可以处理多个连接请求；
3.  io多路复用：进程发起调用后，会将一个fd注册过到select/poll中进程会阻塞在这个调用上；但是这一个进程可以同时处理多个连接请求，只需要经fd注册到select/poll中；不同于空轮询
；io多路复用中内核会监控每一个fd的准备状态，任何一个准备好后，select/poll就会立即返回；然后轮询注册的fd，找到准备好的哪一个，然后将资源复制到用户空间；这样做避免了空轮询，但是每次都需要遍历所有的fd，找到准备好的fd，开销较大；而epoll就能避免遍历，当有fd准备好后，会直接返回这一个fd，进程直接就能知道是那个fd准备好时间复杂度为O(1)；节省了资源
4.  信号io：调用后，系统立刻放回，不会阻塞进程；在资源准备好后，发送信号通知进程回调，将数据拷贝到用户空间
5.  异步io：发起调用后，立即返回，当资源拷贝到内核空间后，发送信号告诉进程资源已经在用户空间可以使用了

## 文件描述符
1.  它是一个索引值，指向内核为每一个进程所维护的该进程打开文件的记录表。当程序打开一个现有文件或者创建一个新文件时，内核向进程返回一个文件描述符

## select/poll/epoll
1.  select：select 函数监视的文件描述符分3类，分别是writefds、readfds、和exceptfds；调用后select函数会阻塞，直到有描述副就绪（有数据 可读、可写、或者有except），或者超时（timeout指定等待时间，如果立即返回设为null即可），函数返回。当select函数返回后，可以 通过遍历fdset，来找到就绪的描述符。
    ```c
    int select (int n, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout);
    ```
    1.  有点：跨平台
    2.  监听的数量有限1024个
2.  poll：不同与select使用三个位图来表示三个fdset的方式，poll使用一个 pollfd的指针实现。pollfd结构包含了要监视的event和发生的event，不再使用select“参数-值”传递的方式。同时，pollfd并没有最大数量限制（但是数量过大后性能也是会下降）。 和select函数一样，poll返回后，需要轮询pollfd来获取就绪的描述符。
    ```c
    int poll (struct pollfd *fds, unsigned int nfds, int timeout);
    ```

    ```c
    struct pollfd {
        int fd; /* file descriptor \*/
        short events; /* requested events to watch \*/
        short revents; /* returned events witnessed \*/
    };
    ```

3.  epoll:epoll更加灵活，没有描述符限制。epoll使用一个文件描述符管理多个描述符，将用户关系的文件描述符的事件存放到内核的一个事件表中，这样在用户空间和内核空间的copy只需一次。
    1.  三个接口
        ```c
        int epoll_create(int size)；//创建一个epoll的句柄，size用来告诉内核这个监听的数目一共有多大
        int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event)；
        // - epfd：是epoll_create()的返回值。
        // - op：表示op操作，用三个宏来表示：添加EPOLL_CTL_ADD，删除EPOLL_CTL_DEL,修改EPOLL_CTL_MOD。分别添加、删除和修改对fd的监听事件。
        // - fd：是需要监听的fd（文件描述符）
        // - epoll_event：是告诉内核需要监听什么事，struct epoll_event结构如下：
              // EPOLLIN ：表示对应的文件描述符可以读（包括对端SOCKET正常关闭）；
              // EPOLLOUT：表示对应的文件描述符可以写；
              // EPOLLPRI：表示对应的文件描述符有紧急的数据可读（这里应该表示有带外数据到来）；
              // EPOLLERR：表示对应的文件描述符发生错误；
              // EPOLLHUP：表示对应的文件描述符被挂断；
        int epoll_wait(int epfd, struct epoll_event * events, int maxevents, int timeout);
        // 等待epfd上的io事件，最多返回maxevents个事件。
        ```
    2.  工作模式
        1.  LT模式：当epoll_wait检测到描述符事件发生并将此事件通知应用程序，应用程序可以不立即处理该事件。下次调用epoll_wait时，会再次响应应用程序并通知此事件。
        2.  ET模式：当epoll_wait检测到描述符事件发生并将此事件通知应用程序，应用程序 必须立即处理该事件。如果不处理，下次调用epoll_wait时，不会再次响应应用程序并通知此事件。

## COW技术
- 写时复制
- fork 父进程会复制一份完整的父进程的数据来创建一个新的子进程，但是这种做法可能造成系统的资源浪费；父子进程的数据不能共享；而且，如果子进程马上做出了改动，则刚刚的复制就失去了作用；COW 技术是为了推迟甚至免除复制数据；当 fork 父进程进程时，不会产生复制一份数据来创建子进程，而是通过让父子进程以只读的形式来共享一份数据拷贝，只有在父子进程进行exec操作的时候才会进程一次完整的数据拷贝，是父子进程独立；这样就能减少资源的浪费

# Day 2

## 文件操作
1.  目录和文件权限
    - 权限：r（4）、w（2）、x（1）
        - 目录的 x 权限是可以进入这个目录；文件的 x 权限是让文件可执行让文件可以被运行
        - 目录的 w 权限是可以在其下删除创建文件或目录；文件的 w 权限是让文件内容可以修改
        - 目录的 r 权限是可以列出其下的所有文件或目录；文件的 r 权限是让文件可读
    - 所属：所属用户、所有组
        - 用户对于文件或目录的操作，由这个文件或目录的权限的权限来决定用户放问文件或目录需要其所属用户是自己，或者是所属组成员；或者第三方访问权限开放
        - 优先级：UID > GID > OTHER
    - 文件查看 ls：文件类型、链接数、文件权限、属主、属组、文件大小、文件最近修改时间、文件名
2.  软硬链接
  - 硬链接：创建一个硬链接时，只在文件目录的 block 中记录链接的档名，直接指向源文件的 inode；通过原文件的 inode 的链接计数来确定文件的可用性，删除时硬链接更安全，当 inode 的连接数为 0 时删除这个文件；不会占用新的 inode 和 block；但是不能跨文件系统或者对目录创建硬链接
  - 软连接：创建一个软连接时，需要占用创建一个新的 inode 和 block，block中记录的是源文件的档名，指向该档名的所在的 inode；符号链接更加灵活，能够链接目录和跨文件创建；删除软连接不会影响源文件；源文件删除或文件的位置发生改动，软连接记录的位置不变导致链接失效

## 时间
1.  atime	access time	访问时间	文件中的数据库最后被访问的时间
2.  mtime	modify time	修改时间	文件内容被修改的最后时间
3.  ctime	change time	变化时间	文件的元数据发生变化。比如权限，所有者等

## 权限管理
1.  文件修改：
    1.  chmod
    2.  chown
    3.  chgrp
2.  unmask
    - 默认权限掩码；告诉系统生成文件时不应该给那些权限
3.  特殊权限：SUID、SGID、STID
    1.  SUID（需要有 x 权限，变为 s）
        - 文件：使用所属用户的权限来运行
        - 目录：其下所有新建的文件、目录都是目录所属主的归属
    2.  SGID（需要有 x 权限，变为 s）
        - 文件：使用所属组的权限来运行
        - 目录：创建的所有文件或目录都是所属组的归属
    3.  STID（需要有 x 权限，变为 t）
        - 目录下的所有文件或者目录只能所属用户和 root 来删除
4.  文件 ACL 访问控制
    - 给予用户更灵活的访问控制列表来对任何用户的权限给予
        1.  可以针对任意指定用户和组设置 rwx 权限
        2.  避免用户对文件使用 777 权限带来的风险
    - getfacl、setfacl

## 文件系统
1.  存储设备上的组织文件的方法；在告知系统分区所在的起始与结束柱面后，需要将分区格式化为操作系统能够识别的文件系统，之后操作系统才能使用这个文件系统；Linux 文件系统通常将文件的权限和属性放置到 inode 节点中，将实际的数据放置到 block；inode 和 block 块都有自己的编号
2.  超级块：
    - 记录整个文件系统的整体信息包括 inode 与 block 的总量、使用数量和余量等
3.  inode：
    - 记录文件的权限和属性等信息；同时记录这个文件数据的 block 块的编号
4.  block：
    - 记录文件的真实数据，如果一个文件较大会使用多个 block 来存储
5.  目录树：
    - 每一个目录都占用一个 inode，目录名（档名）存储在 block 中；当我们访问一个文件的时候都是首先通过 / 目录的 inode 找到根目录的 block 找到记录有下一级记录的 inode，这样一层一层的查找下去直到找到对应的文件
6.  新建文件
    1.  判断对当前所在目录是否有 w x 权限，如果有就继续
    2.  从 inode 位图找出空闲的 inode，将属性和权限等信息写入
    3.  从 black 位图找出空闲的 block，将数据写入
    4.  同步 inode bitmap 和 block bitmap；更新 superblock
    5.  **创建文件的两大先决条件：1. 还有剩余的磁盘空间 2. 还有剩余的 inode 节点**
7.  挂载点
    - 挂载点是进入文件系统的入口
    - 一定是一个目录
8.  查看文件系统
    ```shell
    ls -l /lib/modules/$(uname -r)/fs
    ls /proc/filesystems
    df -T
    lsblk -f
    file -s
    dumpe2fs -h
    ```

9.  常见的文件系统
    1.  xfs
    2.  ext2/3/4
10. linux分区
    - 3 + 1：三个主分区 + 一个扩展分区（可有多个逻辑分区）

## 计划任务
1.  at：一次性计划任务，在指定时间完成一次操作
2.  crontab：周期性计划任务，周期性执行
    - 格式：分 + 时 + 日 + 月 + 星期 + 命令

## 文本三剑客 grep、sed、awk

### grep
1.  文本过滤工具，打印匹配的行；可使用正则表达式
1.  参数：
    ```
    -i：忽略大小写
    -o：只显示匹配的行
    -w：匹配整个单词
    -v：反选
    -n：显示行号
    -c：统计匹配到的行数
    -e：多个条件的或关系
    -q：安静模式，不显示匹配的行
    -A：前#行
    -B：后#行
    -C：前后#行
    -E：使用扩展正则表达式
    ```
1.  字符匹配

匹配符 | 作用
---|---
. | 匹配任意字符
.* | 任意字符任意次
[  ] | 匹配指定范围内的字符
[^] | 匹配指定范围外的字符
[[:digit:]] | 数字
[[:lower:]] | 小写字母
[[:upper:]] | 大写字母
[[:alpha:]] | 字符
[[:alnum:]] | 字符和数字
[[:space:]] | 水平和垂直的空白字符
[[:blank:]] | 水平空白字符
[[:punct:]] | 标点符号

1.  匹配次数

匹配符 | 匹配次数
---|---
\* | 匹配其前面字符任意次，包括0次；贪婪模式：尽可能长的匹配
\+ | 匹配其前面字符至少1次
\? | 匹配其前面字符0或1次
\{m,n\} | 匹配其前面字符至少m次至多n次
\{n\} | 匹配其前面字符n次
\{n,\} | 匹配其前面字符至少n次
\{,n\} | 匹配其前面字符至多n次

1.  位置锚定

锚定符 | 作用
---|---
^ | 锚定行首
$ | 锚定行位
\< | 锚定词首
\> | 锚定词尾

### sed
1.  行编辑器，sed是一种流编辑器
2.  参数

参数 | 作用
---|---
-n | 不输出模式空间内容到屏幕
-e | 多点编辑
-f /path/to/script_file | 从指定文件中读取编辑脚本
-r | 支持使用扩展正则表达式
-i | 原处编辑

3.  动作
    ```
    a ：新增， a 的后面可以接字串，而这些字串会在新的一行出现(目前的下一行)
    i ：插入， i 的后面可以接字串，而这些字串会在新的一行出现(目前的上一行)
    c ：取代， c 的后面可以接字串，这些字串可以取代 n1,n2 之间的行！
    d ：删除，因为是删除啊，所以 d 后面通常不接任何咚咚；
    p ：打印，亦即将某个选择的数据印出。通常 p 会与参数 sed -n 一起运行～
    s ：取代，可以直接进行取代的工作哩！通常这个 s 的动作可以搭配正规表示法！例如 1,20s/old/new/g 就是啦！
    ```
3.  锚定符

位置 | 解释
---|---
默认 | 全文
\# | 第#行
$ | 最后一行
\#,# | 第#行到第 # 行
\#,+# | 第#行到第 # + # 行
~ | 步进 1~2 奇数行；2~2 偶数行

### awk
1.  分析工具
```sh
[root@redis-server1 ~]# cat a
1
2
3
4
5
2333

0) 求和
[root@redis-server1 ~]# awk '{a+=$1}END{print a}' a
2348

1) 求最大值
[root@redis-server1 ~]# awk '$0>a{a=$0}END{print a}' a
2333

2) 求最小值（思路：先定义一个最大值）
[root@redis-server1 ~]# awk 'BEGIN{a=9999999}{if($1<a) a=$1 fi}END{print a}' a
1

3)求平均值
第一种方法：在上面求和的基础上，除以参数个数
[root@redis-server1 ~]# awk '{a+=$1}END{print a/NR}' a
391.333
```

### 其他

##  启动流程
1.  加电 BIOS 自检
2.  选择启动设备，加载 MBR 加载 bootloader
    1.  stage 1：加载 MBR 的前 446 bytes，用于加载 stage 1.5
    2.  stage 1.5：加载 MBR 之后的扇区，加载的 stage 2 所在分区的文件系统驱动，让 stage 1 中的 bootloader 能够识别 stage 2 所在分区的文件系统
    3.  stage 2：主要加载内核和 ramdisk 这个临时根文件系统，具体的文件夹是 /boot/grub
3.  内核初始化
    1.  先检查所有的硬件设备
    2.  加载硬件驱动
    3.  以只读方式加载根目录
    4.  运行用户空间的第一个程序 /sbin/init
4.  init 程序启动用户空间的进程
    1.  根据 init 的配置文件设置运行级别
        - centos6 init 程序是 upstart 配置文件在 /etc/inittab 和 /etc/init/\*.conf
        - centos6 init 程序是 systemd 配置文件在 /usr/lib/system/systemd/* 和 /etc/systemd/system/*
    2.  运行系统初始化脚本完成系统初始化
    3.  启动开机自启动程序
5.  初始化终端，等待用户操作


- 接电 BIOS 自检---加载MBR---加载 /boot---加载内核并初始化---设置运行等级---系统初始化---初始化终端---等待用户操作

# Day 3

## selinux
1.  selinux作为内核型的加强性防火墙，提高对系统的安全保护，通过selinux对系统中的文件和资源添加标签，从而提高安全性；
2.  运行级别：enforcing(强制不可以访问)、permissive(警告但可以访问)、disabled( 不警告不拒绝)
3.  安全上下文
    1.  安全上下文我自己把它分为「进程安全上下文」和「文件安全上下文」。一个「进程安全上下文」一般对应多个「文件安全上下文」只有两者的安全上下文对应上了，进程才能访问文件
4.  命令
    1.  更改文件或目录上下文 chcon、restorecon
    2.  布尔型规则 getsebool、setsebool
    3.  添加目录的默认安全上下文：semanage fcontext -a -t；添加端口 semanage port -a -t

## iptables
1.  Netfilter是一种内核中用于扩展各种网络功能的结构化底层构架，由内核提供，无需守护进程
1.  专表专用
    1.  filter：专门用于过滤数据
    1.  nat：用于地址转换（只匹配初始连接数据，随后使用连接跟踪）
    1.  mangle：用于修改数据包头的内容
    1.  raw：用于在连接追踪前预处理数据
2.  专链专用
    1.  PREROUTING：用于匹配最先接触到的数据(raw,mangle,nat)
    1.  INPUT：用于匹配到达本机的数据(mangle,filter)
    1.  FORWARD：用于匹配穿越本机的数据(mangle,filter)
    1.  OUTPUT：用于匹配从本机发出的数据(raw,mangle,nat,filter)
    1.  POSTROUTING：用于匹配最后离开的数据(mangle,nat)
3.  iptables 命令
    1.  iptables -t -AIDRLFZNXP -psd(sport)(dport)io -j
4.  netfiles 对于流量的处理规则：
    1.  检查点表查询顺序：
        - raw、mangle、nat、filter
    2.  链匹配规则
        1.  入站流量：prerouting、input
        2.  出站流量：output、postrouting
        3.  转发流量：prerouting、forward、postrouting

## ﬁrewalld
1.  centos 和 rhel提供了一个firewalld的动态管理的防火墙；firewalld将所有网络流量分为多个区域进行管理
2.  将流量根据数据包的源IP地址或传入网络接口等条件，流量将转入相应区域的防火墙规则，对于流入系统的每个数据包，将首先检查其源地址；特定区域、指定网络接口的区域、默认区域

## SSL/TLS
1.  SSL 安全套接字
    1.  位于可靠的面向连接的网络层协议和应用层协议之间的一种协议层。SSL通过互相认证、使用数字签名确保完整性、使用加密确保私密性，以实现客户端和服务器之间的安全通讯
2.  TLS 传输层安全协议
    1.  用于在两个通信应用程序之间提供保密性和数据完整性是 SSL 的升级版
3.  SSL/TLS 的握手过程

## 对称和非对称加密
1.  对称加密：通信的双方采用同样的秘钥进行加密解密
    1.  优点：秘钥较短，方便简单，加密速度快
    2.  缺点：秘钥的传输不安全，可能存在秘钥泄露
    3.  常见 DES,IDEA,AES 加密算法
2.  非对称加密：采用公钥加密，私钥解密的办法来通信
    1.  优点：可以更好的保证秘钥的安全性
    2.  缺点：加密更加消耗资源
    3.  常见 RSA

# Day 3

## 内存
1.  free：显示系统内存的使用  -mgs
2.  vmstat：报告虚拟内存的统计信息

## CPU
1.  uptime：显示系统平均负
2.  top：动态显示系统进程任务
3.  mpstat：输出CPU的各种统计信息

## 进程
1.  进程的管理和查看
    1.  ps、top、pstree
    2.  kill、killall、pkill
        1.  kill 常见信号量
            1.  （1）sighup 读取配置重启
            2.  （2）sigint = ctrl + C 中断服务
            3.  （9）sigkill 立即杀死进程及其子进程
            4.  （15）sigterm 杀死进程，等待程序正常退出
            5.  （18）sigcont 继续运行
            6.  （19）sigstop 暂停运行

## 网络
1.  临时性网络配置，直接通过修改当前内核参数；永久修改，需要修改配置文件，然后重启网络接口
2.  管理以太网接口
    1.  ifconfig：ifup、ifdown
    2.  ifconfig <网络接口> <IP地址> [Mask <子网掩码>] [Broadcast <广播地址>]
    3.  route add|del [-net|-host] <target [netmask Netmask]> [gw Gateway] [[dev] Interface]
3.  设置主机名和包转发
    1.  echo "1" > /proc/sys/net/ipv4/ip_forward
    2.  hostname <主机名>
4.  永久配置网络（更改配置文件）
    1.  /etc/sysconfig/network
    2.  /etc/sysconfig/network-script/
    3.  /etc/hosts（域名解析文件）
    4.  /etc/resolv.conf（域名解析服务器）
5.  域名解析网络检车
    1.  netstat、lsof
    2.  ping、traceroute
    3.  dig、nslookup
    4.
6.  wget -hbqOaortc --user --passoword

## 磁盘
1.  fdisk：磁盘分区工具；parted：动态交互分区
2.  lvm：逻辑盘卷管理（Logical Volume Manager）的简称，它是Linux 环境下对卷进行方便操作的抽象层
    1.  是磁盘和分区上的一层逻辑结构，对文件系统屏蔽了下层磁盘的分区布局；可以组织不同磁盘的分区来组装成一个新的逻辑上的分区，这样就可以在逻辑上将多个磁盘合并成一个块更大的磁盘
    2.  创建物理卷（PV 中有 PE 概念；这个是 lvm 的最小寻址单位）、创建卷组（VG：简历在物理卷之上）、创建逻辑卷（LV：从卷组中划出一块区域创建）
    3.  使用：
        1.  pvcreate <磁盘或分区设备名>
        2.  vgcreate <卷组名> <物理卷设备名> [...]
        3.  lvcreate <-L 逻辑卷大小> <-n 逻辑卷名> <卷组名>
        4.  lvcreate <-l PE值> <-n 逻辑卷名> <卷组名>
        5.  掌握扩容与缩容的步骤resize2fs
3.  文件系统挂载
    1.  mount、unmout、fuser、swapon
    2.  /etc/fstab 各个参数的含义
4.  dd if of bs count
5.  mkfs：创建文件系统
    1.  fsck：检查文件系统
    2.  e2fsck
6.  磁盘限额
    1.  限制用户或组可以拥有的inode数（即文件个数）
    2.  限制分配给用户或组的磁盘块的数目
    3.  硬限制：超过此设定值后不能继续存储新的文件。
    4.  软限制：超过此设定值后仍旧可以继续存储新的文件，同时系统发出警告信息, 建议用户清理自己的文件，释放出更多的空间。
        1.  时限：超过软限制多长时间之内（默认为7天）可以继续存储新的文件。
    5.  quota：配额
        1.  文件挂载配置 /etc/fstab usrquota,grpquota
        2.  创建数据库：quotacheck -cmvug /home
        3.  开启quota：quotaon -avug
7.  磁盘阵列
    1.  整合现有的磁盘空间、提高磁盘读取效率、提供容错性
    2.  raid0，raid1，raid5，raid10
    3.  mdadm -Cv name -n -l -x -f -a -r
8.  常用命令 df -ahiT

# Day 4

## shell脚本

### 基础、调试
1.  标注使用的解释器
2.  脚本调试：
    1.  bash [-x] [-n] [-v] scriptName
        1.  -x：该选项可以使用户跟踪脚本的执行；命令前有 + 号
        2.  -v：按原样显示脚本和执行结果
        3.  -n：shell 语法检查，如果没问题就不会显示任何信息
    2.  set [-x] [-n] [-v]
        1.  在脚本内使用set命令来部分代码的调试选项
        2.  参数和 bash 相似
    3.  shell 各种功能、监控功能、文本编辑功能、正则表达式

### 变量和表达式
1.  输入
    1.  赋值
        ```shell
        name = value
        readonly
        ```
    2.  标准输入读入
        ```shell
        read
        ```
2.  输出
    ```shell
    echo
    printf
    ```
3.  变量替换
    1.  ${var:-=?+word}：变量测试
        1.  -：$var存在且非空直接使用该变量，否则 $var = word **临时赋值word，原var不变**
        2.  =：$var存在且非空直接使用该变量，否则 $var = word **永久赋值，var变为word**
        3.  ?：$var存在且非空直接使用该变量，否则 **输出 word 值，退出脚本**
        4.  +：$var存在且非空直接赋值 $var = word，**原值不改变**，否则 **返回空值，原var不变**
    2.  字符串计数、截取
        ```shell
        ${#var} 返回字符串变量var 的长度
        ${var:m} 返回${var}中从第m个字符到最后的部分
        ${var:m:len} 返回${var}中从第m个字符开始，长度为len的部分
        ${var#pattern} 删除${var}中开头部分与pattern匹配的最小部分
        ${var##pattern} 删除${var}中开头部分与pattern匹配的最大部分
        ${var%pattern} 删除${var}中结尾部分与pattern匹配的最小部分
        ${var%%pattern} 删除${var}中结尾部分与pattern匹配的最大部分
        ```
    3.  字符串替换
        ```shell
        ${var/old/new} 用new替换${var}中第一次出现的old
        ${var//old/new} 用new替换${var}中所有的old(全局替换)
        ${var/#old/new} 用new替换${var}中开头部分与old匹配的部分
        ${var/%old/new} 用new替换${var}中结尾部分与old匹配的部分
        var 可以使  @ 或者 \*
        ```
    4.  变量的间接引用
        ```shell
        str1 = 'a'
        str2 = str1
        newstr = ${!str2}
        ```
    5.  Shell内置命令
        1.  eval:将所有的参数连接成一个表达式，并计算或执行该表达式
    6.  Shell 变量的分类
        1.  用户自定义变量
        2.  Shell 环境变量
        3.  位置参数变量 $1,2,3... $0 $# $@ $* $? $_ $$ $!
        4.  专用参数变量
    7.  read：输入
        1.  read [-p "信息"] [var1 var2 ...]
            1.  双引号” ”：允许通过$符号引用其他变量值
            2.  单引号’ ’：禁止引用其他变量值，$视为普通字符
            3.  反撇号` ` ：将命令执行的结果输出给变量
4.  运算
    1.  ${···}，$(···)，$[···]，$((···)) 区别
        1.  ${}：引用变量，使用变量替换
        2.  $()：对命令的替换，相当于\`\`执行命令
        3.  $[] $(())：算数运算
    2.  let 命令：算数运算：let "num2=4 + 1"
    3.  expr 命令：通用的表达式计算命令：表达式中参数与操作符必须以空格分开。表达式中的运算可以是 **算术运算，比较运算，字符串运算和逻辑运算**

### 条件测试
```sql
select * into outfile '/tmp/kill.sql'
from
  (
    select concat('kill ',id,';')
    from information_schema.processlist
    where
      command='sleep'
    union all
      select 'set global read_only=OFF;'
    union all
      select 'stop slave;'
    union all
      select 'reset slave all;'
  ) t;
```

1.  文件 **条件判断一定要加空格在两端**
    ```shell
    [ -f fname ] fname 存在且是普通文件时，返回真( 即返回0 )
    [ -L fname ] fname 存在且是链接文件时，返回真
    [ -d fname ] fname 存在且是一个目录时，返回真
    [ -e fname ] fname（文件或目录）存在时，返回真（无法判断源文件发生未知改变的软连接文件）
    [ -a fname ] fname 任意类型文件存在时，返回真
    [ -s fname ] fname 存在且大小大于0 时，返回真
    [ -r fname ] fname（文件或目录）存在且可读时，返回真
    [ -w fname ] fname（文件或目录）存在且可写时，返回真
    [ -x fname ] fname（文件或目录）存在且可执行时，返回真
    ```

2.  字符串 **条件判断一定要加空格在两端**
    ```shell
    [ -z string ] 如果字符串string长度为0，返回真
    [ -n string ] 如果字符串string长度不为0，返回真
    [ str1 = str2 ] 两字符串相等（也可使用== ）返回真
    [ str1 != str2 ] 两字符串不等返回真
    [[ str1 == str2 ]] 两字符串相同返回真
    [[ str1 != str2 ]] 两字符串不相同返回真
    [[ str1 =~ str2 ]] str2是str1的子串返回真
    [[ str1 > str2 ]] str1大于str2返回真
    [[ str1 < str2 ]] str1小于str2返回真
    ```

3.  数字 **条件判断一定要加空格在两端**
    ```shell
    [[ int1 -eq int2 ]] int1 等于int2 返回真
    [[ int1 -ne int2 ]] int1 不等于int2 返回真
    [[ int1 -gt int2 ]] int1 大于int2 返回真
    [[ int1 -ge int2 ]] int1 大于或等于int2 返回真
    [[ int1 -lt int2 ]] int1 小于int2 返回真
    [[ int1 -le int2 ]] int1 小于或等于int2 返回真
    ((int1 == int2)) int1 等于int2 返回真
    ((int1 != int2)) int1 不等于int2 返回真
    ((int1 > int2)) int1 大于int2 返回真
    ((int1 >= int2)) int1 大于或等于int2 返回真
    ((int1 < int2)) int1 小于int2 返回真
    ((int1 <= int2)) int1 小于或等于int2 返回真
    ```

4.  逻辑判断 **条件判断一定要加空格在两端**
    ```shell
    [[ pattern1 && pattern2 ]] 逻辑与
    [[ pattern1 || pattern2 ]] 逻辑或
    [[ ! pattern ]] 逻辑非
    ```

### 控制分支
1.  if
    ```shell
    if [[ condition ]]; then
      #statements
    fi

    if [[ condition ]]; then
      #statements
    elif [[ condition ]]; then
      #statements
    fi
    ```

2.  case
    ```shell
    case word in
      pattern )
        ;;
    esac
    ```

3.  for
    ```shell
    for (( i = 0; i < 10; i++ )); do
      #statements
    done

    for i in list; do
      #statements
    done
    ```


- **提供 continue 和 break 来跳过当前循环和结束循环**


4.  while、until
    ```shell
    while [[ condition ]]; do
      #statements
    done

    until [[ condition ]]; do
      #statements
    done
    ```
5.  **如果需要后台执行就在 done 后加 & == done &**

### 函数
1.  结构
    ```shell
    function name(parameter) {
      #statements
    }
    ```
2.  调用函数：
    1.  如果在函数和主程序同一个文件可以直接调用只需要满足先定义后调用；如果没有则需要先使用 source 之后才能调用
3.  查看函数：
    1.  declare -F
    2.  declare -f 可指定函数
4.  注意事项
    1.  调用函数时，使用位置参数的形式为函数传递参数；调用函数时，使用位置参数的形式为函数传递参数
    2.  变量：如果使用了 local 声明就是就是局部变量 **否则就是全局变量**
5.  函数返回值
    1.  return [n]
        1.  return 将结束函数的执行
        2.  可以使用N 指定函数返回值
    2.  exit [n]：n 为 0 ~ 255
        1.  exit 将中断当前函数及当前Shell的执行
        2.  可以使用N 指定返回值

## 服务相关

### FTP服务原理（20（数据）、21（命令））
1.  FTP：文件传输协议，用于两端设备在网络中传输数据的协议
2.  两种模式：
    1.  主动链接：客户端告诉服务器端口，服务端链接客户端（为主）
    2.  被动链接：服务器告诉客户端端口，客户端链接服务端
3.  访问方式
    1.  匿名开放
    2.  本地用户
    3.  虚拟用户
        1.  主机需要虚拟用户映射，需要指定家目录，/etc/vftpd/虚拟用户表（使用hash加密）
        2.  pam文件虚拟用户认证文件：
            1.  PAM是一组安全机制的模块（插件），系统管理员可以用来轻易地调整服务程序的认证方式，而不必对应用程序进行过多修改
        3.  /etc/vftpd/虚拟用户权限表

### DNS服务原理（53）
1.  配置文件：/etc/hosts、/etc/host.conf、/etc/resolv.conf
1.  用于管理和解析域名与IP地址对应关系的技术；将域名解析为IP地址（正向解析），或将IP地址解析为域名（反向解析）
2.  DNS 分层结构：DNS域名解析服务采用了类似目录树的层次结构来记录域名与IP地址之间的对应关系，从而形成了一个分布式的数据库系统
    1.  根域名
    2.  顶级域名
    3.  子域名
3.  DNS 区域
    1.  分散域名管理工作的负载，将DNS域名空间划分为区域来管理；
    2.  管理是分布式的，将子域给其他组织进行管理；减轻主服务器的负担，提高用户的响应速度，提高网络带宽的利用率
4.  DNS记录类型
    1.  A：记录域名和IP地址
    2.  NS：NS记录也叫名称服务器记录，用于说明这个区域有哪些DNS服务器负责解析
    3.  SOA：SOA记录说明负责解析的DNS服务器中哪一个是主服务器。
    4.  MX：邮件交换记录，在使用邮件服务器的时候
    3.  CNAME：规范名称记录，返回另一个域名，即当前域名是另一个域名的跳转
    4.  PTR：逆向查询域名，用于IP查域名
5.  查询方式
    1.  本地查询
    2.  递归查询
    3.  迭代查询
6.  配置文件
    1.  /etc/named.conf：主配置文件
    2.  /etc/named.rfc1912.zone：区域配置文件
    3.  /var/named：数据配置文件目录
7.  DNS分离解析功能
    1.  可让位于不同地理范围内的读者通过访问相同的网址，而从不同的服务器获取到相同的数据；以便使用最近的服务器来提供服务

### DHCP服务原理（67接收、68发送）
1.  动态主机协议，为局域网的网络协议使用 UDP
2.  为内部网络配置 IP 地址，便于内部管理员对计算机做中央管理；有效地提升IP地址的利用率，提高配置效率，并降低管理与维护成本
3.  手动更新：
    1.  windows：ipconfig /renew
    2.  dhclient -r
4.  DHCP中继：在大型网络中在多接口设置多个作用域，使用超级作用域来管理多个作用域，设置DHCP中继；

### NFS服务原理
1.  NFS（网络文件系统）服务可以将远程Linux系统上的文件共享资源挂载到本地主机的目录上，从而使得本地主机（Linux客户端）基于TCP/IP协议，像使用本地主机上的资源那样读写远程Linux系统上的共享文件
2.  /etc/exports，nfs配置文件
3.  rw，ro，sync，async，root_squash
4.  autofs 自动挂载器
    1.  自动挂载，只有在用户需要访问的时候才将文件系统挂载上去
    2.  /etc/auto.master：主配置文件
        1.  挂载目录 + 挂载配置.misc
            1.  挂载配置
                1.  挂载目录 + 文件系统类型，读写模式等权限参数 ： 挂载的文件系统

# Day 5

## MySQL
1.  工作流程
2.  ACID
3.  查询类型
4.  事务隔离级别
5.  脏读/不可重复读/幻读
6.  锁机制
7.  存储引擎
8.  索引类型
9.  日志管理
    1.  二进制日志
        ```
        show master status;  #查看当前正在使用的二进制文件
        show binary logs;  #查看所有的二进制文件
        show binlog events in 'mysql-bin.000033';   #查看二进制文件中记录的内容
        show binlog events in 'mysql-bin.000033' from 407;   #也可以从某个位置查看二进制文件
        purge binary logs to 'mysql-bin.000025';  #删除某个序号之前的日志文件
        ```
    2.  中继日志
    3.  慢查询日志
    4.  错误日志
    5.  redo-log
10. 复制原理：MySQL主从复制也可以称为MySQL主从同步，它是构建数据库高可用集群架构的基础。它通过将一台主机的数据复制到其他一台或多台主机上，并重新应用relay log中的SQL语句来实现复制功能
11. 优化方案
    1.  硬件优化
        1.  提供更好的硬件设备，更快的SSD硬盘，提高网络带宽，增加CPU的核数
    2.  mysql的日常参数调优
        1.  数据库缓冲池大小（50~80%）
        2.  日志写入时间控制（redo-log：0、1、2；binlog 0 1 N）
        3.  脏页比（25~30%）
        4.  IO性能指标
        5.  日志格式和隔离级别
        6.  最大连接数（200）
    3.  mysql表结构和sql优化
        1.  索引优化最左匹配
        2.  过多的索引
        3.  避免使用模糊查询
        4.  避免索引列计算
        5.  小表驱动大表
        6.  避免全盘扫描（不等条件）
        7.  覆盖索引
        8.  排序，函数计算
        9.  拆分sql语句，将一个大操作拆分为几个小操作，减少锁的影响
        10. 数据库分库分表
            1.  水平分库：以字段为依据，按照一定策略（hash、range等），将一个库中的数据拆分到多个库中；系统绝对并发量上来了，分表难以根本上解决问题，并且还没有明显的业务归属来垂直分库
            2.  水平分表：以字段为依据，按照一定策略（hash、range等），将一个表中的数据拆分到多个表中；系统绝对并发量并没有上来，只是单表的数据量太多，影响了SQL效率，加重了CPU负担，以至于成为瓶颈
            3.  垂直分库：以表为依据，按照业务归属不同，将不同的表拆分到不同的库中；系统绝对并发量上来了，并且可以抽象出单独的业务模块
            4.  垂直分表：以字段为依据，按照字段的活跃性，将表中字段拆到不同的表（主表和扩展表）中；系统绝对并发量并没有上来，表的记录并不多，但是字段多，并且热点数据和非热点数据在一起，单行数据所需的存储空间较大。以至于数据库缓存的数据行减少，查询时会去读磁盘数据产生大量的随机读IO，产生IO瓶颈

# Day 6 7

## Redis
    5大基本数据类型
    持久化存储机制
    内存管理
    阻塞问题
    缓存相关
    复制原理
    高可用方案
    优化方案

# Day 8 9
## http/https（请求流程/头部信息/状态码/1.1和2.0）
## Apache
## Nginx

### 反向代理
1.  用户的请求全部发给反向代理服务器，反向代理服务器将请求发送给后端的服务器，处理完成后再返回客户端，这样对于用户来说是透明的，同时影藏了后端的服务器集群，保障了服务器的安全；也可以实现动静分离
2.  nginx_http_proxy_module：反向代理模块
    1.  **代理相关配置**
    1.  proxy_pass：指定将请求代理至server的URL路径；
    2.  proxy_set_header：将发送至server的报文的某首部进行重写；
    3.  proxy_send_timeout：设置将请求传输到代理服务器的超时。仅在两次连续写入操作之间设置超时，而不是为整个请求的传输。
    4.  proxy_read_timeout：定义从代理服务器读取响应的超时。仅在两个连续的读操作之间设置超时
    5.  proxy_connect_timeout：定义与代理服务器建立连接的超时
    6.  **缓存相关设置**
    7.  proxy_cache_path：定义可用于proxy功能的缓存
    8.  proxy_cache zone：指明要调用的缓存，或关闭缓存机制
    9.  proxy_cache_valid：定义对特定响应码的响应内容的缓存时长；
    10. proxy_cache_use_stale
    11. proxy_cache_methods
    12. proxy_hide_header
3.  反向代理配置
```sh
location / { 
  proxy_pass  http://192.168.10.20; 
  proxy_set_header X‐Real‐IP  $remote_addr; 
  proxy_send_timeout 75s; # 默认60s 
  proxy_read_timeout 75s; # 默认60s 
  proxy_connect_timeout   75; # 默认60s 
  proxy_cache pxycache; 
  proxy_cache_key $request_uri; 
  proxy_cache_valid 200 302 301 1h; 
  proxy_cache_valid any 1m; 
} 
```

4.  ngx_http_fastcgi_module：代理缓存模块
    1.  **代理相关配置**
    2.  fastcgi_pass address：定义fastcgi server的地址
    3.  fastcgi_index name：定义fastcgi默认的主页资源
    4.  fastcgi_param：设置应传递给FastCGI服务器的参数
    5.  **缓存相关配置**
    6.  fastcgi_cache_path
    7.  fastcgi_cache
    8.  fastcgi_cache_key
    9.  fastcgi_cache_methods
    10. fastcgi_cache_min_uses
    11. fastcgi_cache_valid
    12. fastcgi_keep_conn
5.  缓存代理模块配置
```sh
# 主配置文件
http{ 
    ... 
    fastcgi_cache_path /var/cache/nginx/fastcgi_cache levels=1:2:1 keys_zone=fcgi:20m 
inactive=120s; 
}
###
# 独立配置文件
location / { 
  proxy_pass http://192.168.10.20; 
} 
# 实现动静分离 
location ~ .*\.(html|txt)$ {
  root /usr/share/nginx/html/; 
} 
# 缓存相关配置 
location ~* \.php$ { 
  fastcgi_cache fcgi; 
  fastcgi_cache_key $request_uri; 
  fastcgi_cache_valid 200 302 10m; 
  fastcgi_cache_valid 301 1h; 
  fastcgi_cache_valid any 1m; 
}
```

## vrrp
1.  通过对于网关进行冗余处理，防止因为网络的单点故障导致的服务不可用问题。keepalived利用vrrp进行工作。

## Keepalived
1.  Keepalived的作用是检测服务器的状态，如果有一台web服务器宕机，或工作出现故障，Keepalived将检测到，并将有故障的服务器从系统中剔除，同时使用其他服务器代替该服务器的工作，当服务器工作正常后Keepalived自动将服务器加入到服务器群中，这些工作全部自动完成，不需要人工干涉，需要人工做的只是修复故障的服务器。
2.  **keepalived可提供vrrp以及health-check功能，可以只用它提供双机浮动的vip（vrrp虚拟路由功能），这样可以简单实现一个双机热备高可用功能；**
2.  工作工程：keepalived分别安装在主机A和备机B上,双方启动以后,主机A就会向局域网内发送arp响应包,该arp响应包的ip地址被设为vip,mac地址被设为macA,所有接收的此报文的电脑就会将这个对应关系写入自己的ARP缓存表中,下次访问vip时,就会根据对应的mac地址访问到主机A当备机B监听到主机A挂了的时候,就会向局域网内发送arp响应包,并将arp响应包的ip地址设为vip,mac地址设为macB,所有接收的此报文的电脑就会将这个对应关系写入自己的ARP缓存表中,下次访问vip时,就会根据对应的mac地址访问到备机B这样就实现了高可用；主机A和备机B之间通过VRRP协议实现监听和选举
4.  模块化设计：core模块、check模块、vrrp模块
    1.  core模块：核心模块，负责主进程的启动维护和全局配置文件的加载 和读取
    2.  check模块：健康检查模块
    3.  vrrp模块：负责vrrp协议的运行
    4.  system call：系统调用
    5.  watchdog：看么狗，监控check和vrrp进程
5.  简单配置
```sh
global_defs { 
   router_id node1 # 全局唯一
} 
# 定义script 
vrrp_script chk_http_port { 
    script "/usr/local/src/check_nginx_pid.sh"  # 检查脚本路径
    interval 1    # 健康检查间隔
    weight ‐2 # 优先级‐2 
} 
vrrp_instance VI_1 { 
    state MASTER    # 模式主
    interface ens33   # 网卡
    virtual_router_id 10  # vrrp的routeid
    priority 100  # 优先级
    advert_int 1 
    authentication {  # 通信认证
        auth_type PASS 
        auth_pass 1111 
    } 
    # 调用script脚本 
    track_script { 
        chk_http_port  
    } 
    virtual_ipaddress {     # vip
    192.168.10.100 
    } 
}
```

## heartbeat
1.  工作原理：通过修改配置文件，让一台服务器变为主服务器，其他的会自动变成热备服务器；
热备服务器守护进程会持续监听主服务器的心跳。如果一段时间内未监听到心跳，就会启动故障转移，获取主服务器上的相关资源的所有权，保证服务的高可用
2.  上述为主备模式，同时也可以是主主模式
3.  切换时机
    1.  服务器宕机
    2.  heartbeat挂掉
    3.  网络通信故障
    4.  **如果是应用服务挂掉不会切换**
4.  脑裂现象
    1.  因为一些原因无法监听到心跳，导致两台服务器相互竞争资源
    2.  解决方案
        1.  服务器之间的通信线路采用冗余配置，如以太网采用多条线路连接
        2.  如果发生了脑裂，通过通知运维人员进行即使的抢修
        3.  延迟接管服务，通知运维人员
        4.  增加仲裁机制：如ip，如果没有心跳了，就同时ping一下ip地址，如果不能ping通则是自己出问题了，主动放弃竞争
5.  信息类型
    1.  心跳信息
        1.  通过控制心跳频率来定时发送信条信息，及出现故障后多久开始转移
    2.  集群转移信息
        1.  如果主服务器上线，通过ip-request消息是要求备机释放主服务器失败时备服务器取得的的资源，然后备服务器关闭是仿主服务器失败时取得的资源及服务备服务器释放主服务器失败时取得的资源以及服务后，就会通过ip-request-resp消息通知主服务器它不在拥有该资源以及服务，主服务器收到来自备节点的ip-request-resp消息通知后，启动失败时释放的资源以及服务，并开始提供正常的访问服务
    3.  重传信息请求
6.  Heartbeat是通过IP地址接管和ARP广播进行故障转移的
    1.  arp强制刷新客户端的ip地址的mac地址
    2.  vip与管理ip

### keepalived与heartbeat的异同
1.  Keepalived和Heartbeat。两者都很流行，将资源（ip以及程序服务等资源）从一台已经故障的计算机快速转移到另一台正常运转的机器上继续提供服务
2.  区别
    1.  keepalived配置相对比较简单，从安装配置维护都比heartbeat简单
    2.  heartbeat采用的是心跳检测，进行通信和选举，通过网络和串口通信，比较可靠；keepalived采用vrrp协议进行选举和通信
    3.  Heartbeat功能更强大：Heartbeat虽然复杂，但功能更强大，配套工具更全，适合做大型集群管理，而Keepalived主要用于集群倒换，基本没有管理功能；


## 负载均衡
1.  负载均衡就是将大量的请求按照一定的策略均匀的分配到后端的服务器集群中进行处理；降低单个服务器的压力，为用户提供更好的服务体验和质量；同时也能够避免单点故障带来的影响服务不可用

### Nginx
1.  特点
    1.  工作在网络的 7 层之上，可以针对 http 应用做一些分流的策略，比如针对域名、目录结构；
    2.  Nginx 安装和配置比较简单，测试起来比较方便；
    3.  也可以承担高的负载压力且稳定，一般能支撑超过上万次的并发；
    4.  Nginx 可以通过端口检测到服务器内部的故障，比如根据服务器处理网页返回的状态码、超时等等，并且会把返回错误的请求重新提交到另一个节点，不过其中缺点就是不支持 url 来检测；
    5.  Nginx 对请求的异步处理可以帮助节点服务器减轻负载；
    6.  Nginx 能支持 http 和 Email，这样就在适用范围上面小很多；
    6.  默认有三种调度算法: 轮询、weight 以及 ip_hash（可以解决会话保持的问题），还可以支持第三方的 fair 和 url_hash 等调度算法；

#### ngx_http_upstream_module：负载均衡模块
1.  参数
    1.  upstream：定义后端服务器组
        1.  server：后接服务器ip地址
            1.  weight=x：权重
            2.  max_fails=x：最大失败次数，操作最大次数后标记不可用
            3.  fail_timeout=x：超时时间，设置服务器不可用的时间
            4.  backup：将服务器标记为备用，组中所有的server都不可用是，使用这个server
            5.  down：将服务器标记为down
        2.  负载均衡算法
            1.  轮询
            2.  加权轮询
            3.  最少连接
            4.  ip_hash
        3.  keepalive connections：每个work进程保留的对大空闲场长连接数
2.  七层代理（包含在http中）
```sh
stream {
  upstream servers{
    server xxx weight 2 max_fails 3 fail_timeout 10;
    server xxx weight 1;
    server xxx backup;
    xxx（负载均衡策略）
  }
  server {
    listen xxxx:80;
    localtion / {
      proxy_pass http://servers;
    }
  }
}
```

3.  四层代理（主配置文件）
```py
upstream servers{
  server xxx weight 2 max_fails 3 fail_timeout 10;
  server xxx weight 1;
  server xxx backup;
  xxx（负载均衡策略）
}
server {
  listen xxxx:80;
  proxy_pass servers;
}
```
4.  七层代理和四层代理的区别
    1.  四层SLB：配置负载均衡设备上服务类型为tcp/udp，负载均衡设备将只解析到4层，负载均衡设备与client三次握手之后就会和RS建立连接；
    2.  七层SLB：配置负载均衡设备服务类型为http/ftp/https等，负载均衡设备将解析报文到7层，在负载均衡设备与client三次握手之后，只有收到对应七层报文，才会跟RS建立连接

### Haproxy（软负载均衡器）
1.  免费开源
2.  负载均衡：最大并发量能达到5w
3.  支持多种负载均衡算法，同时支持session保持：haproxy 将WEB服务端返回给客户端的cookie中插入haproxy中特定的字符串(或添加前缀)在后端的服务器COOKIE ID
4.  支持虚拟主机
5.  拥有服务监控页面，可以了解系统的实时运行状态
6.  健康检查：检查后端服务器状况
7.  HTTP请求重定向与重写
8.  特性：
    1.  采用单线程、事件驱动、非阻塞模型，减少上下文切换的消耗；稳定性极佳
    2.  HAProxy 是工作在网络 7 层之上；
    3.  支持 Session 的保持，Cookie 的引导等；
    4.  支持 url 检测后端的服务器出问题的检测会有很好的帮助；
    5.  支持的负载均衡算法：动态加权轮循(Dynamic Round Robin)，加权源地址哈希(Weighted Source Hash)，加权 URL 哈希和加权参数哈希(Weighted Parameter Hash)
    6.  单纯从效率上来讲 HAProxy 更会比 Nginx 有更出色的负载均衡速度；
    7.  HAProxy 可以对 Mysql 进行负载均衡，对后端的 DB 节点进行检测和负载均衡。
9.  简单配置
```sh
global 
    log         127.0.0.1 local2 
    chroot      /var/lib/haproxy 
    pidfile     /var/run/haproxy.pid 
    maxconn     4000 
    user        haproxy 
    group       haproxy 
    daemon 
    stats socket /var/lib/haproxy/stats 
listen mysql_proxy 
    bind    0.0.0.0:3306 
    mode    tcp 
    balance source 
    server  mysqldb1    192.168.10.30:3306  weight  1   check 
    server  mysqldb2    192.168.10.40:3306  weight  2   check 
listen stats 
    mode http 
    bind    0.0.0.0:8080 
    stats   enable 
    stats   uri /dbs 
    stats   realm   haproxy\    statistics 
    stats   auth    admin:admin 
```

### LVS
1.  Nat 模式：相当于一个前端的反向代理；当用户发送请求时，会发送个DS的VIP，DS收到后，会选择一个后端的服务器来处理，将数据包的目的地址改为后端RS的RIP，然后发送给后端的服务器处理，服务器处理完成后发送给网关（DS）；DS会将源地址转换为虚拟服务的IP地址发送回去；
    1.  该方案实现比较简单，所有的RS网关指向DS即可，但是DS会成为整个集群的性能瓶颈，性能伸缩性不够好
2.  DR 模式：前端DS在收到用户的数据包后，从后端选择一个服务器来服务，将源MAC地址改为内网网卡的MAC地址，目的地址改为内网真实服务器RIP的MAC地址，服务器收到数据包后，发现目的MAC地址是自己，于是接收并处理数据包，处理完成后，直接从本机将数据包回给客户端，不需要经过DS，数据包的源地址为VIP目的地址为CIP；
    1.  该方案是三种模式中最好的，他没有nat模式的DS性能瓶颈，也没有tun模式的隧道开销，所需要的就是DS和RS之间有一块网卡绑定在同一个局域网中，以便能够通过MAC地址进行同信传输数据；还需要保证只有DS的VIP能够响应ARP解析，这样才能够让客户端请求的报文通过DS而不是发送到RS上；
    ```sh
    vip="192.168.10.99" 
    mask="255.255.255.255" 
    ifconfig lo:0 $vip broadcast $vip netmask $mask up   # 将虚拟ip绑定到真是网卡上
    route add ‐host $vip lo:0    # 添加路由规则走lo：0网卡
    echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore   # 忽略对于vip地址的arp请求
    echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce   # 发送arp请求时选择网卡本身的ip地址作为源地址
    echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore    # 全局配置
    echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce  # 全局配置
    echo "1" >/proc/sys/net/ipv4/ip_forward
    ```
3.  Tun 模式：用户发送请求报文到DS，DS收到后发现请求时VIP地址，于是选取一台后端服务器，将数据包在封装上一层IP报文，源IP为DIP，目的IP为RIP，然后通过隧道传输；RS收到后拆开外层数据包，发现内层还有IP报文，且目的IP地址是自己的VIP于是接收处理报文，处理完成后直接冲本地发送数据包给客户端
    1.  该方案需要支持tun隧道技术
4.  调度算法
    1.  轮询、加权轮询、源地址散列、目的地址散列、最少链接、加权最少链接、局部性最少链接、带复制的基于局部最小链接、最低延迟、NQ
5.  LVS 特点是：
    1.  首先它是基于 4 层的网络协议的，抗负载能力强，对于服务器的硬件要求除了网卡外，其他没有太多要求；
    2.  配置性比较低，这是一个缺点也是一个优点，因为没有可太多配置的东西，大大减少了人为出错的几率；
    3.  应用范围比较广，不仅仅对 web 服务做负载均衡，还可以对其他应用（mysql）做负载均衡；
    4.  LVS 架构中存在一个虚拟 IP 的概念，需要向 IDC 多申请一个 IP 来做虚拟 IP。

# Day 10

## ansible
1.  五大组件
    1. Ansible：核心程序
    2. Modules：包括Ansible自带的核心模块及自定义模块
    3. Plugins：完成模块功能的补充，包括连接插件、邮箱插件
    4. Playbooks：剧本；定义Ansible多任务配置文件，由Ansible自动执行
    5. Inventory：定义Ansible管理主机的清单
    6. Connection Plugins：负责和被监控端实现通信
2.  优点
    1.  无服务端，无需守护进程运行，无需安装客户端
    2.  基于模块化工作，支持各种语言开发的第三方模块
    3.  基于ssh工作
    4.  可以实现多级操作
    5.  等幂性：每次执行的结果都一样，更加安全
3.  常用模块，user，group，command，shell，file，service，yum
4.  执行过程
    1.  加载自己的配置文件默认/etc/ansible/ansible.cfg
    2.  加载自己对应的模块文件，如command
    3.  通过ansible将模块或命令生成对应的临时py文件，并将该文件传输至远程服务器的
    4.  对应执行用户的家目录的.ansible/tmp/XXX/XXX.PY文件。
    5.  给文件+x执行
    6.  执行并返回结果删除临时py文件，sleep 0 退出
5.  playbook
    1.  Hosts:执行的远程主机列表
    2.  Tasks：任务，由模块定义的操作的列表；
    3.  Varniables:内置变量或自定义变量在playbook中调用
    4.  Templates：模板，即使用了模板语法的文本文件；
    5.  Handlers：和nogity结合使用，为条件触发操作，满足条件方才执行，否则不执行；
    6.  Roles：角色；
    ```ymal
    ‐ hosts: webservers 
      vars: 
        http_port: 80 
        max_clients: 200 
      remote_user: root 
      tasks: 
      ‐ name: ensure apache is at the latest version 
        yum: 
          name: httpd 
          state: latest 
      ‐ name: write the apache config file 
        template: 
          src: /srv/httpd.j2 
          dest: /etc/httpd.conf 
        notify: 
        ‐ restart apache 
      ‐ name: ensure apache is running 
        service: 
          name: httpd 
          state: started 
      handlers: 
        ‐ name: restart apache 
          service: 
            name: httpd 
            state: restarted
    ```
    7.  运行时
        1.  --check 检查剧本运行情况，不会真正影响主机；--syntax-check 检查语法
        2.  ‐t Tag 指定运行特定的任务 
        3.  ‐‐skip‐tags=SKIP_TAGS  跳过指定的标签 
        4.  ‐‐start‐at‐task=START_AT 从哪个任务后执行
6.  变量
    1.  命令行额外参数
    2.  host单主机参数
    3.  host主机群参数
    4.  playbooks内置参数
    5.  远程主机参数facts
7.  角色
    1.  role文件加结构
    ```sh
    [root@node1 ansible]# tree roles/ 
    roles/ 
    ├── http 
    │   ├── defaults   # 默认变量
    │   │   └── main.yaml  
    │   ├── files     # 需要调用的文件或者脚本
    │   │   └── index.html 
    │   ├── headlers  # 和notify触发操作配合使用
    │   │   └── main.yaml 
    │   ├── meta      # 一些特定的依赖
    │   │   └── main.yaml 
    │   ├── tasks     # 一些类任务
    │   │   └── main.yaml 
    │   ├── templates # 配置模板
    │   │   └── httpd.conf.j2 
    │   └── vars      # 变量
    │       └── main.yaml 
    └── site.yaml     # 通过写role来调用的playbook，调用 roles： - xxx
    ```

## zabbix
1.  Zabbix可以存储数据方便地画图，并且支持查询历史数据和自定义监控项；可以监控cpu，磁盘，网络，内存等参数
2.  是一款优秀的分布式开源监控系统；具有事件邮箱通知的功能；同时对于数据具有可视化的功能；支持主动轮询和被动拉取，的方式获取数据；
3.  组件结构
    1.  Zabbix_Server：整个监控体系中最核心的组件，它负责接收客户端发送的报告信息，所有配置、统计数据及操作数据都由它组织。
    2.  Zabbix_Agent：zabbix-agent为客户端软件，用于采集各监控项目的数据，并把采集的数据传输给zabbixproxy或zabbix-server
    3.  Zabbix_Proxy（可选）：用于监控节点非常多的分布式环境中，它可以代理zabbix-server的功能，减轻zabbixserver的压力。
        1.  监控远程区域设备
        2.  监控本地网络不稳定区域
        3.  当Zabbix 监控上千设备时，使用它来减轻Server 的压力
        4.  简化Zabbix 的维护
    4.  数据库存储：所有配置信息和Zabbix收集到的数据都被存储在数据库中。
    5.  Web界面：为了从任何地方和任何平台都可以轻松的访问Zabbix, 我们提供基于Web的Zabbix界面。该界面是Zabbix Server的一部分，通常跟Zabbix Server运行在同一台物理机器上（！如果使用SQLite,Zabbix Web界面必须要跟Zabbix Server运行在同一台物理机器上。）
