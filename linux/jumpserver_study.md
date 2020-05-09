---
title: jumpserver基础学习
date: 2020-4-21 9:16:00
categories: Linux
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [jumpserver简介](#jumpserver简介)
- [jumpserver安装使用](#jumpserver安装使用)
- [参考文档](#参考文档)
<!-- TOC END -->
<!--more-->

# jumpserver简介
    1. JumpServer 是全球首款完全开源的堡垒机, 使用 GNU GPL v2.0 开源协议；
    2. 使用 Python / Django 进行开发, 遵循 Web 2.0 规范
    3. JumpServer 采纳分布式架构, 支持多机房跨区域部署, 中心节点提供 API, 各机房部署登录节点, 可横向扩展、无并发访问限制
    4. JumpServer 现已支持管理 SSH、 Telnet、 RDP、 VNC 协议资产
    5. jumpserver核心功能包括身份认证、账号管理、权限控制和安全审计
    6. 同时jumpserver还具有分布式、云存储等特点；有丰富便捷的可视化图形web界面

    - [jumpserver官网](https://www.jumpserver.org/)

# jumpserver安装使用
- jumpserver提供多种安装方式，直接安装或者通过docker安装（后续实验我们采用docker进行安装）

- 环境要求：
    1.  硬件配置: 2个CPU核心, 4G 内存, 50G 硬盘（最低）
    1.  操作系统: Linux 发行版 x86_64
    1.  Python = 3.6.x
    1.  Mysql Server ≥ 5.6
    1.  Mariadb Server ≥ 5.5.56
    1.  Redis


# 参考文档
- [jumpsever官方文档](https://jumpserver.readthedocs.io/zh/master/index.html)
