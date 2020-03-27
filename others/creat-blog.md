---
title: hexo+github快速搭建博客
date: 2019-10-09 19:52:01
categories: Others
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [hexo + Github 快速搭建博客（基于 centos 7）](#hexo--github-快速搭建博客基于-centos-7)
  - [流程](#流程)
    - [node.js 安装](#nodejs-安装)
    - [git 安装](#git-安装)
    - [hexo 安装](#hexo-安装)
    - [github 仓库建立](#github-仓库建立)
    - [hexo 与 github 的连接](#hexo-与-github-的连接)
    - [最后的最后](#最后的最后)
    - [访问博客](#访问博客)
- [借鉴](#借鉴)
<!-- TOC END -->

# hexo + Github 快速搭建博客（基于 centos 7）

## 流程
1. node.js 安装
2. git 安装
3. hexo 安装并设置
4. github 仓库建立和设置

### node.js 安装
1. node.js 官网下载二进制压缩包: https://nodejs.org/en/
```
[root@aliyun ~]# wget https://nodejs.org/dist/v10.16.3/node-v10.16.3-linux-x64.tar.xz
```
2. 解压二进制包
```
[root@aliyun ~]# tar -xvf node-v10.16.3-linux-x64.tar.xz
```
3. 添加 node.js 的环境变量
  1. 进入解压好的目录，然后进入 bin 目录
  ```
  [root@aliyun ~]# cd node-v10.16.3-linux-x64/bin
  ```
  2. 使用 pwd 获取 node.js 可执行文件路径
  ```
  [root@aliyun bin]# pwd
  /root/Softwares/node-v10.16.3-linux-x64/bin
  ```
  3. 将获取到的路径追加到环境变量配置文件最后
  ```
  [root@aliyun ~]# vim /etc/profile
  export PATH=$PATH:/root/Softwares/node-v10.16.3-linux-x64/bin
  ```
  4. 验证设置成功,出现版本号即配置成功
  ```
  [root@aliyun ~]# node -v
  v10.16.3
  ```

### git 安装
1.  git 安装: https://git-scm.com
```
[root@aliyun ~]# yum install -y git-core
```
2. 设置 git 的全局名称和邮箱
```
[root@aliyun ~]# git config --global user.name "your name"
[root@aliyun ~]# git config --global user.email "your email address"
```

### hexo 安装
1. hexo 安装: https://hexo.io
```
[root@aliyun ~]# npm install -g hexo-cli
```
2. hexo 初始化
```
[root@aliyun blog_file]# hexo init blog_file
```
3. 安装插件
```
[root@aliyun blog_file]# npm install hexo-deployer-git --save
```

### github 仓库建立
1. 新建一个仓库
2. 命名时需要注意，命名规则
```
例如：你的 github 账户名为 jeff
博客仓库名为： jeff.github.io  (如果用户名为 margin 则为 margin.gtihub.io)
```
3. 服务器端生成 ssh 密钥
```
[root@aliyun ~]# ssh-keygen -t rsa -C emailaddress  # -C 后的参数为你的 github 注册时的邮箱
# 如果提示覆盖则直接覆盖
```
4. 复制刚刚的密钥
```
[root@aliyun ~]# less ~/.ssh/id_rsa.pub
```
5. 在 github 上添加刚刚复制的 ssh 密钥: https://github.com/settings/ssh

### hexo 与 github 的连接
1. 修改 hexo 的配置文件（注意：配置文件在冒号后需要有一个空格不让会报错）

```
[root@aliyun ~]# cd blog_file
[root@aliyun blog_file]# vim _config.yml

# Hexo Configuration
## Docs: https://hexo.io/docs/configuration.html
## Source: https://github.com/hexojs/hexo/

# Site
title: JeffQi‘s Blog # 标题
subtitle: Nice to see you! # 浏览器显示的信息
description: good good study, day day up! # 博客描述
keywords:
author: JeffQi # 作者
language: zh-CN
timezone:

# URL
## If your site is put in a subdirectory, set url as 'http://yoursite.com/child' and root as '/child/'
url: http://yoursite.com/child
root: /
permalink: :year/:month/:day/:title/
permalink_defaults:

# Directory
source_dir: source
public_dir: public
tag_dir: tags
archive_dir: archives
category_dir: categories
code_dir: downloads/code
i18n_dir: :lang
skip_render:

# Writing
new_post_name: :title.md # File name of new posts
default_layout: post
titlecase: false # Transform title into titlecase
external_link: true # Open external links in new tab
filename_case: 0
render_drafts: false
post_asset_folder: true
relative_link: false
future: true
highlight:
  enable: true
  line_number: true
  auto_detect: false
  tab_replace:

# Home page setting
# path: Root path for your blogs index page. (default = '')
# per_page: Posts displayed per page. (0 = disable pagination)
# order_by: Posts order. (Order by date descending by default)
index_generator:
  path: ''
  per_page: 10
  order_by: -date

# Category & Tag
default_category: uncategorized
category_map:
tag_map:

# Date / Time format
## Hexo uses Moment.js to parse and display date
## You can customize the date format as defined in
## http://momentjs.com/docs/#/displaying/format/
date_format: YYYY-MM-DD
time_format: HH:mm:ss

# Pagination
## Set per_page to 0 to disable pagination
per_page: 10
pagination_dir: page

# Extensions
## Plugins: https://hexo.io/plugins/
## Themes: https://hexo.io/themes/
theme: Fan

# Deployment # 在这里设置你的 github 的连接
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type: git # 方式
  repo: https://github.com/Jeff-Qi/Jeff.github.io.git # 你的 github 仓库 URL
  banch: master
```

### 最后的最后
1. 编译静态资源，更新到 github

```
[root@aliyun ~]# cd blog_file
[root@aliyun blog_file]# hexo g
[root@aliyun blog_file]# hexo d
```

### 访问博客
1. 通过设置的 github 的仓库名就能访问了

```
jeff.github.io
```

# 借鉴

```
https://www.jianshu.com/p/0823e387c019
https://www.cnblogs.com/cutexin/p/11251940.html
https://godweiyang.com/2018/04/13/hexo-blog/#toc-heading-10
```
