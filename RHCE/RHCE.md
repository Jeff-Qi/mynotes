---
title: RHCE备考
date: 2019-11-12 20:06:00
tags: Others
categories: Linux
---

## RHCE

### 开机设置图形界面

```sh
systemctl set-default   graphic.target
init 6
```

### 设置 SELinux

```sh
[root@server0 ~]# vim /etc/selinux/config
SELINUX = enforcing
[root@server0 ~]# setenforce 1
[root@server0 ~]# getenforce
Enforcing
[root@server0 ~]#
```

### 设置防火墙对于ssh的访问

```sh
[root@server0 ~]# firewall-cmd --permanent --add-rich-rule "rule family='ipv4' source address='172.25.0.0/24' service name='ssh' accept"
success
[root@server0 ~]# firewall-cmd --permanent --add-rich-rule "rule family='ipv4' source address='172.17.10.0/24' service name='ssh' reject"
success
[root@server0 ~]# firewall-cmd --reload
success


[root@server0 ~]# firewall-cmd --list-all
public (default, active)
  interfaces: eth0
  sources:
  services: dhcpv6-client
  ports:
  masquerade: no
  forward-ports:
  icmp-blocks:
  rich rules:
	rule family="ipv4" source address="172.17.10.0/24" service name="ssh" reject
	rule family="ipv4" source address="172.25.0.0/24" service name="ssh" accept

```

### 在eth0口上配置ipv6地址

```sh
[root@desktop0 ~]# nmcli connection modify eth0 ipv6.method manual ipv6.addresses fddb:fe2a:ab1e::c0a8:2/64 connection.autoconnect yes
[root@desktop0 ~]# systemctl restart network
[root@desktop0 ~]# ping6 -c 4 fddb:fe2a:ab1e::c0a8:1
PING fddb:fe2a:ab1e::c0a8:1(fddb:fe2a:ab1e::c0a8:1) 56 data bytes
64 bytes from fddb:fe2a:ab1e::c0a8:1: icmp_seq=1 ttl=64 time=2.09 ms
[root@desktop0 ~]# ping -c 4 172.25.0.11
PING 172.25.0.11 (172.25.0.11) 56(84) bytes of data.
64 bytes from 172.25.0.11: icmp_seq=1 ttl=64 time=0.346 ms
```

###  配置链路聚合

```sh
[root@server0 ~]# nmcli connection add type team con-name team1 ifname team1-master  config '{"runner": {"name": "activebackup"}}'
[root@server0 ~]# nmcli connection add type team-slave con-name team1-slave1 ifname eth1 master team1-master
[root@server0 ~]# nmcli connection add type team-slave con-name team1-slave2 ifname eth2 master team1-master
[root@server0 ~]# nmcli connection modify team1 ipv4.method manual ipv4.addresses 192.168.0.101/24 connection.autoconnect yes
[root@server0 ~]# systemctl restart netwrok
[root@server0 ~]# teamdctl team1-master state
setup:
  runner: activebackup
ports:
  eth1
    link watches:
      link summary: up
      instance[link_watch_0]:
        name: ethtool
        link: up
  eth2
    link watches:
      link summary: up
      instance[link_watch_0]:
        name: ethtool
        link: up
runner:
  active port: eth1
[root@server0 ~]# ip a | grep team1-master
```

### 设置用户自定义环境

```sh
[root@server0 ~]# vim /etc/bashrc
alias qstat='/bin/ps –Ao pid,tt,user,fname,rsz'
[root@server0 ~]# bash /etc/bashrc
开启新窗口验证
```

### 配置本地邮件服务

```sh
[root@desktop0 ~]# vim /etc/postfix/main.cf
mydestination = ''
mydomain = example.com
myorigin = $mydomain
relayhost = [classroom.example.com]
[root@desktop0 ~]# systemctl enable postfix
[root@desktop0 ~]# systemctl restart postfix
[root@desktop0 ~]# mail -S 'student' student@classroom.example.com
```

### 设置端口转发

