---
title: 替换PIP国内下载源
date: 2020-03-27 10:05:00
categories: Python
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [pipy国内镜像](#pipy国内镜像)
- [临时替换](#临时替换)
- [永久替换](#永久替换)
<!-- TOC END -->
<!--more-->
# pipy国内镜像
```
http://pypi.douban.com/ 豆瓣
http://pypi.hustunique.com/ 华中理工大学
http://pypi.sdutlinux.org/ 山东理工大学
http://pypi.mirrors.ustc.edu.cn/ 中国科学技术大学
http://mirrors.aliyun.com/pypi/simple/ 阿里云
https://pypi.tuna.tsinghua.edu.cn/simple/ 清华大学。
```

# 临时替换
- 使用 -i 参数添加临时下载源
    ```sh
    pip install package -i source_url
    ```

# 永久替换
- 修改配置文件

- ## linux主机
    创建 ~/.pip/pip.conf 文件
    ```
    vim ~/.pip/pip.conf
    [global]
    index-url = source_url   (https://pypi.tuna.tsinghua.edu.cn/simple（清华源）)
    ```

- ## windows主机
    user目录中创建一个pip目录，如：C:\Users\xx\pip，新建文件pip.ini
    %appdata%搜索
    ```
    [global]
    index-url = source_url   (https://pypi.tuna.tsinghua.edu.cn/simple（清华源）)
    trusted-host = pypi.tuna.tsinghua.edu.cn
    ```
