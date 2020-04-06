---
title: CPU性能排查实验案例
date: 2020-03-24 11:05:00
categories: Linux
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [cpu使用率高居不下，如何排查](#cpu使用率高居不下如何排查)
  - [查看cpu使用率](#查看cpu使用率)
  - [排查进程中占用cpu的函数](#排查进程中占用cpu的函数)
- [cpu高占用，却看不到高cpu引用](#cpu高占用却看不到高cpu引用)
- [参考文档](#参考文档)
<!-- TOC END -->
<!--more-->

# cpu使用率高居不下，如何排查
- linux操作系统是一个多任务的操作系统，通过划分时间片给进程来运行。

- 为了维护 CPU 时间，Linux 通过事先定义的节拍率（内核中表示为 HZ），**触发时间中断**，并使用全局变量 Jiffies **记录了开机以来的节拍数**。每发生一次时间中断，Jiffies 的值就加 1。

- 节拍率 HZ 是**内核的可配选项**，可以设置为 100、250、1000等。通过查看/boot/config 内核选项来查看它的配置值
    ```sh
    grep 'CONFIG_HZ=' /boot/config
    ```

    ![cat_proc_stat](http://study.jeffqi.cn/linux/cat_proc_stat.jpg)

- HZ决定每秒发生中断的次数；节拍率 HZ 是内核选项内核还提供了一个用户空间节拍率 USER_HZ，它总是固定为 100

- CPU使用率：CPU 使用率，就是除了空闲时间（idle）外的其他时间占总 CPU 时间的百分比

    ![cpu_use_level](http://study.jeffqi.cn/linux/cpu_use_level.png)

- 一般都会取间隔一段时间（比如 3 秒）的两次值，作差后，再计算出这段时间内的平均 CPU 使用率

    ![cpu_timely_use_level](http://study.jeffqi.cn/linux/cpu_timely_use_level.png)

- /proc/[pid]/stat 文件中有每个进程的具体信息

## 查看cpu使用率
- top：显示了系统总体的 CPU 和内存使用情况，以及各个进程的资源使用情况。
    ![top_see_source](http://study.jeffqi.cn/linux/top_see_source.jpg)

- ps：只显示了每个进程的资源使用情况
    ![ps_aux_see_source](http://study.jeffqi.cn/linux/ps_aux_see_source.jpg)

- pidstat：查看进程的使用资源情况
    ![pidstat_see_source](http://study.jeffqi.cn/linux/pidstat_see_source.jpg)

- 通过做这这些工具找出占用CPU较高的进程

## 排查进程中占用cpu的函数
- ### GDB
    GDB 在调试程序错误方面很强大，但是在调试时**会中断程序**对业务有损

- ### **perf**
    内置的性能分析工具。它以性能事件采样为基础，不仅可以分析系统的各种事件和内核性能，还可以用来分析指定应用程序的性能问题。
-   **perf top**：显示占用 CPU 时钟最多的函数或者指令，因此可以用来**查找热点函数**
    ![perf_top](http://study.jeffqi.cn/linux/perf_top.jpg)

    - 第一行包含三个数据，分别是采样数（Samples）、事件类型（event）和事件总数量（Event count）
    - 第一列 Overhead ，是该符号的性能事件在所有采样中的比例，用百分比来表示。
    - 第二列 Shared ，是该函数或指令所在的动态共享对象（Dynamic Shared Object），如内核、进程名、动态链接库名、内核模块名等。
    - 第三列 Object ，是动态共享对象的类型。比如 [.] 表示用户空间的可执行程序、或者动态链接库，而 [k] 则表示内核空间。
    - 最后一列 Symbol 是符号名，也就是函数名。当函数名未知时，用十六进制的地址来表示。
-   **perf record 与 perf report**：perf record 则提供了保存数据的功能，保存后的数据，需要你用 perf report 解析展示。
    ![per_record_per_report](http://study.jeffqi.cn/linux/perf_record_perf_report.jpg)

- **使用perf top和perf record时配合使用 -g 参数，可以获取调用关系**
    ![per_top_g](http://study.jeffqi.cn/linux/per_top_g.jpg)

# cpu高占用，却看不到高cpu引用


# 参考文档
- [CPU占用率搞](https://time.geekbang.org/column/article/70476)
- [CPU占用率高，却找不高CPU应用](https://time.geekbang.org/column/article/70822)