```sh
[root@server0 ~]# firewall-cmd --permanent --add-rich-rule "rule family='ipv4' source address='172.25.0.0/24' forward-port port=5423 protocol=tcp to-port=80"
success
[root@server0 ~]# firewall-cmd --permanent --add-rich-rule "rule family='ipv4' source address='172.25.0.0/24' forward-port port=5423 protocol=udp to-port=80"
success
[root@server0 ~]# firewall-cmd --reload
success
```

### 设置smb共享目录

```sh
[root@server0 ~]# yum install -y samba samba-client
[root@server0 ~]# vim /etc/samba/smb.conf
    workgroup = STAFF
    hosts allow = 127. 172.25.0.        #只有example.com域内可访问
    [common]
    path = /common
    browseable = yes            #common必须可浏览
    writable = no
[root@server0 ~]# mkdir /common
[root@server0 ~]# useradd harry
[root@server0 ~]# setfacl -m u:harry:r-x /common/
[root@server0 ~]# smbpasswd -a harry
New SMB password:
Retype new SMB password:
Added user harry.
[root@server0 ~]# pdbedit -L
harry:1001:
[root@server0 ~]# chcon -t samba_share_t /common/
[root@server0 ~]# setsebool -P samba_export_all_ro 1
Full path required for exclude: net:[4026532578].
Full path required for exclude: net:[4026532578].
[root@server0 ~]# systemctl enable smb nmb
[root@server0 ~]# systemctl restart smb nmb
[root@server0 ~]# firewall-cmd --permanent --add-service=samba
success
[root@server0 ~]# firewall-cmd --reload
success
[root@server0 ~]# smbclient //server0.example.com/common -U harry
```

### 配置多用户smb挂载

```sh
[root@server0 ~]# mkdir /devops
[root@server0 ~]# vim /etc/samba/smb.conf
[root@server0 ~]# useradd natasha
[root@server0 ~]# setfacl -m u:harry:r-x,u:natasha:rwx /devops/
[root@server0 ~]# smbpasswd -a natasha
New SMB password:
Retype new SMB password:
Added user natasha.
[root@server0 ~]# pdbedit -L
harry:1001:
natasha:1002:
[root@server0 ~]# chcon -t samba_share_t /devops
[root@server0 ~]# setsebool -P samba_export_all_rw 1
Full path required for exclude: net:[4026532578].
Full path required for exclude: net:[4026532578].
[root@server0 ~]# systemctl restart smb nmb


[root@desktop0 ~]# useradd harry
[root@desktop0 ~]# useradd natasha
[root@desktop0 ~]# mkdir /mnt/multi
[root@desktop0 ~]# vim /etc/fstab
  //server0.example.com/devops  /mnt/multi  cifs  defaults,credentials=/root/mysmb,multiuser  0 0
[root@desktop0 ~]# vim /root/mysmb
  username=harry
  password=redhat
[root@desktop0 ~]# yum install -y cifs-utils.x86_64
[root@desktop0 ~]# mount -a
[root@desktop0 ~]# cifscreds add server0 -u natasha
```

### 配置nfs服务

```sh
[root@server0 ~]# mkdir /public
[root@server0 ~]# vim /etc/exports
  /public 172.25.0.0/24(ro,sync)
[root@server0 ~]# chown nfsnobody /public/
[root@server0 ~]# mkdir /protected
[root@server0 ~]# vim /etc/exports
  /protected 172.25.0.0/24(rw,sync,sec=krb5p)
[root@server0 ~]# chown nfsnobody /protected/
[root@server0 ~]# wget http://classroom.example.com/pub/keytabs/server0.keytab -O /etc/krb5.keytab
[root@server0 ~]# mkdir -p /protected/project
[root@server0 ~]# chown ldapuser0:nfsnobody /protected/project/
[root@server0 ~]# setfacl -m u:ldapuser0:rwx /protected/project/
[root@server0 ~]# systemctl enable sssd
[root@server0 ~]# systemctl enable nfs-server.service '
[root@server0 ~]# systemctl enable nfs-secure-server.service
[root@server0 ~]# systemctl restart sssd
[root@server0 ~]# systemctl restart nfs-server.service
[root@server0 ~]# systemctl restart nfs-secure-server.service
[root@server0 ~]# firewall-cmd --permanent --add-service=mountd
[root@server0 ~]# firewall-cmd --permanent --add-service=nfs
[root@server0 ~]# firewall-cmd --permanent --add-service=rpc-bind



[root@desktop0 ~]# mkdir /mnt/nfsmount
[root@desktop0 ~]# mkdir /mnt/nfssecure
[root@desktop0 ~]# vim /etc/fstab
  server0.example.com:/public /mnt/nfsmount defaults 0  0
  server0.example.com:/protected  /mnt/nfssecure  defaults,sec=krb5p  0 0
[root@desktop0 ~]# wget http://classroom.example.com/pub/keytabs/desktop0.keytab -O /etc/krb5.keytab
[root@desktop0 ~]# systemctl enable nfs-secure.service
[root@desktop0 ~]# systemctl restart nfs-secure.service
[root@desktop0 ~]# mount -a
[root@desktop0 ~]# su - ldapuser0
[ldapuser0@desktop0 ~]$ kinit
```

