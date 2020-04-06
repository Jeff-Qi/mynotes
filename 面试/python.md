---
title: python问题
date: 2020-03-20 20:00:00
categories: Python
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [python垃圾回收算法](#python垃圾回收算法)
- [python内存管理机制](#python内存管理机制)
- [python 为什么是假的多线程](#python-为什么是假的多线程)
- [讲讲 python 的数据类型](#讲讲-python-的数据类型)
- [面向对象和面向过程](#面向对象和面向过程)
- [赋值、浅拷贝、深拷贝不同](#赋值浅拷贝深拷贝不同)
- [解释python字符串驻留机制](#解释python字符串驻留机制)
- [可变对象与不可变对象](#可变对象与不可变对象)
- [join与 + 号的差异](#join与--号的差异)
- [new和init的区别](#new和init的区别)
- [粘包](#粘包)
- [同步与阻塞](#同步与阻塞)
- [self](#self)
<!-- TOC END -->
<!--more-->

# python垃圾回收算法
- 引用技术为主，分带回收为辅助；

# python内存管理机制

# python 为什么是假的多线程
- 因为 python 的解释器中有个 GIL 锁；在线程运行的的时候，GIL 锁会给当前线程加锁；运行 100 字节码后，GIL 会释放锁，跳去其他的线程加锁运行。所以导致了每次即使有很多线程在同时运行，但是实际上只有加了 GIL 锁的线程才会运行，所以每个进程中就只有一个线程在运行；但是python可以通过多进程来实现效率的提高，因为 GIL 锁只会加载线程上

# 讲讲 python 的数据类型
- 六类基本数据类型：数字、string、list、set、tuple、dict
- 三种不可变数据类型：数字、string、tuple
- 三种可变数据类型：list、set、dict
- type()不会认为子类是一种父类类型；isinstance()会认为子类是一种父类类型。

1.  数字
    - int、float、bool、complex
2.  字符串
    - Python中的字符串用单引号 ' 或双引号 " 括起来，同时使用反斜杠 \ 转义特殊字符。
3.  list[]
    - 列表可以完成大多数集合类的数据结构实现。列表中元素的类型可以不相同，它支持数字，字符串甚至可以包含列表（所谓嵌套）
    - 支持截取、索引
4.  Tuple()
    - 与列表类似但是无法被修改
    - 支持切片和索引
    - 空元祖和一个元素的元祖的构造
        ```python
        a = ()
        a = (1,)
        ```
5.  Set{}
    - 基本功能是进行成员关系测试和删除重复元素
    - 空集合只能使用 set() 构造
6.  dict｛｝
    - 键值对
    - 字典是无序的对象集合
    - 键(key)必须使用不可变类型

# 面向对象和面向过程
1.  面向过程就是分析出解决问题所需要的步骤，然后用函数把这些步骤一步一步实现，使用的时候一个一个依次调用就可以了；面向对象是把构成问题事务分解成各个对象，建立对象的目的不是为了完成一个步骤，而是为了描叙某个事物在整个解决问题的步骤中的行为。
2.  面向过程实现每一步的逻辑；面向对象抽离出对象然后组装
3.  优缺点
    1.  面向过程：性能高，不需要创建和销毁对象；缺点是不容易维护，扩展，复用
    2.  面向对象：容易维护，扩展和代码的复用，具有封装、多态、继承的优点；低耦合，更加灵活；性能不及面向过程优秀

# 赋值、浅拷贝、深拷贝不同
1.  赋值：变量存储不是值本身，而是值的内存地址，对于复杂的数据结构，如列表字典等，变量存储的是数据结构中每个值的存储地址
    ```py
    a = 1 # 赋值
    print(id(1))
    print(id(a))
    ```
2.  浅拷贝：copy.copy(obj)；它复制了对象，但是对象中的元素依然使用的是原始引用，所以只要原始引用不发生改变，原始引用对应的数值发生变化后，也会影响到浅拷贝后的对象
    ```py
    import copy
    a = [1, 2, 3, [4, 5, 6]]
    b = copy.copy(a)
    print(a)
    print(b)
    a[3][2] = 7
    print(a)
    print(b)
    ```
3.  深拷贝：copy.deepcopy(obj)；对对象深拷贝，深拷贝会完全复制原变量相关的所有数据，在内存中重新开辟一块空间，不管数据结构多么复杂，只要遇到可能发生改变的数据类型，就重新开辟一块内存空间把内容复制下来，直到最后一层，不再有复杂的数据类型，就保持其原引用。在这个过程中我们对这两个变量中的一个进行任意修改都不会影响其他变量。
    ```py
    import copy
    a = [1, 2, 3, [4, 5, 6]]
    b = copy.deepcopy(a)
    print(a)
    print(b)
    a[3][2] = 7
    print(a)
    print(b)
    ```

# 解释python字符串驻留机制
1.  对于短字符串，将其赋值给多个不同的对象时，内存中只有一个副本，多个对象共享该副本。这一点不适用于长字符串，即长字符串不遵守驻留机制，下面的代码演示了短字符串和长字符串在这方面的区别

# 可变对象与不可变对象
1.  可变对象在修改后，变量指向的地址不会发生改变，而不可变对象，在修改后会发生改变
2.  可变对象：list、set、dict
3.  不可变对象：int、tuple、string

# join与 + 号的差异
1.  join的性能优于 + 好，以为join在连接字符串的时候，会计算字符串的大小，然后一次性申请足够的内存，然后复制过去；而 + 号需要多个申请复制，相较而言更消耗时间

# new和init的区别
1.  new是真正的构造方法创建一个对象，而init是生成的对象的初始化

# 粘包
1.  当应用程序使用TCP协议发送数据时，由于TCP是基于流式的数据协议，会将数据像水流一样粘在一起，当接收方的数据容量小于发送的数据时，如果不指定接收的数据长度，就会将所有的数据混合在一起，让接收的数据发生混乱。
2.  解决方案：如果知道每次服务端发送的数据长度，按照长指定的长度取数据就不会出现这种情况，对于过长的数据可以循环去取
3.  struct模块：数据的传输可以像TCP的传输模式一样，定制一个固定长度的报头，在报头中指定数据的长度，和其它信息，这样在接收端就可以根据固定长度的报头解析出后面数据的长度信息等内容。该模块可以把数字转成固定长度的bytes；如果发送的数据过大，则采用迭代的思想，发送前先发送一个报文里面包含一个固定长度的信息，接收端就使用这个固定长度来接收数据
4.  代码

```py
import struct

res=struct.pack('i', 2147483647)
print(type(res),res,len(res))
res=struct.pack('i', 2)
print(type(res),res,len(res))

# 输出：
<class 'bytes'> b'\xff\xff\xff\x7f' 4
<class 'bytes'> b'\x02\x00\x00\x00' 4
# 可以看出，无论数据是'2147483647'还是'2'，最终都转化为了4个字节长
```

```py
# 服务端
import subprocess
import socket
import struct
import json

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# 在链接异常终止后，再次启动会复用之前的IP端口，防止资源没有释放而产生地址冲突
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

# 绑定的IP和端口
server.bind(('127.0.0.1', 8080))

# 参数5表示最大可以挂起的连接数
server.listen(5)

# 循环建立链接
while True:
    # 客户端的链接信息
    conn, client_addr = server.accept()  
    # 循环收发消息
    while True:  
        try:
            # 表示最大收取的消息
            client_data = conn.recv(1024)  

            # 将接收的命令交给shell执行，并将返回的错误输出和标准输出输出到管道
            res = subprocess.Popen(client_data.decode('utf-8'),
                                   shell=True,
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE)
            stdout = res.stdout.read()
            stderr = res.stderr.read()
            total_size = len(stdout) + len(stderr)
            # 自定义报头信息
            header = {'total_size': total_size, 'MD5': '123456', 'msg_type': 'cmd_res'}
            # 将字典转化为json格式后才能被反解
            header_json = json.dumps(header)
            # 将json转为bytes用于传输
            header_json_bytes = bytes(header_json, encoding='utf-8')
            # 将header_json_bytes打包为固定的4个字节长度
            header_size = struct.pack('i', len(header_json_bytes))
            # 如果收到的消息为空就跳出循环(主要针对在Linux系统上，客户端意外断开，Linux的服务端出现无穷循环收空包的情况)
            if not client_data: break
            # 发送头长度信息，为4个字节
            conn.send(header_size)
            # 发送头信息
            conn.send(header_json_bytes)  
            conn.send(stdout)
            conn.send(stderr)

            # 在 Windows系统上，客户端意外断开服务端会出现ConnectionResetError的异常
        except ConnectionResetError:  
            break
    conn.close()  # 关闭链接

server.close()


# 客户端

import socket
import struct
import json

client=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
client.connect(('127.0.0.1',8080))

while True:
    send_data=input(">>: ").strip()
    if not send_data: continue        # 禁止输入空，防止死锁
    client.send(send_data.encode('utf-8'))  # 发送的文件为bytes类型
    header_size=client.recv(4)
    header_json_lens=struct.unpack('i',header_size)[0]
    header_json_bytes=client.recv(header_json_lens)
    header_json=json.loads(header_json_bytes.decode('utf-8'))
    total_size=header_json['total_size']
    file_MD5=header_json['MD5']
    print(file_MD5)
    data_size=0
    server_data=b''
    while total_size > data_size:
        server_data+=client.recv(1024)
        data_size=len(server_data)

    print(server_data.decode('gbk'))   # 在windows上，系统命令的返回结果为GBK格式
client.close()
```

# 同步与阻塞
1.  同步与异步：同步和异步关注的是**消息通信机制**
    1.  同步，就是在发出一个调用时，在没有得到结果之前，该调用就不返回。但是一旦调用返回，就得到返回值了。换句话说，就是由调用者主动等待这个调用的结果。
    2.  异步，发起调用后，被调用的直接返回一个返回，但是没有结果，调用者不会继续等待这个结果；在被调用者完成调用后，会通过发送信号，或者回调函数处理这个调用
2.  阻塞与非阻塞：阻塞和非阻塞关注的是程序在等待调用结果（消息，返回值）时的**状态**
    1.  阻塞调用是指调用结果返回之前，当前线程会被挂起。调用线程只有在得到结果之后才会返回。
    2.  非阻塞调用指在不能立刻得到结果之前，该调用不会阻塞当前线程。

# self
1.  self是在为class编写instance method的时候，放在变量名第一个位子的占位词。
2.  在具体编写instance method里，可以不使用self这个变量。
3.  如果在method里面要改变instance的属性，可以用self.xxxx来指代这个属性进行修改。
