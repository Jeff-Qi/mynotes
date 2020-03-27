---
title: HTTP首部学习
date: 2019-08-16 0:15：00
categories: Network
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [HTTP首部](#http首部)
  - [HTTP报文首部](#http报文首部)
    - [请求报文](#请求报文)
    - [响应报文](#响应报文)
  - [HTTP首部字段](#http首部字段)
    - [4类HTTP首部字段类型](#4类http首部字段类型)
    - [非HTTP/1.1首部字段](#非http11首部字段)
  - [通用首部字段](#通用首部字段)
    - [Cache-control](#cache-control)
<!-- TOC END -->
<!--more-->

# HTTP首部

## HTTP报文首部
### 请求报文
1. 组成：方法、URI、HTTP 版本、HTTP 首部字段等

### 响应报文
1. 组成：HTTP 版本、状态码（数字和原因短语）、HTTP 首部字段

## HTTP首部字段
### 4类HTTP首部字段类型
1. 通用首部字段
2. 请求首部字段
3. 响应首部字段
4. 实体首部字段

### 非HTTP/1.1首部字段
1. 端到端首部（End-to-end Header）
  - 首部会转发给请求/ 响应对应的最终接收目标，且必须保存在由缓存生成的响应中，另外规定必须被转发
2. 逐跳首部（Hop-by-hop Header）
  - 首部只对单次转发有效，会因通过缓存或代理而不再转发
  - 使用hop-by-hop 首部，需提供Connection 首部字段

## 通用首部字段
### Cache-control
- 作用：通过指定首部字段Cache-Control 的指令，操作缓存的工作

- 缓存指令：
  1. public
    - 当指定使用public 指令时，则明确表明其他用户也可利用缓存
  2. private
    - 当指定private 指令后，响应只以特定的用户作为对象
  3. no-cache
    - 防止从缓存中返回过期的资源
      1. 客户端将不会接收缓存过的响应。需要将请求转发给源服务器
      2. 服务器返回响应包含no-cache指令，则缓存服务器不能对资源进行缓存
    - no-chche=location
      1. 字段被指定参数值则客户端不能缓存响应报文。无参数值的首部字段可以使用缓存。只能在响应指令中指定该参数
  4. no-store
    - 暗示请求（和对应的响应）或响应中包含机密信息
    - no-cache 代表不缓存过期的资源，缓存会向源服务器进行有效期确认后处理资源；no-store才是不进行缓存
    - 该指令规定缓存不能在本地存储请求或响应的任一部分
  5. s-maxage和max-age
    - 客户端：允许返回过期一定时间的缓存
    - 服务端：一定时间内缓存服务器自己处理缓存，不用向源服务器确认
    - 不同：smaxage指令只适用于供多位用户使用的公共缓存服务器
  6. min-fresh
    - 要求缓存服务器返回至少还未过指定时间的缓存资源。返回的资源较新
  7. max-stale
    - 过期的资源还能被接收
  8. only-if-cache
    - 客户端仅在缓存服务器本地缓存目标资源的情况下才会要求其返回；否则返回504 gateway timeout状态码
  9. must-revalidate
    - 必须再次确认返回的响应缓存的有效性
  10. proxy-revalidate
    - 缓存服务器在接收到客户端带有该指令的请求返回响应之前，必须再次验证缓存的有效性
  11. no-transform
    - 缓存都不能改变实体主体的媒体类型
  12. cache-control扩展
    - Cache-Control 首部字段本身没有community 这个指令。借助extension tokens 实现了该指令的添加
    - extension tokens 仅对能理解它的缓存服务器来说是有意义的

- Connection
  - 管理不在转发给代理的首部字段
  - 管理持久连接
    1. 指定Connection 首部字段的值为Keep-Alive

- Date
  - 报文创建时间

- Pragma
  - 客户端会要求所有的中间服务器不返回缓存的资源
  - 属于通用首部字段，但只用在客户端发送的请求中

- Trailer
  - 事先说明在报文主体后记录了哪些首部字段。该首部字段可应用在HTTP/1.1 版本分块传输编码时

- Transfer-Encoding
  - 定了传输报文主体时采用的编码方式
  - HTTP/1.1 的传输编码方式仅对分块传输编码有效

- Upgrand
  - 检测HTTP协议及其他协议是否可以使用更高的协议通信

- Via
  - 记录报文的传输路径

- Warning
 - 告知用户一些与缓存相关的问题警告
