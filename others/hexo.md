---
title: hexo博客next主体配置
date: 2020-02-23 23:31
categories: Others
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [添加搜索功能](#添加搜索功能)
- [添加点击阅读原文按键](#添加点击阅读原文按键)
- [hexo后台运行](#hexo后台运行)
<!-- TOC END -->
# 添加搜索功能
- 在博客根目录下安装：
    ```sh
    npm install hexo-generator-searchdb --save
    ```

- 修改主配置文件：
    ```sh
    vim _config.yml
    # search
    path: search.xml
    field: post
    format: html
    limit: 10000
    ```

- 修改主题配置文件
    ```sh
    vim _config.yml

    local_search:
      enable: true
    ```

- 重新编译安装即可

# 添加点击阅读原文按键
- 修改主题配置文件
    ```sh
    auto_excerpt:
      enable: true
      length: 200
    ```

- 重新编译安装即可

# hexo后台运行
- 安装pm2
    ```sh
    npm install -g pm2
    ```

- 博客根目录下编写run.js脚本
    ```js
    //run.js
    const { exec } = require('child_process')
    exec('hexo server',(error, stdout, stderr) => {
      if(error){
        console.log(`exec error: ${error}`)
        return
      }
      console.log(`stdout: ${stdout}`);
      console.log(`stderr: ${stderr}`);
    })
    ```

- 运行run.js脚本
    ```sh
    pm2 start /path/to/run.js
    ```