### 配置web服务器

```sh
[root@server0 ~]# yum install -y httpd
[root@server0 ~]# systemctl enable httpd
[root@server0 ~]# wget http://classroom.example.com/materials/station.html -O /var/www/html/index.html
[root@server0 ~]# firewall-cmd --permanent --add-rich-rule "rule family='ipv4' source address='172.25.0.0/24' service name='http' accept"
[root@server0 ~]# firewall-cmd --permanent --add-rich-rule "rule family='ipv4' source address='172.17.10.0/24' service name='http' reject"
[root@server0 ~]# firewall-cmd --reload
[root@server0 ~]# systemctl restart httpd
```

### 配置安全访问

```sh
[root@server0 ~]# yum install -y mod_ssl
[root@server0 ~]# cd /etc/httpd/
[root@server0 httpd]# wget http://classroom.example.com/pub/tls/certs/server0.crt
[root@server0 httpd]# wget http://classroom.example.com/pub/tls/private/server0.key
[root@server0 httpd]# wget http://classroom.exampl  e.com/pub/example-ca.crt
[root@server0 httpd]# vim /etc/httpd/conf.d/ssl.conf
    SSLCertificateFile /etc/httpd/server0.crt
    SSLCertificateKeyFile /etc/httpd/server0.key
    SSLCACertificateFile /etc/httpd/example-ca.crt
[root@server0 httpd]# systemctl restart httpd
[root@server0 httpd]# firewall-cmd --permanent --add-service=https
[root@server0 httpd]# firewall-cmd --reload
```
### 配置虚拟主机

```sh
[root@server0 ~]# mkdir /var/www/virtual
[root@server0 ~]# wget http://classroom.example.com/materials/www.html -O /var/www/virtual/index.html
[root@server0 ~]# vim  /etc/httpd/conf.d/vhost.conf
  <VirtualHost _default_:80>
  	DocumentRoot /var/www/html
  	ServerName server0.example.com
  </VirtualHost>
  <VirtualHost *:80>
  	DocumentRoot /var/www/virtual
  	ServerName www0.example.com
  </VirtualHost>
[root@server0 ~]# useradd floyd
[root@server0 ~]# setfacl -m u:floyd:rwx /var/www/virtual/
[root@server0 ~]# systemctl restart httpd
```

### 配置web内容的访问

```sh
[root@server0 ~]# mkdir -p /var/www/html/private
[root@server0 ~]# wget http://classroom.example.com/materials/private.html -O /var/www/html/private/index.html
[root@server0 ~]# vim /etc/httpd/conf.d/vhost.conf
  <Directory '/var/www/html/private'>
  	require local
  </Directory>
[root@server0 ~]# systemctl restart httpd
```

### 配置web动态网页

```sh
[root@server0 ~]# yum install -y mod_wsgi
[root@server0 ~]# wget http://classroom.example.com/materials/webinfo.wsgi -O /var/www/webinfo.wsgi
[root@server0 ~]# vim /etc/httpd/conf.d/vhost.conf
  Listen 8908
  <VirtualHost *:8908>
  	ServerName webapp0.example.com
  	WSGIScriptAlias / /var/www/webinfo.wsgi
  </VirtualHost>
[root@server0 ~]# systemctl restart httpd
[root@server0 ~]# semanage port -a -t http_port_t -p tcp 8908
Full path required for exclude: net:[4026532578].
Full path required for exclude: net:[4026532578].
[root@server0 ~]# systemctl restart httpd
```

