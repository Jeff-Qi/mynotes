---
title: awk
date: 2019-10-11 19:46:07
categories: Linux
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [简介](#简介)
- [使用](#使用)
  - [简单实践](#简单实践)
    - [例子](#例子)
<!-- TOC END -->
<!--more-->

# 简介
- Awk是一种小巧的编程语言及命令行工具。（其名称得自于它的创始人Alfred Aho、Peter Weinberger 和 Brian Kernighan姓氏的首个字母）。它非常适合服务器上的日志处理，主要是因为Awk可以对文件进行操作，通常以可读文本构建行

# 使用

## 简单实践

### 例子
1. 默认情况下，awk通过空格分隔输入，使用 -F 指定分割符。选择输入的第的字段
```
[root@aliyun ~]# echo 'Hello awk, nice to see you' | awk -F , '{print $1,$3}'
Hello nice
[root@aliyun ~]# echo 'Hello awk, nice to see you' | awk -F ',' '{print $1,$3}'
Hello awk
```

2. awk中内置的$NF变量代表字段的数量
```
[root@aliyun ~]# echo 'Hello awk, nice to see you' | awk '{print $NF}'
you
```

3. 维持跨行状态，END代表的是我们在执行完每行的处理之后只处理下面的代码块
```
[root@aliyun ~]# echo -e 'a 1\nb 2\nc 3' | awk '{print $2}'
1
2
3
[root@aliyun ~]# echo -e 'one 1\ntwo 2' | awk '{sum+=$2} END {print sum}''
3
```
