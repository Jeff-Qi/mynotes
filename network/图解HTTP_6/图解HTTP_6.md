---
title: HTTP响应首部与实体首部字段
date: 2019-11-21 9:22:00
tags: Other
categories: HTTP
---

### 响应首部字段
- 由服务器端向客户端返回响应报文中所使用的字段，用于补充响应的附加信息、服务器信息，以及对客户端的附加要求等信息

#### Accept-Ranges
- 告知客户端服务器是否能处理范围请求，以指定获取服务器端某个部分的资源
  1. 可处理范围请求时指定其为bytes
  2. 不能处理则指定其为none

#### Age
- 告知客户端，源服务器在多久前创建了响应
 1. 创建该响应的服务器是缓存服务器，Age 值是指缓存后的响应再次发起认证到认证完成的时间值

#### ETage
- 告知客户端实体标识。它是一种可将资源以字符串形式做唯一性标识的方式
  1. 当资源更新时，ETag 值也需要更新
  2. 强ETag 值和弱Tag 值
    - 强ETag：细微的变化都会改变其值
    - 弱ETag：只有资源发生了根本改变，产生差异时才会改变ETag 值。字段值最开始处附加W/

#### Location
- 将响应接收方引导至某个与请求URI 位置不同的资源

#### Proxy-Authenticate
- 把由代理服务器所要求的认证信息发送给客户端

#### Retry-After
- 告知客户端应该在多久之后再次发送请求

#### Server
- 告知客户端当前服务器上安装的HTTP 服务器应用程序的信息

#### Vary
- 代理服务器接收到带有Vary 首部字段指定获取资源的请求时，如果使用的Accept-Language字段的值相同，那么就直接从缓存返回响应。反之，则需要先从源服务器端获取资源后才能作为121响应返回

#### WWW-Authenticate
- 用于HTTP 访问认证
  1. 告知客户端适用于访问请求URI 所指定资源的认证方案（Basic 或是Digest）和带参数提示的质询（challenge）

### 实体首部字段
- 实体首部字段是包含在请求报文和响应报文中的实体部分所使用的首部，用于补充内容的更新时间等与实体相关的信息

#### Allow
- 通知客户端能够支持Request-URI 指定资源的所有HTTP 方法

#### Content-Encoding
- 告知客户端服务器对实体的主体部分选用的内容编码方式

#### Content-Language
- 告知客户端，实体主体使用的自然语言

#### Content-Length
- 实体主体部分的大小

#### Content-Location
- 给出与报文主体部分相对应的URI
  1. 当返回的页面内容与实际请求的对象不同时，首部字段Content-Location内会写明URI

#### Content-MD5
- 检查报文主体在传输过程中是否保持完整，以及确认传输到达

#### Content-Range
- 告知客户端作为响应返回的实体的哪个部分符合范围请求

#### Content-Type
- 说明了实体主体内对象的媒体类型

#### Expires
- 将资源失效的日期告知客户端

#### Last-Modified
- 指明资源最终修改的时间

### 为Cookie 服务的首部字段

#### Set-Cookie
- 当服务器准备开始管理客户端的状态时，会事先告知各种信息
  - 属性
    1. expires：指定浏览器可发送Cookie 的有效期
    2. path：用于限制指定Cookie 的发送范围的文件目录
    3. domain：通过Cookie 的domain 属性指定的域名可做到与结尾匹配一致
    4. secure：限制Web 页面仅在HTTPS 安全连接时，才可以发送Cookie
    5. HttpOnly：使JavaScript 脚本无法获得Cookie。防止XSS跨站脚本攻击对cookie的窃取

#### Cookie
- 告知服务器，当客户端想获得HTTP 状态管理支持时，就会在请求中包含从服务器接收到的Cookie
