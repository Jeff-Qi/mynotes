---
title: HTTP状态码
date: 2019-08-14 0:15：00
categories: Network
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [返回结果的HTTP 状态码](#返回结果的http-状态码)
  - [2XX 成功](#2xx-成功)
  - [3XX 重定向](#3xx-重定向)
  - [4XX 客户端错误](#4xx-客户端错误)
  - [5XX 服务器错误](#5xx-服务器错误)
<!-- TOC END -->
<!--more-->

# 返回结果的HTTP 状态码
- HTTP 状态码负责表示客户端HTTP 请求的返回结果、标记服务器端的处理是否正常、通知出现的错误等工作

## 2XX 成功
- 2XX 的响应结果表明请求被正常处理了
  1. 200 OK
    - 表示从客户端发来的请求在服务器端被正常处理
  2. 204 No Content
    - 代表服务器接收的请求已成功处理，但在返回的响应报文中不含实体的主体部分
  3. 206 Partial Content
    - 表示客户端进行了范围请求，而服务器成功执行了这部分的GET请求
    - 响应报文中包含由Content-Range 指定范围的实体内容

## 3XX 重定向
- 3XX 响应结果表明浏览器需要执行某些特殊的处理以正确处理请求
  1. 301 Moved Permanently（永久重定向）
    - 表示请求的资源已被分配了新的URI，以后应使用资源现在所指的URI
  2. 302 Found（零时重定向）
    - 表示请求的资源已被分配了新的URI，希望用户（本次）能使用新的URI 访问
  3. 303 See Other
    - 表示由于请求对应的资源存在着另一个URI，应使用GET方法定向获取请求的资源
    - 303 状态码明确表示客户端应当采用GET 方法获取资源
  4. 304 Not Modified
    - 表示客户端发送附带条件的请求时，服务器端允许请求访问资源，但未满足条件的情况
  5. 307 Temporary Redirect（临时重定向）
    - 该状态码与302 Found 有着相同的含义

## 4XX 客户端错误
- 4XX 的响应结果表明客户端是发生错误的原因所在
  1. 401 Bad Request
    - 表示请求报文中存在语法错误
  2. 401 Unauthorized
    - 该状态码表示发送的请求需要有通过HTTP认证
  3. 403 Forbidden
    - 表明对请求资源的访问被服务器拒绝了
  4. 404 Not Found
    - 标识服务器上无法找到请求的资源

## 5XX 服务器错误
- 5XX 的响应结果表明服务器本身发生错误
  1. 500 Internal Server Error
    - 服务器在执行时发生错误
  2. 503 Service Unavailable
    - 服务器暂时处于超负载或正在进行停机维护
