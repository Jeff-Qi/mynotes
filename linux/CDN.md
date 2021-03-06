---
title: 初始CDN
date: 2020-03-22 22:07:00
categories: Linux
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [CDN](#cdn)
- [CDN是个what？](#cdn是个what)
  - [CDN工作流程](#cdn工作流程)
- [CDN相关技术](#cdn相关技术)
  - [负载均衡技术](#负载均衡技术)
  - [动态内容分发与复制技术](#动态内容分发与复制技术)
  - [缓存技术](#缓存技术)
- [CDN的应用场景](#cdn的应用场景)
- [CDN的不足](#cdn的不足)
- [参考文档](#参考文档)
<!-- TOC END -->
<!--more-->

# CDN
- 随着互联网的发展，用户在使用网络时对网站的浏览速度和效果愈加重视，但由于网民数量激增，网络访问路径过长，从而使用户的访问质量受到严重影响。特别是当用户与网站之间的链路被突发的大流量数据拥塞时，对于异地互联网用户急速增加的地区来说，访问质量不良更是一个急待解决的问题。**如何才能让各地的用户都能够进行高质量的访问，并尽量减少由此而产生的费用和网站管理压力呢？**

- 今天的角儿登场了：CDN（Content Delivery Network）内容发布网络变应运而生。

# CDN是个what？
- CDN的全称是Content Delivery Network，即内容分发网络。其目的是通过在现有的Internet中增加一层新的网络架构，将网站的内容发布到最接近用户的网络“边缘”，使用户可 以就近取得所需的内容，提高用户访问网站的响应速度。

![cdn_zone_servers](http://study.jeffqi.cn/linux/cdn_zone_servers.jpg)

- 解决由于网络带宽小、用户访问量大、网点分布不均等问题，提高用户访 问网站的响应速度

## CDN工作流程
1.  用户访问加入CDN服务的网站时，首先通过DNS重定向技术，找到距离用户最近的CDN节点，同时是用户指向该节点；
2.  当用户的请求到达该节点的时候，CDN的服务器（节点上的高速缓存）负责将用户请求的内容提供给用户；
3. ## 具体流程：
    用户在自己的浏览器中输入要访问的网站的域名，浏览器向本地DNS请求对该域名的解析，本地DNS将请求发到网站的主DNS，主DNS根据一系列的策略确 定当时最适当的CDN节点，并将解析的结果（IP地址）发给用户，用户向给定的CDN节点请求相应网站的内容。

# CDN相关技术
- CDN的实现需要依赖多种网络技术的支持，其中**负载均衡技术、动态内容分发与复制技术、缓存技术**是比较主要的几个

## 负载均衡技术
- 网络中的负载均衡就是将流量尽可能的分配到不同的线路节点上，以此来减轻某些节点的负载，提高网络流量，同时提升网络服务质量

- 在 CDN中，负载均衡又分为**服务器负载均衡**和**服务器整体负载均衡**(也有的称为服务器全局负载均衡)

- **服务器负载均衡**：是指能够在性能不同的服务器之间进行任务分配，既能保证性能差的服务器不成为系统的瓶颈，又能保证性能高的服务器的资源得到充分利用

- **服务器整体负载均衡**：是指允许Web网络托管商、门户站点和企业 根据地理位置分配内容和服务；**通过使用多站点内容和服务来提高容错性和可用性，防止因本地网或区域网络中断、断电或自然灾害而导致的故障**。在CDN的方案中服务器整体负载均衡将发挥重要作用，其性能高低将直接影响整个CDN的性能。

## 动态内容分发与复制技术
- 网站访问服务质量的好坏取决于多方面因素，包括网络带宽、服务器性能、网络状况是否良好等等。一般来说，主要是服务器与客户的距离会影响网站服务质量。距离过远就会导致，路由器的转发带来的网路延迟。

- 一个有效的方法就是利用内容分发与复制技术，**将占网站主体的大部分静态网页、图像和流媒体数据分发复制到各地的加速节点上**。用户访问时就能够直接从加速节点直接获取，而不需要再从远端的服务器上拉去，加速网络的访问质量

## 缓存技术
- Web缓存服务通过几种方式来改善用户的响应时间，如**代理缓存服务、透明代理缓存服务、使用重定向服务的透明代理缓存服务**等。通过Web缓存服务，用户访问网页时可以将广域网的流量降至最低，直接走最近的缓存服务器；用户直接访问服务商的缓存内容就可以了，而无需访问真是的服务器

# CDN的应用场景
- CDN的核心作用是**提高网络的访问速度**，那么其用户也就是**访问量很大的网站**，例如ICP 、ISP、大型企业、电子商务网站和政府网站等

- 使用CDN是公司或者其他部门不再需要投资昂贵的服务器和流量的问题。而只关心内容的更新。这样可以保证用户能够去做自己的新业务，同时也能保证其业务的质量。

# CDN的不足
- CDN也有自己的天然的缺点那就是————实时性；由于需要远距离保持同步所以还是会存在延迟

- **解决方案**：在网络 内容发生变化时将新的网络内容从服务器端直接传送到缓存器，或者当对网络内容的访问增加时将数据源服务器的网络内容尽可能实时地复制到缓存服务器.

# 参考文档
- [搞定CDN](https://www.cnblogs.com/seanxyh/archive/2013/04/16/3023499.html)