### 创建一个脚本

```sh
[root@server0 ~]# vim /root/foo.sh
  #!/bin/bash
  case $1 in
  	redhat)
  		echo 'fedora'
  	;;
  	fedora)
  		echo 'redhat'
  	;;
  	*)
  		echo '/root/foo.sh redhat|fedora'
  	;;
  esac
[root@server0 ~]# chmod +x /root/foo.sh
```

### 创建一个创建用户的脚本

```sh
[root@server0 ~]# vim /root/batchusers
  #!/bin/bash
  if [ $# -eq 0 ];then
  	echo 'Usage: /root/batusers userfile'
  	exit 1
  fi
  if [ ! -e $1 ];then
  	echo 'Input file not found'
  	exit 2
  fi
  for i in `cat $1`;do
  	useradd -s /sbin/nologin $i
  done
[root@server0 ~]# chmod +x /root/batchusers
[root@server0 ~]# wget http://classroom.example.com/materials/userlist
```

### 创建iscsi服务器

```sh
[root@server0 ~]yum install targetcli -y
[root@server0 ~]systemctl enable targetcli
[root@server0 ~]systemctl restart targetcli
[root@server0 ~]fdisk /dev/sdb
  n
  一路回车
  t
  L
  8e
[root@server0 ~]partprobe
[root@server0 ~]pvcreate /dev/sdb1
[root@server0 ~]vgcreate RHCE
[root@server0 ~]lvcreate -n iscsi_store -L 3G RHCE

客户端：cat /etc/iscsi/initiatorname.iscsi
复制选项后面acl时候用

[root@server0 ~]targetcli
    /> /backstores/block create iscsi_store /dev/RHCE/iscsi_store
    /> /iscsi create iqn.2017-02.com.example:system1
    /> /iscsi/iqn.2017-02.com.example:system1/tpg1/luns create /backstores/block/iscsi_store
    /> /iscsi/iqn.2017-02.com.example:system1/tpg1/portals create ip_address=172.25.0.11
    /> /iscsi/iqn.2017-02.com.example:system1/tpg1/acls create iqn.1994-05.com.redhat:d15b2c548ac
    /> saveconfig
    /> exit
[root@server0 ~]systemctl restart targetcli
[root@server0 ~]firewall-cmd --permanent --add-port=3206/tcp
[root@server0 ~]firewall-cmd --reload
```

### iscsi客户端配置

```sh
[root@desktop0 ~]# vim /etc/bashrc
iscsiadm --mode discoverydb --type sendtargets --portal 172.25.0.11 --discover
iscsiadm --mode node --targetname iqn.2017-02.com.example:system1 --portal 172.25.0.11:3260 --login
[root@desktop0 ~]# bash /etc/bashr
[root@desktop0 ~]# fdisk /dev/sdc
  n
  p
  1
  回车
  +2100M
  w
[root@desktop0 ~]# partprobe
[root@desktop0 ~]# mkfs.xfs /dev/sdc1
[root@desktop0 ~]# blkid /dev/sdc1
UUID=xxxxxx
[root@desktop0 ~]# vim /etc/fstab
  UUID=2a276924-796d-4268-828d-5586a0f2ffec	/mnt/data	xfs	defaults,_netdev	0	0
[root@desktop0 ~]# mount -a
```

### 部署mariadb服务器

```sh
[root@desktop0 ~]# yum install -y mariadb*
[root@desktop0 ~]# systemctl enable mariadb
[root@desktop0 ~]# systemctl restart mariadb
[root@desktop0 ~]# mysql_secure_installation
  回车
  设置密码
  一路回车
[root@desktop0 ~]# wget http://content.example.com/courses/rhce/rhel7.0/materials/mariadb/mariadb.dump
[root@desktop0 ~]# mysql -root -p
  MariaDB [(none)]> grant select on legacy.* to bob@localhost identified by 'redhat';
  MariaDB [(none)]> use legacy;
  MariaDB [(none)]> source /root/mariadb.dump;
```
