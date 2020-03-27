---
title: 阿里yum-epel源替换
data: 2019-10-12 21:22:00
categories: Linux
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [阿里云 epel 源安装](#阿里云-epel-源安装)
- [阿里 yum 源](#阿里-yum-源)
<!-- TOC END -->
<!--more-->

#  阿里云 epel 源安装
```
1. 备份
mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup

mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup

2. 下载
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

3. 清除缓存
yum clean all

4. 创建缓存
yum makecache
```

#  阿里 yum 源
```
1. 备份
mv /etc/yum.repos.d/CentOS-Base.repo{,.bak}

2. 替换
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

3. 清除缓存
yum clean all

4. 创建缓存
yum makecache
```
