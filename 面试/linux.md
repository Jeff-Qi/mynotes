---
title: linux问题
date: 2020-03-20 20:00:00
categories: Linux
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [软硬链接的区别](#软硬链接的区别)
- [linux启动流程](#linux启动流程)
  - [linux开机启动级别](#linux开机启动级别)
- [ansible讲一下](#ansible讲一下)
  - [ansible架构](#ansible架构)
  - [role相比于编写完整的playbook的优点](#role相比于编写完整的playbook的优点)
  - [运行过程讲一下](#运行过程讲一下)
- [进程、线程、协程](#进程线程协程)
  - [进程线程协程区别](#进程线程协程区别)
  - [进程线程区别：](#进程线程区别)
  - [联系：](#联系)
- [apache](#apache)
  - [apache的认证和授权](#apache的认证和授权)
  - [认证](#认证)
  - [mod_ssl 有什么用以及SSL在Apache中如何工作](#mod_ssl-有什么用以及ssl在apache中如何工作)
  - [常见安全模块](#常见安全模块)
  - [讲讲mpm工作模式](#讲讲mpm工作模式)
- [Nginx](#nginx)
  - [模块](#模块)
    - [ngx_http_headers_module：向由代理服务器响应给客户端的响应报文添加自定义首部，或修改指定首部的值](#ngx_http_headers_module向由代理服务器响应给客户端的响应报文添加自定义首部或修改指定首部的值)
    - [限制模块](#限制模块)
  - [面试题](#面试题)
    - [如何设置访问评率](#如何设置访问评率)
    - [nginx url 重写功能](#nginx-url-重写功能)
    - [nginx如何实现高并发](#nginx如何实现高并发)
    - [为什么 Nginx 不使用多线程?](#为什么-nginx-不使用多线程)
    - [Nginx常见的优化配置有哪些?](#nginx常见的优化配置有哪些)
    - [负载均衡算法](#负载均衡算法)
  - [nginx与httpd的平滑启动](#nginx与httpd的平滑启动)
    - [nginx](#nginx-1)
    - [httpd](#httpd)
- [select、poll、epoll](#selectpollepoll)
- [nginx，lvs，haproxy](#nginxlvshaproxy)
  - [nginx](#nginx-2)
    - [优点](#优点)
    - [缺点](#缺点)
  - [lvs](#lvs)
    - [优点](#优点-1)
    - [缺点](#缺点-1)
  - [haproxy](#haproxy)
    - [优点](#优点-2)
    - [缺点](#缺点-2)
  - [nginx与lvs对比](#nginx与lvs对比)
    - [使用场景](#使用场景)
<!-- TOC END -->
<!--more-->

# 软硬链接的区别
-  硬链接文件与源文件的inode节点号相同，不会占用新的inode和block，只是在某个目录的block下记录，不能跨文件系统和目录；
-  软链接文件的inode节点号与源文件不同，需要占用新的inode和block，可以跨文件系统和链接目录；

# linux启动流程
1.  BIOS===》加载第一扇区===》加载/boot引导内核===》运行 init/systemd===》系统初始化===》运行级别===》建立终端===》用户登录系统
- 接电后BOIS载入，然后加载第一扇区，加载/boot目录，开始引导内核，初始化程序systemd，运行设置的runlevel等级。初始化系统，启动设置为开机自启动的程序。生成终端，等待用户登录。

## linux开机启动级别
1.  runlevel有7个0~6：
    - 运行级别0：系统停机状态，系统默认运行级别不能设为0，否则不能正常启动
    - 运行级别1：单用户工作状态，root权限，用于系统维护，禁止远程登陆
    - 运行级别2：多用户状态(没有NFS)
    - 运行级别3：完全的多用户状态(有NFS)，登陆后进入控制台命令行模式
    - 运行级别4：系统未使用，保留
    - 运行级别5：X11控制台，登陆后进入图形GUI模式
    - 运行级别6：系统正常关闭并重启，默认运行级别不能设为6，否则不能正常启动

# ansible讲一下
- ansible使用python编写的自动化运维工具。实现了批量设置管理服务器，操作效率高。ansible基于模块化工作。本身并没有批量管理的功能，通过其他模块来实现这些功能。

## ansible架构
- ansible：核心组件
- module：包含喊自带的核心模块和自定义模块
- plugin：对于模块功能的完善比如，邮件插件，链接插件等
- inventory：主机清单，需要管理的主机信息
- playbook：剧本，定义多个任务的配置文件，由ansible自动运行
- connection plugin：负责被监控端的通信

## role相比于编写完整的playbook的优点
- 一个palybook只能演一场戏，只能做做特定的事；编写role通过组合role可以实现更加复杂的操作

## 运行过程讲一下
1.  ansible启动加载配置文件
2.  ansible加载模块
3.  更具模块或命令等生成python文件发送个被管理节点
4.  被管理节点接收并保存到ansible设置的目录下
5.  对python文件加可执行权限
6.  执行完成后返回结果，并删除python文件sleep退出

# 进程、线程、协程

## 进程线程协程区别
1.  **进程**：保存在硬盘上的程序运行以后，会在内存空间里形成一个独立的内存体，这个内存体有自己独立的地址空间，有自己的堆，上级挂靠单位是操作系统。操作系统会以进程为单位，分配系统资源（CPU时间片、内存等资源），进程是资源分配的最小单位。
2.  **线程**：线程，有时被称为轻量级进程(Lightweight Process，LWP），是操作系统调度（CPU调度）执行的最小单位。
3.  **协程**：协程是由程序自己决定的；协程在子程序内部是可中断的，然后转而执行别的子程序，在适当的时候再返回来接着执行；不需要切换线程进程造成资源浪费因为只有一个线程，也不存在同时写变量冲突，在协程中控制共享资源不加锁。

##  进程线程区别：
1.  进程是资源分配的最小单位，线程是调度和分配的基本单位；
2.  不同进程可以并发，同一个进程中的线程需要考虑资源冲突
3.  进程拥有静态资源，线程不拥有资源，只有动态分配的资源；系统开销上，进程的创建、切换和销毁相比线程更加大

## 联系：
1.  线程一个线程只能属于一个进程，而一个进程可以有多个线程，但至少有一个线程；
2.  线程共享同一个进程的资源
3.  线程在执行过程中，需要协作同步。不同进程的线程间要利用消息通信的办法实现同步。

# apache

## apache的认证和授权
- 认证：识别用户的过程
- 授权：给予特定用户对特定资源区域的访问

## 认证
- basic与digest两种，basic更加广泛支持，但是传输base64明文编码，相比与diges传送摘要先得不安全

## mod_ssl 有什么用以及SSL在Apache中如何工作
- mod_ssl模块，提供了安全套接字和传输层加密协议让信息传递更加安全；
- 使用：客户端访问服务器时，apache会将私钥生成csr发送给证书管理中心。证书管理中心会更具这个csr文件返回证书

## 常见安全模块
- mod_security模块：完整的http流量记录。提供实时的监控和攻击检测
- mod_ssl模块：提供安全套接字与加密传输功能

## 讲讲mpm工作模式
1.  perfect：采用的是预派生子进程方式，用单独的子进程来处理请求，子进程间互相独立，互不影响，大大的提高了稳定性，但每个进程都会占用内存，所以消耗系统资源过高；
2.  worker：支持多进程多线程混合模型的MPM，每个子进程可以生成多个子线程来响应请求；每个进程会生成多个线程，由线程来处理请求，这样可以保证多线程可以获得进程的稳定性；
3.  event：它和 worker模式很像，最大的区别在于，它解决了 keep-alive 场景下 ，长期被占用的线程的资源浪费问题；会有一个专门的线程来管理这些 keep-alive 类型的线程，当有真实请求过来的时候，将请求传递给服务线程，执行完毕后，又允许它释放
- 使用ab测压工具可以进行简单的测试

# Nginx
- 基础：https://zhuanlan.zhihu.com/p/31196264
- 基础配置：https://zhuanlan.zhihu.com/p/101961241
- keepalive + nginx：https://zhuanlan.zhihu.com/p/102528726

## 模块

### ngx_http_headers_module：向由代理服务器响应给客户端的响应报文添加自定义首部，或修改指定首部的值
1.  add_header name：添加自定义首部
2.  expires：用于定义Expire或Cache-Control首部的值

### 限制模块
- [相关链接](https://www.jb51.net/article/137262.htm)

- ngx_http_limit_req_module ：用来限制单位时间内的请求数，即速率限制,采用的漏桶算法 “leaky bucket”

- ngx_http_limit_conn_module ：用来限制同一时间连接数，即并发限制

- limit_rate和limit_rate_after ：下载速度设置

- 并发数控制
    ```
    http {
      limit_conn_log_level error;
      limit_conn_zone $binary_remote_addr zone=addr:10m;
      limit_conn_status 503;
      server {
        location /download/ {
          limit_conn addr 1; 单个客户端IP限制为1
        }
    }
    ```
    ```
    http{
    limit_conn_zone $binary_remote_addr zone=perip:10m;
    limit_conn_zone $server_name zone=perserver:10m;       
      server {
        limit_conn perip 10;  #单个客户端ip与服务器的连接数
        limit_conn perserver 100; #限制与服务器的总连接数
      }
    }
    ```

- 限制下载和速度
    ```
    location /download {
      limit_rate 128k;
    }
    #如果想设置用户下载文件的前10m大小时不限速，大于10m后再以128kb/s限速可以增加以下配内容
    location /download {
      limit_rate_after 10m;
      limit_rate 128k;
    }
    ```

## 面试题

### 如何设置访问评率
- 修改配置文件利用限制模块
    ```
    http {
      limit_req_status 599;
      limit_req_zone $clientRealIp zone=allips:70m rate=5r/s;
    }

    server {
      limit_req zone=allips burst=5 nodelay;
    }
    ```

### nginx url 重写功能
- ## 重写rewrite
    url重写是指通过配置conf文件，以让网站的url中达到某种状态时则定向/跳转到某个规则，比如常见的伪静态、301重定向、浏览器定向等

    | rewrite | \<regex> | \<replacement> | [flag] |
    |---|---|---|---|
    | 关键字 | 正则 | 替代内容 | flag标记 |

    - 关键字：**其中关键字error_log不能改变**

    - 正则表达式匹配：perl兼容正则表达式语句进行规则匹配

    - 替换内容：将正则匹配的内容替换成replacement

    - flag：rewrite支持的flag标记
        - last ---> 本条规则匹配完成后，继续向下匹配新的location URI规则, 浏览器地址栏URL地址不变
        - break ---> 本条规则匹配完成即终止，不再匹配后面的任何规则, 浏览器地址栏URL地址不变
        - redirect ---> 返回302临时重定向，浏览器地址会显示跳转后的URL地址
        - permanent ---> 返回301永久重定向，浏览器地址栏会显示跳转后的URL地址

    ```
    server {
        # 访问 /last.html 的时候，页面内容重写到 /index.html 中
        rewrite /last.html /index.html last;

        # 访问 /break.html 的时候，页面内容重写到 /index.html 中，并停止后续的匹配
        rewrite /break.html /index.html break;

        # 访问 /redirect.html 的时候，页面直接302定向到 /index.html中
        rewrite /redirect.html /index.html redirect;

        # 访问 /permanent.html 的时候，页面直接301定向到 /index.html中
        rewrite /permanent.html /index.html permanent;

        # 把 /html/*.html => /post/*.html ，301定向
        rewrite ^/html/(.+?).html$ /post/$1.html permanent;

        # 把 /search/key => /search.html?keyword=key
        rewrite ^/search\/([^\/]+?)(\/|$) /search.html?keyword=$1 permanent;
    }
    ```

- ## if判断
    - 语法
        ```
        if (表达式) {
           ... ...
        }
        ```

    - 注意
        - 当表达式只是一个变量时，如果值为空或任何以0开头的字符串都会当做false
        - 直接比较变量和内容时，使用=或!=
        - 正则表达式匹配，\*不区分大小写的匹配，!~区分大小写的不匹配

    - 判断条件

    | 判断符 | 解释 |
    |---|---|
    -f 和 !-f | 用来判断是否存在文件
    -d 和 !-d | 用来判断是否存在目录
    -e 和 !-e | 用来判断是否存在文件或目录
    -x 和 !-x | 用来判断文件是否可执行

    - 内置变量
        ```
        $content_length ： 请求头中的Content-length字段。
        $content_type ： 请求头中的Content-Type字段。
        $document_root ： 当前请求在root指令中指定的值。
        $host ： 请求主机头字段，否则为服务器名称。
        $http_user_agent ： 客户端agent信息
        $http_cookie ： 客户端cookie信息
        $limit_rate ： 这个变量可以限制连接速率。
        $request_method： 客户端请求的动作，通常为GET或POST。
        $remote_addr： 客户端的IP地址。
        $remote_port： 客户端的端口。
        $remote_user： 已经经过Auth Basic Module验证的用户名。
        $request_filename： 当前请求的文件路径，由root或alias指令与URI请求生成。
        $scheme： HTTP方法（如http，https）。
        $server_protocol： 请求使用的协议，通常是HTTP/1.0或HTTP/1.1。
        $server_addr： 服务器地址，在完成一次系统调用后可以确定这个值。
        $server_name： 服务器名称。
        $server_port： 请求到达服务器的端口号。
        $request_uri： 包含请求参数的原始URI，不包含主机名，如：”/foo/bar.php?arg=baz”。
        uri：不包含主机名，如”/foo/bar.html”。
        ```

    - 小实例
        ```
        server {
            # 如果文件不存在则返回400
            if (!-f $request_filename) {
                return 400;
            }
            # 如果host不是xuexb.com，则301到xuexb.com中
            if ( $host != "xuexb.com" ){
                rewrite ^/(.*)$ https://xuexb.com/$1 permanent;
            }            
            # 如果请求类型不是POST则返回405
            if ($request_method = POST) {
                return 405;
            }            
            # 如果参数中有 a=1 则301到指定域名
            if ($args ~ a=1) {
                rewrite ^ http://example.com/ permanent;
            }
        }
        ```

### nginx如何实现高并发
1.  异步，非阻塞，使用了epoll 和大量的底层代码优化。（餐厅服务员服务客服案例）
2.  master和worker线程

### 为什么 Nginx 不使用多线程?
- Apache: 创建多个进程或线程，而每个进程或线程都会为其分配 cpu 和内存(线程要比进程小的多，所以worker支持比perfork高的并发)，并发过大会耗光服务器资源。
- Nginx: 采用单线程来异步非阻塞处理请求(管理员可以配置Nginx主进程的工作进程的数量)(epoll)，不会为每个请求分配cpu和内存资源，节省了大量资源，同时也减少了大量的CPU的上下文切换。所以才使得Nginx支持更高的并发。

### Nginx常见的优化配置有哪些?
1.  调整worker_processes：work进程数，通常与cpu核数相当
    ```sh
    worker_processes auto
    ```
2.  最大化worker_connections：每个work进程能够处理的最大请求数
    ```sh
    events {
      worker_connections 1024
    }
    ```
3.  启用Gzip压缩：压缩文件大小，提高带宽利用率
    ```shell
    gzip on;
    gzip_http_version 1.1;
    ```
4.  为静态文件启用缓存：
    ```shell
    location ~* .(jpg|jpeg|png|gif|ico|css|js)$ {  
    expires 365d;  
    }
    ```
5.  Timeouts：keepalive连接减少了打开和关闭连接所需的CPU和网络开销；
    ```sh
    keepalive_timeout   65;
    send_timeout  10;
    ```

### 负载均衡算法
1.  轮询(默认)：每个请求按时间顺序逐一分配到不同的后端服务，如果后端某台服务器死机，自动剔除故障系统，使用户访问不受影响。
2.  weight（轮询权值）：weight的值越大分配到的访问概率越高，主要用于后端每台服务器性能不均衡的情况下。或者仅仅为在主从的情况下设置不同的权值，达到合理有效的地利用主机资源
ip_hash：每个请求按访问IP的哈希结果分配，使来自同一个IP的访客固定访问一台后端服务器，并且可以有效解决动态网页存在的session共享问题。
3.  fair：比weight、ip_hash更加智能的负载均衡算法，fair算法可以根据页面大小和加载时间长短智能地进行负载均
衡，也就是根据后端服务器的响应时间来分配请求，响应时间短的优先分配。Nginx本身不支持fair，如果需要这种调度算法，则必须安装upstream_fair模块。
4.  url_hash：按访问的URL的哈希结果来分配请求，使每个URL定向到一台后端服务器，可以进一步提高后端缓存服务器的效率。Nginx本身不支持url_hash，如果需要这种调度算法，则必须安装Nginx的hash软件包。

## nginx与httpd的平滑启动

### nginx

```sh
nginx -s reload/reopen/stop/quit
# reload 读取配置文件重启
# reopen 重新打开日志文件
# stop 立即退出
# quit 优雅的退出
nginx -t # 检查配置文件是否正确，不会重启nginx
```

### httpd

```sh
apachectl -k graceful
# 重新加载配置，并且不会停止现有的正在处理的请求。主进程和正在有请求的进程不会变化。但假如配置文件语法有错误，apache会停止掉。
# graceful信号使得父进程建议子进程在完成它们现在的请求后退出(如果他们没有进行服务，将会立刻退出)。父进程重新读入配置文件并重新打开日志文件。每当一个子进程死掉，父进程立刻用新的配置文件产生一个新的子进程并立刻开始伺服新的请求。
service httpd reload
# 重新加载配置，现有的请求会被中断，除了主进程外其他的进程都被重建。如果配置文件有问题的话，会不做操作，保持原有配置，apache不会中止。
```

# select、poll、epoll
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

# nginx，lvs，haproxy

## nginx

### 优点
1. 工作在网络7层之上，可针对http应用做一些分流的策略，如针对域名、目录结构，它的正规规则比HAProxy更为强大和灵活，所以，目前为止广泛流行。
1. Nginx安装与配置比较简单，测试也比较方便，基本能把错误日志打印出来。
1. 可以承担高负载压力且稳定，硬件不差的情况下一般能支撑几万次的并发量，负载度比LVS小。
1. Nginx可以通过端口检测到服务器内部的故障，如根据服务器处理网页返回的状态码、超时等，并会把返回错误的请求重新提交到另一个节点。
1. 不仅仅是优秀的负载均衡器/反向代理软件，同时也是强大的Web应用服务器。
1. 可作为静态网页和图片服务器。

### 缺点
1. 对后端服务器的健康检查，只支持通过端口检测，不支持url来检测。

## lvs

### 优点
1. 抗负载能力强、是工作在网络4层之上仅作分发之用，没有流量的产生，这个特点也决定了它在负载均衡软件里的性能最强的，对内存和cpu资源消耗比较低。
1. 配置性比较低，这是一个缺点也是一个优点，因为没有可太多配置的东西，所以并不需要太多接触，大大减少了人为出错的几率。
1. 工作稳定，因为其本身抗负载能力很强，自身有完整的双机热备方案，如LVS+Keepalived
1. 应用范围比较广，因为LVS工作在4层，所以它几乎可以对所有应用做负载均衡，包括http、数据库、在线聊天室等等。

### 缺点
1. 软件本身不支持正则表达式处理，不能做动静分离；而现在许多网站在这方面都有较强的需求
1. 如果是网站应用比较庞大的话，LVS/DR+Keepalived实施起来就比较复杂了

## haproxy

### 优点
1. HAProxy是支持虚拟主机的，可以工作在4、7层(支持多网段)
1. HAProxy的优点能够补充Nginx的一些缺点，比如支持Session的保持，Cookie的引导；同时支持通过获取指定的url来检测后端服务器的状态。
1. HAProxy跟LVS类似，本身就只是一款负载均衡软件；单纯从效率上来讲HAProxy会比Nginx有更出色的负载均衡速度，在并发处理上也是优于Nginx的。

### 缺点
1. 重载配置的功能需要重启进程，虽然也是soft restart，但没有Nginx的reaload更为平滑和友好。
1. 多进程模式支持不够好
1. 不支持HTTP cache功能。

## nginx与lvs对比
1.  nginx配置相对比较丰富，可配置程度高，测试相对较容易。lvs没什么好配置的，相对简单。
2.  lvs的抗负载能力比nginx更优秀，本身不会产生流量只会对请求进行转发，nginx受限于自身io能力。但是lvs对于网络的依赖程度比nginx高。nginx没有成熟的双机热备方案，而lvs可以通过keepalive来保持。nginx也可一通过keepalive进行一定程度的上机热备来弥补这一缺点。
3.  故障检测方面，nginx通过对服务器端口进行检测，返回的状态码进行检测。超时后通过将流量请求转发给另一个服务器。而lvs是对服务器内部情况进行检测，服务器不可用后的策略是直接断掉，而不是重发。这回影响用户的一定的体验。
4.  nginx的使用范围更广泛。可以使单节点的服务器，还可以是负载均衡器和代理服务器。而lvs一般只用来做负载均衡器。其他性能方面比nginx差一些。
5.  选择nginx作为前端的优点
    1.  并发高
    2.  内存消耗少
    3.  配置文件比较丰富也比较简单
    4.  成本低
    5.  支持重写功能，更具域名和url分配服务器
    6.  节省带宽，可以对数据进行压缩

### 使用场景
1.  抗负载能力
    1.  lvs抗负载能力最强，因为仅作分发不处理请求，相当于只作转发不做进一步处理直接在内核中完成，对系统资源消耗低（LVS DR模式）；

    2.  nginx和haproxy相对来说会弱，但是日PV2000万也没什么问题，因为不仅接受客户端请求，还与后端upstream节点进行请求并获取响应，再把响应返回给客户端，对系统资源和网络资源消耗高；

2.  功能性
    1.  lvs仅支持4层tcp负载均衡，haproxy可以支持4层tcp和7层http负载均衡，nginx可以支持7层http负载均衡（新版本也支持4层负载均衡）；

    2.  nginx功能强大，配置灵活，可做web静态站点，静态缓存加速，动静分离，并支持域名，正则表达式，Location匹配，rewrite跳转，配置简单直观明了，还可以结合etc或consule做发布自动化上下线等等；

    3.  haproxy相对nginx的7层负载均衡会弱一些，灵活性不足，个人建议一般用haproxy做TCP负载均衡更合适一些；

3.  运维复杂度
    1.  lvs相对来说部署架构更复杂一些，lvs对网络是有要求，lvs必须与real server在同一个网段，也更费资源，需要多2台服务器成本；
    2.  nginx和haproxy部署架构更简单，对网络也没要求，更便于后续维护；
