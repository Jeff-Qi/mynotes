### 软硬链接的区别
-  硬链接文件与源文件的inode节点号相同，不会占用新的inode和block，只是在某个目录的block下记录，不能跨文件系统和目录；
-  软链接文件的inode节点号与源文件不同，需要占用新的inode和block，可以跨文件系统和链接目录；

### linux启动流程
1.  BIOS===》加载第一扇区===》加载/boot引导内核===》运行 init/systemd===》系统初始化===》运行级别===》建立终端===》用户登录系统
- 接电后BOIS载入，然后加载第一扇区，加载/boot目录，开始引导内核，初始化程序systemd，运行设置的runlevel等级。初始化系统，启动设置为开机自启动的程序。生成终端，等待用户登录。

#### linux开机启动级别
1.  runlevel有7个0~6：
    - 运行级别0：系统停机状态，系统默认运行级别不能设为0，否则不能正常启动
    - 运行级别1：单用户工作状态，root权限，用于系统维护，禁止远程登陆
    - 运行级别2：多用户状态(没有NFS)
    - 运行级别3：完全的多用户状态(有NFS)，登陆后进入控制台命令行模式
    - 运行级别4：系统未使用，保留
    - 运行级别5：X11控制台，登陆后进入图形GUI模式
    - 运行级别6：系统正常关闭并重启，默认运行级别不能设为6，否则不能正常启动

## ansible讲一下
- ansible使用python编写的自动化运维工具。实现了批量设置管理服务器，操作效率高。ansible基于模块化工作。本身并没有批量管理的功能，通过其他模块来实现这些功能。

#### ansible架构
- ansible：核心组件
- module：包含喊自带的核心模块和自定义模块
- plugin：对于模块功能的完善比如，邮件插件，链接插件等
- inventory：主机清单，需要管理的主机信息
- playbook：剧本，定义多个任务的配置文件，由ansible自动运行
- connection plugin：负责被监控端的通信

#### role相比于编写完整的playbook的优点
- 一个palybook只能演一场戏，只能做做特定的事；编写role通过组合role可以实现更加复杂的操作

#### 运行过程讲一下
1.  ansible启动加载配置文件
2.  ansible加载模块
3.  更具模块或命令等生成python文件发送个被管理节点
4.  被管理节点接收并保存到ansible设置的目录下
5.  对python文件加可执行权限
6.  执行完成后返回结果，并删除python文件sleep退出

## 进程、线程、协程

