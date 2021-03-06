---
title: HTTP请求首部字段
date: 2019-08-20 0:15：00
categories: Network
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [请求首部字段](#请求首部字段)
  - [Accept](#accept)
  - [Accept-Charset](#accept-charset)
  - [Accept-Encoding](#accept-encoding)
  - [Accept-Language](#accept-language)
  - [Authorization](#authorization)
  - [Proxy-Authorization](#proxy-authorization)
  - [Expect](#expect)
  - [From](#from)
  - [Host](#host)
  - [If-Match](#if-match)
  - [If-None_Match](#if-none_match)
  - [If-Modified-Since](#if-modified-since)
  - [If-Unmodified-Since](#if-unmodified-since)
  - [If-Range](#if-range)
  - [Max-Forwards](#max-forwards)
  - [Range](#range)
  - [Refere](#refere)
  - [TE](#te)
  - [User-Agent](#user-agent)
<!-- TOC END -->
<!--more-->

# 请求首部字段
- 从客户端往服务器端发送请求报文中所使用的字段，用于补充请求的附加信息、客户端信息、对响应内容相关的优先级等内容

## Accept
- 通知服务器，用户代理能够处理的媒体类型及媒体类型的相对优先级
 1. 使用type/subtype 这种形式，一次指定多种媒体类型
 2. 使用q= 来额外表示权重值权重值q 的范围是0~1（可精确到小数点后3 位），且1 为最大值
 3. 首先返回权重值最高的媒体类型

## Accept-Charset
- 通知服务器用户代理支持的字符集及字符集的相对优先顺序

## Accept-Encoding
- 告知服务器用户代理支持的内容编码及内容编码的优先级顺序
  1. 同accept一样，可有权重

## Accept-Language
- 告知服务器用户代理能够处理的自然语言集（指中文或英文等）
  1. 有权重

## Authorization
- 告知服务器，用户代理的认证信息（证书值）
  1. 客户端与服务器

## Proxy-Authorization
- 接收到从代理服务器发来的认证质询时，客户端会发送包含首部字段Proxy-Authorization的请求，以告知服务器认证所需要的信息
  1. 客户端与代理服务器

## Expect
- 告知服务器，期望出现的某种特定行为

## From
- 告知服务器，期望出现的某种特定行为

## Host
- 告知服务器，请求的资源所处的互联网主机名和端口号
  1. 唯一一个必须被包含在请求内的首部字段

## If-Match
- 服务器接收到附带条件的请求后，只有判断指定条件为真时，才会执行请求
  1. ETag：实体标记是与特定资源关联的确定值。资源更新变化后ETag随着改变
  2. 服务器会比对If-Match 的字段值和资源的ETag 值，仅当两者一致时，才会执行请求
  3. 可以使用星号(\*)指定If-Match 的字段值。针对这种情况，服务器将会忽略ETag 的值，只要资源存在就处理请求

## If-None_Match
- 资源不存在时返回响应，通常用来获取最新的资源

## If-Modified-Since
- 如果在If-Modified-Since 字段指定的日期时间后，资源发生了更新，服务器会接受请求

## If-Unmodified-Since
- 告知服务器，指定的请求资源只有在字段值内指定的日期时间之后，未发生更新的情况下，才能处理请求

## If-Range
- 告知服务器若指定的IfRange字段值（ETag 值或者时间）和请求资源的ETag 值或时间相一致时，则作为范围请求处理。反之，则返回全体资源

## Max-Forwards
- 以十进制整数形式指定可经过的服务器最大数目

## Range
- 只需获取部分资源的范围请求
 1. 处理请求后返回范围资源响应
 2. 无法处理时，返回全部资源响应

## Refere
- 告知服务器请求的原始资源的URI

## TE
- 告知服务器客户端能够处理响应的传输编码方式及相对优先级
  1. 用于传输编码
  2. 指定伴随trailer 字段的分块传输编码的方式
    - 需要将trailers赋值给该字段

## User-Agent
- 将创建请求的浏览器和用户代理名称等信息传达给服务器
