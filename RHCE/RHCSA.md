---
title: RHCSA备考
date: 2019/11/15 14:09:00
tags: Others
categories: Linux
---

## RHCSA

### 重置root密码，救援模式

```sh
mount -o remount,rw /sysroot
chroot /sysroot
passwd root
touch /.authrelabel
exit
exit

systemctl set-default gra
```

### 配置SELinux

```sh
setenforce 1
vim /etc/selinux/config
  SELINUX=enforcing
```

### 配置yum仓库

```sh
vim /etc/yum.repos.d/base.repo
  [base]
  name = RHCSA
  baseurl = url
  enable = 1
  gpgcheck = 0
```

### 调整逻辑卷

```sh
lvextend -L 770M /dev/vg/lvm1
xfs_growfs /dev/vg/lvm1
#resize2fs /dev/vg/lvm1
```

### 创建用户和用户组

```sh
[root@server0 ~]# groupadd -g 40000 adminuser
[root@server0 ~]# useradd -G 40000 natasha
[root@server0 ~]# useradd -G 40000 harry
[root@server0 ~]# useradd -s /sbin/nologin sarah
[root@server0 ~]# echo 'glegunge' | passwd --stdin natasha
```
### 文件权限设定

```sh
[root@server0 ~]# cp -a /etc/fstab /var/tmp/fstab
[root@server0 ~]# ll /var/tmp/fstab
-rw-r--r--. 1 root root 438 Nov  1  2017 /var/tmp/fstab
[root@server0 ~]# setfacl -m u:harry:---,u:natasha:rwx,o::r-x /var/tmp/fstab
```

### 建立计划任务

```sh
[root@server0 ~]# crontab -e -u natasha
no crontab for natasha - using an empty one
crontab: installing new crontab
[root@server0 ~]# crontab -l -u natasha
23 14 * * * /bin/echo 'rhcsa'
```

### 文件特殊权限设定

```sh
[root@server0 ~]# mkdir -p /home/admins
[root@server0 ~]# chgrp adminuser /home/admins/
[root@server0 ~]# chmod 770 /home/admins/
[root@server0 ~]# chmod g+s /home/admins/
[root@server0 ~]# ll -d /home/admins/
drwxrws---. 2 root adminuser 1024 Nov 15 09:29 /home/admins/
```

### 升级内核

```sh
[root@server0 ~]# rpm -ivh http://content.example.com/rhel7.0/x86_64/errata/Packages/kernel-3.10.0-123.1.2.el7.x86_64.rpm
```

### 配置NTP服务

```sh
[root@server0 ~]# vim /etc/chrony.conf
[root@server0 ~]# systemctl enable chrony
[root@server0 ~]# systemctl restart chrony
[root@server0 ~]# chronyc
  chronyc> waitsync
```

### 配置LDAP客户端

```sh
[root@server0 ~]# yum install sssd krb5-workstation.x86_64 authconfig-gtk.x86_64
[root@server0 ~]# authconfig-gtk
[root@server0 ~]# systemctl enable sssd
[root@server0 ~]# systemctl restart sssd
```

### 配置autofs挂载

```sh
[root@server0 ~]# yum install -y autofs.x86_64
[root@server0 ~]# mkdir /home/guests
[root@server0 ~]# vim /etc/auto.master
  /home/guests  /etc/ldap.misc
[root@server0 ~]# cp -a /etc/auto.misc /etc/ldap.misc
[root@server0 ~]# vim /etc/ldap.misc
  ldapuser0   -fstype=nfs,v3,rw classroom.example.com:/home/guests/ldapuser0
[root@server0 ~]# systemctl enable autofs.service
[root@server0 ~]# systemctl restart autofs.service
[root@server0 ~]# su - ldapuser0
```

### 打包

```sh
[root@server0 ~]# tar -jcvf /root/syyconfig.tar.bz2 /etc/sysconfig/
```

### 添加用户

```sh
[root@server0 ~]# useradd -u 3456 alex
[root@server0 ~]# echo 'glegunge' | passwd --stdin alex
```

### 创建swap分区

```sh
[root@server0 ~]# fdisk /dev/sda
[root@server0 ~]# partprobe
[root@server0 ~]# mkswap /dev/sda5
[root@server0 ~]# vim /etc/fstab
[root@server0 ~]# swapon -a
[root@server0 ~]# free -h
```

### 查找文件

```sh
[root@server0 ~]# find / -user ira -exec cp -a {} /root/findfiles/ \;
```

### 过滤文件

```sh
[root@server0 ~]# grep 'seismic' /usr/share/dict/words > /root/wordlist
```

### 创建逻辑卷

```sh
[root@server0 ~]# fdisk /dev/sda
[root@server0 ~]# partprobe
[root@server0 ~]# pvcreate /dev/sda6
[root@server0 ~]# vgcreate rhcsa -s 16M /dev/sda6
[root@server0 ~]# lvcreate -n lvm2 -l 8 rhcsa
[root@server0 ~]# mkfs.xfs /dev/rhcsa/lvm2
[root@server0 ~]# vim /etc/fstab
  /dev/rhcsa/lvm2   /exam/lvm2  xfs   defaults  0 0
[root@server0 ~]# mkdir -p /exam/lvm2
[root@server0 ~]# mount -a
[root@server0 ~]# df -Th
```

### 调整逻辑卷

```sh
lvextend -L 1000M /dev/exam/home
resize2fs /dev/exam/home
df -Th
```

```sh
umount /dev/exam/src
e2fsck -f /dev/exam/src
resize2fs /dev/exam/src 400M
lvreduce -L 400M /dev/exam/src
mount -a
df -Th
```