### 进程线程协程区别
1.  **进程**：保存在硬盘上的程序运行以后，会在内存空间里形成一个独立的内存体，这个内存体有自己独立的地址空间，有自己的堆，上级挂靠单位是操作系统。操作系统会以进程为单位，分配系统资源（CPU时间片、内存等资源），进程是资源分配的最小单位。
2.  **线程**：线程，有时被称为轻量级进程(Lightweight Process，LWP），是操作系统调度（CPU调度）执行的最小单位。
3.  **协程**：协程是由程序自己决定的；协程在子程序内部是可中断的，然后转而执行别的子程序，在适当的时候再返回来接着执行；不需要切换线程进程造成资源浪费因为只有一个线程，也不存在同时写变量冲突，在协程中控制共享资源不加锁。

####  进程线程区别：
1.  进程是资源分配的最小单位，线程是调度和分配的基本单位；
2.  不同进程可以并发，同一个进程中的线程需要考虑资源冲突
3.  进程拥有静态资源，线程不拥有资源，只有动态分配的资源；系统开销上，进程的创建、切换和销毁相比线程更加大

#### 联系：
1.  线程一个线程只能属于一个进程，而一个进程可以有多个线程，但至少有一个线程；
2.  线程共享同一个进程的资源
3.  线程在执行过程中，需要协作同步。不同进程的线程间要利用消息通信的办法实现同步。

## apache

#### apache的认证和授权
- 认证：识别用户的过程
- 授权：给予特定用户对特定资源区域的访问

#### 认证
- basic与digest两种，basic更加广泛支持，但是传输base64明文编码，相比与diges传送摘要先得不安全

#### mod_ssl 有什么用以及SSL在Apache中如何工作
- mod_ssl模块，提供了安全套接字和传输层加密协议让信息传递更加安全；
- 使用：客户端访问服务器时，apache会将私钥生成csr发送给证书管理中心。证书管理中心会更具这个csr文件返回证书

#### 常见安全模块
- mod_security模块：完整的http流量记录。提供实时的监控和攻击检测
- mod_ssl模块：提供安全套接字与加密传输功能

#### 讲讲mpm工作模式
1.  perfect：采用的是预派生子进程方式，用单独的子进程来处理请求，子进程间互相独立，互不影响，大大的提高了稳定性，但每个进程都会占用内存，所以消耗系统资源过高；
2.  worker：支持多进程多线程混合模型的MPM，每个子进程可以生成多个子线程来响应请求；每个进程会生成多个线程，由线程来处理请求，这样可以保证多线程可以获得进程的稳定性；
3.  event：它和 worker模式很像，最大的区别在于，它解决了 keep-alive 场景下 ，长期被占用的线程的资源浪费问题；会有一个专门的线程来管理这些 keep-alive 类型的线程，当有真实请求过来的时候，将请求传递给服务线程，执行完毕后，又允许它释放
- 使用ab测压工具可以进行简单的测试

## Nginx
- 基础：https://zhuanlan.zhihu.com/p/31196264
- 基础配置：https://zhuanlan.zhihu.com/p/101961241
- keepalive + nginx：https://zhuanlan.zhihu.com/p/102528726

### 模块

#### ngx_http_headers_module：向由代理服务器响应给客户端的响应报文添加自定义首部，或修改指定首部的值
1.  add_header name：添加自定义首部
2.  expires：用于定义Expire或Cache-Control首部的值

#### nginx_http_proxy_module：代理模块
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
#### ngx_http_fastcgi_module：缓存模块
```sh
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

####  ngx_http_upstream_module：负载均衡
1.  upstream：定义后端服务器组，会引入一个新的上下文
2.  server：在upstream上下文中server成员，以及相关的参数
    ```sh
    server address的parment相关参数：
    weight=number # 权重，默认为1； 
    max_fails=number # 失败尝试最大次数；超出此处指定的次数时，server将被标记为不可用； 
    fail_timeout=time # 设置将服务器标记为不可用状态的超时时长； 
    max_conns # 当前的服务器的最大并发连接数； 
    backup # 将服务器标记为“备用”，即所有服务器均不可用时此服务器才启用； 
    down # 标记为“不可用”
    ```
3.  least_conn；：最少连接调度算法，当server拥有不同的权重时其为wlc
4.  ip_hash；：源地址hash调度方法
5.  hash ：基于指定的key的hash表来实现对请求的调度，此处的key可以直接文本、变量或二者的组合
6.  keepalive connections;：为每个worker进程保留的空闲的长连接数量；
```sh
# 七层代理
upstream websers{ 
    server 192.168.10.20; 
    server 192.168.10.30; 
} 
server{ 
    listen  8080; 
    server_name 172.16.0.10:8080; 
    location / { 
        proxy_pass  http://websers; 
    } 
} 
# 四层代理
stream { 
    upstream sshsers{ 
        server 192.168.10.20:22; 
        server 192.168.10.30:22; 
        least_conn; 
    } 
    server{ 
        listen 172.16.0.10:22222; # 这里决定
        proxy_pass sshsers; 
        } 
} 
```

### 面试题

#### nginx如何实现高并发
1.  异步，非阻塞，使用了epoll 和大量的底层代码优化。（餐厅服务员服务客服案例）
2.  master和worker线程

#### 为什么 Nginx 不使用多线程?
- Apache: 创建多个进程或线程，而每个进程或线程都会为其分配 cpu 和内存(线程要比进程小的多，所以worker支持比perfork高的并发)，并发过大会耗光服务器资源。
- Nginx: 采用单线程来异步非阻塞处理请求(管理员可以配置Nginx主进程的工作进程的数量)(epoll)，不会为每个请求分配cpu和内存资源，节省了大量资源，同时也减少了大量的CPU的上下文切换。所以才使得Nginx支持更高的并发。

#### Nginx常见的优化配置有哪些?
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

#### 负载均衡算法
1.  轮询(默认)：每个请求按时间顺序逐一分配到不同的后端服务，如果后端某台服务器死机，自动剔除故障系统，使用户访问不受影响。
2.  weight（轮询权值）：weight的值越大分配到的访问概率越高，主要用于后端每台服务器性能不均衡的情况下。或者仅仅为在主从的情况下设置不同的权值，达到合理有效的地利用主机资源
ip_hash：每个请求按访问IP的哈希结果分配，使来自同一个IP的访客固定访问一台后端服务器，并且可以有效解决动态网页存在的session共享问题。
3.  fair：比weight、ip_hash更加智能的负载均衡算法，fair算法可以根据页面大小和加载时间长短智能地进行负载均
衡，也就是根据后端服务器的响应时间来分配请求，响应时间短的优先分配。Nginx本身不支持fair，如果需要这种调度算法，则必须安装upstream_fair模块。
4.  url_hash：按访问的URL的哈希结果来分配请求，使每个URL定向到一台后端服务器，可以进一步提高后端缓存服务器的效率。Nginx本身不支持url_hash，如果需要这种调度算法，则必须安装Nginx的hash软件包。
