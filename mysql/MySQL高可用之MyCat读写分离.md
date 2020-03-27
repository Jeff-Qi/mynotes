---
title: MySQL高可用之MyCat读写分离搭建
date: 2020-02-25 22:15:00
categories: MySQL
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [MyCat](#mycat)
  - [简介](#简介)
  - [安装使用](#安装使用)
  - [MyCat 配置文件](#mycat-配置文件)
    - [配置：](#配置)
    - [三大组件](#三大组件)
    - [实验配置](#实验配置)
<!-- TOC END -->
<!--more-->

# MyCat

## 简介
- mycat是一个数据库中间件，也可以理解为是数据库代理。在架构体系中是位于数据库和应用层之间的一个组件，并且对于应用层是透明的，即数据库感受不到mycat的存在，认为是直接连接的mysql数据库（实际上是连接的mycat,mycat实现了mysql的原生协议）
- mycat的三大功能：分表、读写分离、主从切换

## 安装使用
1.  下载安装 Java jdk
    - 网址：https://www.oracle.com/java/technologies/javase-jdk8-downloads.html
    - 解压，添加环境变量/etc/profile
        ```
        JAVA_HOME=/usr/local/java/jdk1.8.0_241
        CLASSPATH=$JAVA_HOME/lib/
        PATH=$PATH:$JAVA_HOME/bin
        export PATH JAVA_HOME CLASSPATH
        ```

2.  下载安装 MyCat
    - 网址：https://github.com/MyCATApache/Mycat-download
    - 解压，完成安装
    - 指令：
        ```
        linux：
        ./mycat start 启动
        ./mycat stop 停止
        ./mycat console 前台运行
        ./mycat install 添加到系统自动启动（暂未实现）
        ./mycat remove 取消随系统自动启动（暂未实现）
        ./mycat restart 重启服务
        ./mycat pause 暂停
        ./mycat status 查看启动状态
        ```
    - 测试连接---Mycat连接测试：测试mycat与测试mysql完全一致

## MyCat 配置文件

### 配置：
```
--bin 启动目录
--conf 配置文件存放配置文件：
  --server.xml：是Mycat服务器参数调整和用户授权的配置文件。
  --schema.xml：是逻辑库定义和表以及分片定义的配置文件。
  --rule.xml：  是分片规则的配置文件，分片规则的具体一些参数信息单独存放为文件，也在这个目录下，配置文件修改需要重启MyCAT。
  --log4j.xml： 日志存放在logs/log中，每天一个文件，日志的配置是在conf/log4j.xml中，根据自己的需要可以调整输出级别为debug；debug级别下，会输出更多的信息，方便排查问题。
  --autopartition-long.txt,partition-hash-int.txt,sequence_conf.properties， sequence_db_conf.properties 分片相关的id分片规则配置文件
  --lib	    MyCAT自身的jar包或依赖的jar包的存放目录。
  --logs        MyCAT日志的存放目录。日志存放在logs/log中，每天一个文件
```

### 三大组件
1.  server.xml
    - 添加两个mycat逻辑库：user,pay: system 参数是所有的mycat参数配置，比如添加解析器：defaultSqlParser，其他类推 user 是用户参数。
      ```xml
      <system>
      	<property name="defaultSqlParser">druidparser</property>
      </system>
      <user name="mycat">
      	<property name="password">mycat</property>
      	<property name="schemas">user,pay</property>
      </user>
      ```
2.  schema.xml
    - 修改dataHost和schema对应的连接信息，user,pay 垂直切分后的配置如下所示：schema 是实际逻辑库的配置，user，pay分别对应两个逻辑库，多个schema代表多个逻辑库。dataNode是逻辑库对应的分片，如果配置多个分片只需要多个dataNode即可。dataHost是实际的物理库配置地址，可以配置多主主从等其他配置，多个dataHost代表分片对应的物理库地址，下面的writeHost、readHost代表该分片是否配置多写，主从，读写分离等高级特性。以下例子配置了两个writeHost为主从。
        ```xml
        <schema name="user" checkSQLschema="false" sqlMaxLimit="100" dataNode="user" />
        <schema name="pay"  checkSQLschema="false" sqlMaxLimit="100" dataNode="pay" >
           <table name="order" dataNode="pay1,pay2" rule="rule1"/>
        </schema>

        <dataNode name="user" dataHost="host" database="user" />
        <dataNode name="pay1" dataHost="host" database="pay1" />
        <dataNode name="pay2" dataHost="host" database="pay2" />

        <dataHost name="host" maxCon="1000" minCon="10" balance="0"
           writeType="0" dbType="mysql" dbDriver="native">
           <heartbeat>select 1</heartbeat>
           <!-- can have multi write hosts -->
           <writeHost host="hostM1" url="192.168.0.2:3306" user="root" password="root" />
           <writeHost host="hostM2" url="192.168.0.3:3306" user="root" password="root" />
        </dataHost>
        ```
3.  rule.xml
    - 该规则配置了order表的数据切分方式，及数据切分字段。
      ```xml
      <mycat:rule xmlns:mycat="http://org.opencloudb/">
        <tableRule name="rule1">
          <rule>
             <columns>user_id</columns>
             <algorithm>func1</algorithm>
          </rule>
        </tableRule>
        <function name="func1" class="org.opencloudb.route.function.PartitionByLong">
           <property name="partitionCount">2</property>
           <property name="partitionLength">512</property>
        </function>
      </mycat:rule>
      ```

### 实验配置
- server.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mycat:server SYSTEM "server.dtd">
<mycat:server xmlns:mycat="http://io.mycat/">
	<user name="root">
		<property name="password">456789</property>
		<property name="schemas">TESTDB</property>
	</user>
</mycat:server>
```

- schema.xml
```xml
<?xml version="1.0"?>
<!DOCTYPE mycat:schema SYSTEM "schema.dtd">
<mycat:schema xmlns:mycat="http://io.mycat/">
	<schema name="TESTDB" checkSQLschema="false" sqlMaxLimit="100" dataNode="dn1">
	</schema>
	<dataNode name="dn1" dataHost="localhost1" database="mycat_test" />
	<dataHost name="localhost1" maxCon="1000" minCon="10" balance="3"
			  writeType="0" dbType="mysql" dbDriver="native" switchType="1"  slaveThreshold="100">
		<heartbeat>select user()</heartbeat>
		<writeHost host="hostM1" url="192.168.80.130:3306" user="mycat"
				   password="Hjqme525+">
			<readHost host="hostS2" url="192.168.80.131:3306" user="mycat" password="Hjqme525+" />
			<readHost host="hostS3" url="192.168.80.129:3306" user="mycat" password="Hjqme525+" />
		</writeHost>
	</dataHost>
</mycat:schema>
```
