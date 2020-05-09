---
title: Linux下文件描述极其作用
date: 2020-04-29 11:08:00
categories: Linux
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [pid文件](#pid文件)
- [参考文档](#参考文档)
<!-- TOC END -->
<!--more-->

# pid文件

- ## 说明
    一般在 /var/run/ 下会有许多*.pid结尾的文件。这些文件是在程序运行后产生的。

- ## 文件内容
    \*.pid 文件中只能看到进程号，只有一行数据

- ## 作用
    防止进程启动多个副本。只有获得pid文件(固定路径固定文件名)写入权限(F_WRLCK)的进程才能正常启动并把自身的PID写入该文件中。其它同一个程序的多余进程则自动退出。

- ## 实现
    调用fcntl设置pid文件的锁定F_SETLK状态，其中锁定的标志位F_WRLCK

    如果成功锁定，则写入进程当前PID，进程继续往下执行。

    如果锁定不成功，说明已经有同样的进程在运行了，当前进程结束退出。

    ```C
    lock.l_type = F_WRLCK;
    lock.l_whence = SEEK_SET;

    if (fcntl(fd, F_SETLK, &lock) < 0){
        //锁定不成功, 退出......
    }
    sprintf (buf, "%d\n", (int) pid);
    pidsize = strlen(buf);
    if ((tmp = write (fd, buf, pidsize)) != (int)pidsize){
        //写入不成功, 退出......
    }
    ```

- ## 注意事项
    1.  如果进程退出，则该进程加的锁自动失效。
    2.  如果进程关闭了该文件描述符fd， 则加的锁失效。(整个进程运行期间不能关闭此文件描述符)
    3.  锁的状态不会被子进程继承。如果进程关闭则锁失效而不管子进程是否在运行。

# 参考文档
- [pid文件作用](https://blog.csdn.net/shanzhizi/article/details/23272437?depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-8&utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-8)
