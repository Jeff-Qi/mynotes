---
title: 网络IO模型
date: 2020-03-22 21:33:00
categories: Linux
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [五类网络IO模型](#五类网络io模型)
- [I/O 多路复用之select、poll、epoll](#io-多路复用之selectpollepoll)
- [参考文档](#参考文档)
<!-- TOC END -->
<!--more-->

# 五类网络IO模型
- #### **阻塞io**：
    当进程发起调用后，系统没有将资源准备好，进程就会一直等待系统回复信号，等待系统将数据从硬件设备拷贝到内核空间，然后拷贝数据到用户空间，完成后系统才会返回信号；进程继续执行；此期间，该进程一直被挂起，不能做任何事情

    ![blocking_io](http://study.jeffqi.cn/linux/blocking_io.png)

- #### **非阻塞io**：
    当系统发起调用后，系统没有将资源准备好，但是会立即回复error，进程收到后知道数据没有准备好，于是会不断的询问，但是系统不会被阻塞，资源准备好后会将资源拷贝到用户空间；但会造成cpu空轮询，造成资源浪费；这时候一个进程可以处理多个连接请求；

    ![unblocking_io](http://study.jeffqi.cn/linux/unblocking_io.png)

- #### **io多路复用**：
    进程发起调用后，会将一个fd注册过到select/poll中进程会阻塞在这个调用上；但是这一个进程可以同时处理多个连接请求，只需要经fd注册到select/poll中；不同于空轮询；io多路复用中内核会监控每一个fd的准备状态，任何一个准备好后，select/poll就会立即返回；然后轮询注册的fd，找到准备好的哪一个，然后将资源复制到用户空间；这样做避免了空轮询，但是每次都需要遍历所有的fd，找到准备好的fd，开销较大；而epoll就能避免遍历，当有fd准备好后，会直接返回这一个fd，进程直接就能知道是那个fd准备好时间复杂度为O(1)；节省了资源

    ![io_multiplexing](http://study.jeffqi.cn/linux/io_multiplexing.png)

- #### **信号io**：
    调用后，系统立刻放回，不会阻塞进程；在资源准备好后，发送信号通知进程回调，将数据拷贝到用户空间

- #### **异步io**：
    发起调用后，立即返回，当资源拷贝到内核空间后，发送信号告诉进程资源已经在用户空间可以使用了

    ![async_io](http://study.jeffqi.cn/linux/async_io.png)

# I/O 多路复用之select、poll、epoll
- ### select：
    select 函数监视的文件描述符分3类，分别是writefds、readfds、和exceptfds；调用后select函数会阻塞，直到有描述副就绪（有数据 可读、可写、或者有except），或者超时（timeout指定等待时间，如果立即返回设为null即可），函数返回。当select函数返回后，可以 通过遍历fdset，来找到就绪的描述符。
    ```c
    int select (int n, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout);
    ```
    1.  有点：跨平台
    2.  监听的数量有限1024个
- ### poll：
    不同与select使用三个位图来表示三个fdset的方式，poll使用一个 pollfd的指针实现。pollfd结构包含了要监视的event和发生的event，不再使用select“参数-值”传递的方式。同时，pollfd并没有最大数量限制（但是数量过大后性能也是会下降）。 和select函数一样，poll返回后，需要轮询pollfd来获取就绪的描述符。
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

- ### epoll:
    epoll更加灵活，没有描述符限制。epoll使用一个文件描述符管理多个描述符，将用户关系的文件描述符的事件存放到内核的一个事件表中，这样在用户空间和内核空间的copy只需一次。
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

# 参考文档
- [linux网络IO模型](https://blog.csdn.net/muyuyuzhong/article/details/83538860)
- [Linux五大网络IO模型图解](https://www.cnblogs.com/wlwl/p/10291397.html)
- [Linux IO模式及 select、poll、epoll详解](https://segmentfault.com/a/1190000003063859)
