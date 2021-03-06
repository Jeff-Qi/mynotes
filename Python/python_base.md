---
title: Python基础
date: 2020-03-20 0:15
categories: Python
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [文件操作](#文件操作)
- [函数](#函数)
- [命名空间和作用域](#命名空间和作用域)
- [函数](#函数-1)
- [装饰器](#装饰器)
- [迭代器生成器](#迭代器生成器)
- [推导式](#推导式)
- [内置函数和匿名函数](#内置函数和匿名函数)
- [模块和包](#模块和包)
- [常用的模块](#常用的模块)
  - [json模块](#json模块)
  - [pickle模块](#pickle模块)
  - [hashlib模块](#hashlib模块)
  - [logging模块](#logging模块)
  - [collections模块](#collections模块)
  - [时间模块](#时间模块)
  - [random模块](#random模块)
  - [os模块](#os模块)
  - [sys模块](#sys模块)
  - [re正则模块](#re正则模块)
- [异常处理](#异常处理)
- [面向对象编程](#面向对象编程)
- [类空间问题以及类之间的关系](#类空间问题以及类之间的关系)
- [继承](#继承)
- [面向对象编程特性：继承，封装，多态](#面向对象编程特性继承封装多态)
- [类的成员](#类的成员)
- [对象反射](#对象反射)
- [序列化](#序列化)
<!-- TOC END -->
<!--more-->

# 文件操作
1.  打开一个文件包含两部分资源：操作系统级打开的文件+应用程序的变量。在操作完毕一个文件时，必须把与该文件的这两部分资源一个不落地回收
    ```py
    #1. 打开文件，得到文件句柄并赋值给一个变量
    f=open('a.txt','r',encoding='utf-8') #默认打开模式就为r
    #2. 通过句柄对文件进行操作
    data=f.read()
    #3. 关闭文件
    f.close()
    ```
    ```py
    with open('a.txt','r',encoding='utf-8') as read_f,open('b.txt','w') as write_f:
      data=read_f.read()
      write_f.write(data)
    ```
2.  文件打开模式和编码

字符 | 模式
---|---
r | 只读模式【默认模式，文件必须存在，不存在则抛出异常】
w | 只写模式【不可读；不存在则创建；存在则清空内容】
a	| 只追加写模式【不可读；不存在则创建；存在则只追加内容】
\*b | r、w、a + b 使用二进制方式打开
r+ | 读写【可读，可写】覆盖写
w+ | 写读【可写，可读】覆盖写
a+ | 写读【可写，可读】追加写
r+b	| 读写【可读，可写】
w+b	| 写读【可写，可读】
a+b	| 写读【可写，可读】

3.  文件输入与输出
    1.  输出
        ```py
        f.read(size)：读多少字节，默认为一次性读完
        f.readline()：读一行，默认为‘\n’符号
        f.readlines()：读所有行，符号为 \n
        ```
    2.  输入
        ```py
        f.write('xxxx')：写入
        ```
    3.  f.tell()：返回当前文件指正
    4.  f.seek()：如果要改变文件当前的位置, 可以使用 f.seek(offset, from_what) 函数。from_what 的值, 如果是 0 表示开头, 如果是 1 表示当前位置, 2 表示文件的结尾
        ```py
        seek(x,0) ： 从起始位置即文件首行首字符开始移动 x 个字符
        seek(x,1) ： 表示从当前位置往后移动x个字符
        seek(-x,2)：表示从文件的结尾往前移动x个字符
        ```

# 函数
1.  return关键字的作用
    1.  return 是一个关键字，这个词翻译过来就是“返回”，所以我们管写在return后面的值叫“返回值”。
    2.  不写return的情况下，会默认返回一个None
    3.  一旦遇到return，结束整个函数。
    4.  返回的多个值会被组织成元组被返回，也可以用多个值来接收
2.  函数的参数
    1.  按照位置传值：位置参数
        ```py
        def fname(x, y):
          pass   
        ##
        fname(1, 2)       
        ```
    2.  关键字参数：在调用函数时，按照key=value的形式定义的实参，称为关键字参数
        ```py
        def fun(x, y):
          pass
        ###
        fun(x=1,y=2)
        ```
    3.  位置、关键字形式混着用：混合传参；结合上面两种
        1.  **位置参数必须在关键字参数的前面
        对于一个形参只能赋值一次**
    4.  默认参数:**默认参数是一个可变数据类型**
        ```py
        def fname(x=1):
          pass
        ##
        fname()
        ```
    5.  动态参数：动态参数，也叫不定长传参，就是你需要传给函数的参数很多，**不定个数**，那这种情况下，你就用*args，\**kwargs接收，**args是元祖形式**，接收除去键值对以外的所有参数，**kwargs接收的只是键值对的参数**，并保存在字典中
        ```py
        def fname(*arg, **kwargs):
          pass
        ##
        fname('aaron',1,3,[1,3,2,2],{'a':123,'b':321},country='china')
        ```
    6.  形参、实参：
        1.  形参：定义函数时的参数
        2.  实参：调用函数时的参数
        3.  根据实际参数类型不同，将实际参数传递给形参的方式有两种：值传递和引用传递
            1.  值传递：实参为不可变对象，传递给形参后，形参的值改变，实参值不变。如fun（a），传递的只是a的值，没有影响a对象本身。比如在 fun（a）内部修改 a 的值，只是修改另一个复制的对象，不会影响 a 本身。
            2.  引用传递：实参为可变对象，传递给形参后，形参的值改变，实参值改变。如 fun（la），则是将 la 真正的传过去，修改后fun外部的la也会受影响
    7.  形式参数前加 * 号表示可变长参数，实参前加 * 号表示解包，将list或者tuple内的元素提取出来
        ```py
        def fun(a, *args):
          print('a:%s' % a)
          print('args:', end=' ')
          for i in args:
              print(i, end=' ')
        li = [1, 2, 3, 4]
        fun(*li)
        ##
        a:1
        args: 2 3 4
        ```

# 命名空间和作用域
1.  创建的存储“变量名与值的关系”的空间叫做全局命名空间；在函数的运行中开辟的临时的空间叫做局部命名空间
2.  类型：
    1.  全局
    2.  局部
    3.  内置
3.  调用顺序
    1.  局部调用：局部>全局>内置
    2.  全局调用：全局>内置
4.  作用域
    1.  全局作用域：包含内置名称空间、全局名称空间，在整个文件的任意位置都能被引用、全局有效
    2.  局部作用域：局部名称空间，只能在局部范围内生效
5.  globals和locals方法
    1.  global
        1.  声明一个全局变量。
        2.  在局部作用域想要对全局作用域的全局变量进行修改时，需要用到 global(限于字符串，数字)。可变数据类型可以直接引用
        ```py
        def func():
          global a
          a = 3
        ##
        func()
        print(a)
        ##
        count = 1
        def search():
            global count
            count = 2
        ##
        search()
        print(count)
        ```
    2.  local
        1.  不能修改全局变量
        2.  在局部作用域中，对父级作用域（或者更外层作用域非全局作用域）的变量进行引用和修改，并且引用的哪层，从那层及以下此变量全部发生改变
        ```py
        def add_b():
            b = 1
            def do_global():
                b = 10
                print(b)
                def dd_nolocal():
                    nonlocal b # 父级改变
                    b = b + 20
                    print(b)
                dd_nolocal()
                print(b)
            do_global()
            print(b)
        add_b()
        ```

# 函数
1.  函数名本质上就是函数的内存地址；可以被引用；可以当做容器元素存在如list中；可以作为返回值
2.  闭包：内层函数对于外层函数定义的变量的调用
    ```py
    def out():
      name = 'hjq'
      def inner():
        print(name)
      print(inner.__closure__)
      return inner
    ```

# 装饰器
1.  让其他函数在不需要做任何代码变动的前提下，增加额外的功能，装饰器的返回值也是一个函数对象。装饰器的应用场景：比如插入日志，性能测试，事务处理，缓存等等场景
2.  函数可以作为参数传递给另一个函数，但是使用比较麻烦；使用装饰器更加简便
    ```py
    def timer(func):
        def inner():
            start = time.time()
            func()
            print(time.time() - start)
        return inner
    ##
    @timer
    def func1():
        time.sleep(1)
        print('in func1')
    ##
    func1()
    ```
3.  加上装饰器后函数的信息就失效了，可以使用 @wrap(fun_name) 装饰器保留原函数的信息
    ```py
    def deco(func):
        @wraps(func)
        def wrapper(*args,**kwargs):
            return func(*args,**kwargs)
        return wrapper
    ```
4.  **开放封闭原则**
    1.  开放封闭原则的核心的思想是软件实体是可扩展，而不可修改的。
        1.  对扩展是开放的
        2.  对修改是封闭的
5.  多个装饰器
    ```py
    def wrapper1(func):
        def inner():
            print('第一个装饰器，在程序运行之前')
            func()
            print('第一个装饰器，在程序运行之后')
        return inner
    ##
    def wrapper2(func):
        def inner():
            print('第二个装饰器，在程序运行之前')
            func()
            print('第二个装饰器，在程序运行之后')
        return inner
    ##
    @wrapper1
    @wrapper2
    def f():
        print('Hello')
    ##
    f()
    ## 结果
    第一个装饰器，在程序运行之前
    第二个装饰器，在程序运行之前
    Hello
    第二个装饰器，在程序运行之后
    第一个装饰器，在程序运行之后
    ```

# 迭代器生成器
1.  可迭代对象：可以使用for循环遍历的对象
2.  可迭代协议：可以被迭代要满足的要求就叫做可迭代协议。可迭代协议的定义非常简单，就是内部实现了iter方法来返回一个迭代器对象
3.  迭代器：内部实现了iter方法和next方法；迭代器惰性计算，同一时刻在内存中只出现一条数据，极大限度的节省了内存；只有在需要时才会生成
4.  for循环遍历可迭代对象
    1.  将可迭代对象转化成迭代器。（可迭代对象.iter()）
    2.  内部使用next方法，一个一个取值。
    3.  加了异常处理功能，取值到底后自动停止。
5.  生成器：常规函数定义，但是，使用yield语句而不是return语句返回结果。yield语句一次返回一个结果，在每个结果中间，挂起函数的状态，以便下次重它离开的地方继续执行
6.  生成器协议：类似于列表推导，但是，生成器返回按需产生结果的一个对象，而不是一次构建一个结果列表

# 推导式
```py
{k.lower():dic1.get(k.lower(),0) + dic1.get(k.upper(),0) for k in dic1.keys()}
```

# 内置函数和匿名函数
1.  作用域相关
    - locals():函数会以字典的类型返回当前位置的全部局部变量
    - globals():：函数以字典的类型返回全部全局变量
2.  字符串类型代码的执行 eval，exec，complie
    - eval：执行字符串代码返回结果；只能执行一行代码
        ```py
        ret = eval('2 + 2')
        print(ret)
        ```

    - exec：执行字符串代码；可以执行多行代码，但是拿不到结果
        ```py
        s = '''
        for i in range(5):
            print(i)
        '''
        exec(s)
        ```

    - complie：:将字符串类型的代码编译。代码对象能够通过exec语句来执行或者eval()进行求值
        1.  数source：字符串。即需要动态执行的代码段。
        2.  参数 filename：代码文件名称，如果不是从文件读取代码则传递一些可辨认的值。当传入了source参数时，filename参数传入空字符即可。
        3.  参数model：指定编译代码的种类，可以指定为 ‘exec’,’eval’,’single’。**当source中包含流程语句时，model应指定为‘exec’；当source中只包含一个简单的求值表达式，model应指定为‘eval’；当source中包含了交互式命令语句，model应指定为’single’**
            ```py
            str = "for i in range(0,10): print(i)"
            c = compile(str,'','exec')
            exec(c)
            ```
3.  输入输出
    - input():函数接受一个标准输入数据，返回为 string 类型
    - print():标准输出
4.  内存相关
    - hash()：获取对象（可哈希对象：int，str，Bool，tuple）的hash值
    - id()：获取内存地址
5.  文件操作相关
    - open()：函数用于打开一个文件，创建一个 file 对象，相关的方法才可以调用它进行读写
6.  调用相关
    - callable：函数用于检查一个对象是否是可调用
        ```py
        def demo1(a, b):
            return a + b
        ##
        print(callable(demo1))
        ```
7.  内置属性
    - dir()：函数不带参数时，返回当前范围内的变量、方法和定义的类型列表；带参数时，返回参数的属性、方法列表。如果参数包含方法
8.  迭代器生成器相关
    - range：函数可创建一个整数对象，一般用在 for 循环中。
    - next：内部实际使用了__next__方法，返回迭代器的下一个项目
9.  基础数据类型
    - bool ：用于将给定参数转换为布尔类型，如果没有参数，返回 False。
    - int：函数用于将一个字符串或数字转换为整型。
    - float：函数用于将整数和字符串转换成浮点数。
    - complex：函数用于创建一个值为 real + imag * j 的复数或者转化一个字符串或数为复数。如果第一个参数为字符串，则不需要指定第二个参数。。
10. 进制转换
    - bin：将十进制转换成二进制并返回。
    - oct：将十进制转化成八进制字符串并返回。
    - hex：将十进制转化成十六进制字符串并返回。
11. 数学运算
    - abs：函数返回数字的绝对值。
    - divmod：计算除数与被除数的结果，返回一个包含商和余数的元组(a // b, a % b)。
    - round：保留浮点数的小数位数，默认保留整数。
    - pow：函数是计算x的y次方，如果z在存在，则再对结果进行取模，其结果等效于pow(x,y) %z）
    - sum：对可迭代对象进行求和计算（可设置初始值）。
    - min：返回可迭代对象的最小值（可加key，key为函数名，通过函数的规则，返回最小值）。
    - max：返回可迭代对象的最大值（可加key，key为函数名，通过函数的规则，返回最大值）
12. 数据结构
    - list()：将一个可迭代对象转化成列表（如果是字典，默认将key作为列表的元素）。
    - tuple()：将一个可迭代对象转化成元祖（如果是字典，默认将key作为元祖的元素）。
    - dict()：创建一个字典。
    - set()：创建一个集合。
    - frozenset()：返回一个冻结的集合，冻结后集合不能再添加或删除任何元素。
13. 内置函数
    - reversed()：翻转一个列表生成**迭代器**
    - str()：将数据转化成字符串。
    - bytes():用于不同编码之间转换
        ```py
        s = '你好'
        bs = s.encode('utf-8')
        print(bs)
        s1 = bs.decode('utf-8')
        print(s1)
        bs = bytes(s, encoding='utf-8')
        print(bs)
        b = '你好'.encode('gbk')
        b1 = b.decode('gbk')
        print(b1.encode('utf-8'))
        ```
    - len():返回一个对象中元素的个数。
    - sorted()：对所有可迭代的对象进行排序操作
        ```py
        print(sorted(l, key=lambda x:x[1], reverse=True)) # 降序
        ```
    - filter()：用于过滤序列，过滤掉不符合条件的元素，返回由符合条件元素组成的新列表。
        ```py
        def func(x): return x%2 == 0
        ret = filter(func,[1,2,3,4,5,6,7,8,9,10])
        print(ret)
        for i in ret:
            print(i)
        ```
14. 匿名函数
    - 为了解决那些功能很简单的需求而设计的一句话函数
    - 函数名 = lambda 参数 ：返回值
        1.  参数可以有多个，用逗号隔开
        2.  匿名函数不管逻辑多复杂，只能写一行，且逻辑执行结束后的内容就是返回值
        3.  返回值和正常的函数一样可以是任意数据类型
        ```py
        l=[3,2,100,999,213,1111,31121,333]
        print(max(l))
        dic={'k1':10,'k2':100,'k3':30}
        print(max(dic))
        print(dic[max(dic,key=lambda k:dic[k])])   
        ```

# 模块和包
1.  什么是模块
    - 使用python编写的代码（.py文件）
    - 已被编译为共享库或DLL的C或C++扩展
    - 包好一组模块的包
    - 使用C编写并链接到python解释器的内置模块
2.  为什么要使用模块
    1.  实现代码和功能的复用性
3.  import module_name
    - 模块可以包含可执行的语句和函数的定义，这些语句的目的是初始化模块，**它们只在模块名第一次遇到导入import语句时才执行**
    - 第一次导入后就将模块名加载到内存了，后续的import语句仅是对已经加载大内存中的模块对象增加了一次引用，不会重新执行模块内的语句
4.  import时做的事情
    1.  为模块创建新的命名空间
    2.  在新的命名空间中执行模块中的代码函数
    3.  **创建名字来引用这个命名空间**
5.  from import
    - from 语句相当于import，也会创建新的名称空间，**但是将my_module中的名字直接导入到当前的名称空间中**，在当前名称空间中，直接使用名字就可以了
    - from my_module import * 把**my_module中所有的不是以下划线(_)开头的名字都导入到当前位置**，这样做可能造成覆盖掉你之前的定义的名字
    - 想从包api中导入所有，实际上该语句只会导入包api下__init__.py文件中定义的名字，我们可以在这个文件中定义__all__
        ```py
        def func():
          print('from api.__init.py')
        __all__=['x','func','policy']
        ##
        from glance.api import *
        ```
6.  模块搜索路径
    1.  内存中已经加载的模块->内置模块->sys.path路径中包含的模块
7.  编译python文件
    - 为了提高加载模块的速度，python解释器会在__pycache__目录中下缓存每个模块编译后的版本
8.  绝对导入和相对导入
    1.  绝对导入
        1.  优点：执行文件与被导入的模块中都可以使用
        2.  缺点：比较麻烦写入路径名称
    2.  相对导入
        1.  优点：方便
        2.  缺点：只能在导入包中的模块时才能使用

# 常用的模块

## json模块
1.  Json模块提供了四个功能：dumps、dump、loads、load

参数 | 解释
---|---
ensure_ascii | 当它为True的时候，所有非ASCII码字符显示为\uXXXX序列，只需在dump时将ensure_ascii设置为False即可，此时存入json的中文即可正常显示。
separators | 分隔符，实际上是(item_separator, dict_separator)的一个元组，默认的就是(‘,’,’:’)；这表示dictionary内keys之间用“,”隔开，而KEY和value之间用“：”隔开。

```py
import json
##
data = {'name':'陈松','sex':'female','age':88}
json_dic2 = json.dumps(data,sort_keys=True,indent=2,separators=(',',':'),ensure_ascii=False)
print(json_dic2)
```

## pickle模块
1.  pickle模块提供了四个功能：dumps、dump(序列化，存）、loads（反序列化，读）、load
不仅可以序列化字典，列表…可以把python中任意的数据类型序列化

2.  区别

模块 | 区别
---|---
json | 用于字符串 和 python数据类型间进行转换
pickle | 用于python特有的类型 和 python的数据类型间进行转换

## hashlib模块
1.  Python的hashlib提供了常见的摘要算法，如MD5，SHA1等等。

```py
import hashlib
##
md5 = hashlib.md5()
md5.update('how to use md5 in python hashlib?'.encode('utf-8'))
# md5.update('how to use md5 in python hashlib?'.encode('utf-8')) # 多次调用
print(md5.hexdigest())
```

2.  如果数据大，可以分块多次调用update()，最后计算的结果是一样的

## logging模块
1.  日志等级
```py
import logging  
logging.debug('debug message')  
logging.info('info message')  
logging.warning('warning message')  # （默认）
logging.error('error message')  
logging.critical('critical message')
```

```py
import logging

logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
                    datefmt='%a, %d %b %Y %H:%M:%S',
                    filename='test.log',
                    filemode='w')
#
logging.debug('debug message')
logging.info('info message')
logging.warning('warning message')
logging.error('error message')
logging.critical('critical message')
```
2.  解释
    1.  logging.basicConfig()函数中可通过具体参数来更改logging模块默认行为，可用参数有：
    2.  filename：用指定的文件名创建FiledHandler，这样日志会被存储在指定的文件中。
    3.  filemode：文件打开方式，在指定了filename时使用这个参数，默认值为“a”还可指定为“w”。
    4.  format：指定handler使用的日志显示格式。
    5.  datefmt：指定日期时间格式。
    6.  level：设置rootlogger（后边会讲解具体概念）的日志级别
    7.  stream：用指定的stream创建StreamHandler。可以指定输出到sys.stderr,sys.stdout或者文件(f=open- (‘test.log’,’w’))，默认为sys.stderr。若同时列出了filename和stream两个参数，则stream参数会被忽略。
    8.  format参数中可能用到的格式化串：
        ```py
        %(name)s Logger的名字
        %(levelno)s 数字形式的日志级别
        %(levelname)s 文本形式的日志级别
        %(pathname)s 调用日志输出函数的模块的完整路径名，可能没有
        %(filename)s 调用日志输出函数的模块的文件名
        %(module)s 调用日志输出函数的模块名
        %(funcName)s 调用日志输出函数的函数名
        %(lineno)d 调用日志输出函数的语句所在的代码行
        %(created)f 当前时间，用UNIX标准的表示时间的浮 点数表示
        %(relativeCreated)d 输出日志信息时的，自Logger创建以 来的毫秒数
        %(asctime)s 字符串形式的当前时间。默认格式是 “2003-07-08 16:49:45,896”。逗号后面的是毫秒
        %(thread)d 线程ID。可能没有
        %(threadName)s 线程名。可能没有
        %(process)d 进程ID。可能没有
        %(message)s用户输出的消息
        ```

3.  logger对象设置
```py
import logging
#
logger = logging.getLogger()
# 创建一个handler，用于写入日志文件
fh = logging.FileHandler('test.log',encoding='utf-8')
#
# 再创建一个handler，用于输出到控制台
ch = logging.StreamHandler()
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
fh.setLevel(logging.DEBUG)
#
fh.setFormatter(formatter)
ch.setFormatter(formatter)
logger.addHandler(fh) #logger对象可以添加多个fh和ch对象
logger.addHandler(ch)
```

## collections模块
1.  在内置数据类型（dict、list、set、tuple）的基础上，collections模块还提供了几个额外的数据类型：Counter、deque、defaultdict、namedtuple和OrderedDict等
    1.  namedtuple: 生成可以使用名字来访问元素内容的tuple
    2.  deque: 双端队列，可以快速的从另外一侧追加和推出对象
    3.  Counter: 计数器，主要用来计数
    4.  OrderedDict: 有序字典
    5.  defaultdict: 带有默认值的字典
2.  namedtuple
    ```py
    from collections import namedtuple
    point = namedtuple('point',['x','y'])
    p = point(1,2)
    print(p.x)  
    ```
3.  deque
    ```py
    from collections import deque

    q = deque(['a','b','c'])
    q.append('x')
    q.appendleft('y')

    print(q)
    ```
4.  OrderedDict
    ```py
    from collections import OrderedDict

    d = dict([('a',1),('b',2),('c',3)])
    print(d)

    od = OrderedDict([('a',1),('b',2),('c',3)])
    print(od)
    ```
5.  defaultdict
    ```py
    from collections import defaultdict

    li = [11,22,33,44,55,77,88,99,90]
    result=defaultdict(list)

    for row in li:
        if row > 66:
            result['key1'].append(row)
        else:
            result['key2'].append(row)

    print(result)
    ```
6.  counter
    ```py
    from collections import Counter

    c = Counter('qazxswqazxswqazxswsxaqwsxaqws')
    print(c)
    ```

## 时间模块
1.  time.sleep(secs)：(线程)推迟指定的时间运行。单位为秒。
2.  time.time()：获取当前时间戳
3.  格式：时间戳、元祖、格式化显示

格式化 | 解释
---|---
%y | 两位数的年份表示（00-99）
%Y | 四位数的年份表示（000-9999）
%m | 月份（01-12）
%d |月内中的一天（0-31）
%H | 24小时制小时数（0-23）
%I | 12小时制小时数（01-12）
%M | 分钟数（00=59）
%S | 秒（00-59）

4.  时间转换
    ```py
    import time

    # 格式化时间 ---->  结构化时间
    ft = time.strftime('%Y/%m/%d %H:%M:%S')
    st = time.strptime(ft,'%Y/%m/%d %H:%M:%S')
    print(st)
    # 结构化时间 ---> 时间戳
    t = time.mktime(st)
    print(t)

    # 时间戳 ----> 结构化时间
    t = time.time()
    st = time.localtime(t)
    print(st)
    # 结构化时间 ---> 格式化时间
    ft = time.strftime('%Y/%m/%d %H:%M:%S',st)
    print(ft)
    ```

## random模块
1.  随机模块
    ```py
    random.randint(m, n)：m、n之间的随机数
    random.randrange(m, n, s)：m、n之间的随机数，步长s
    random.choice(argv)：从argv中随机选择其中的数据
    ```

## os模块
1.  os模块是与操作系统交互的一个接口
    ```py
    os.remove() 删除文件
    os.rename() 重命名文件
    os.listdir() 列出指定目录下所有文件
    os.chdir() 改变当前工作目录
    os.getcwd() 获取当前文件路径
    os.mkdir() 新建目录
    os.rmdir() 删除空目录(删除非空目录, 使用shutil.rmtree())
    os.makedirs() 创建多级目录
    os.removedirs() 删除多级目录
    os.wait() 暂时未知
    os.path模块：
    os.path.split(filename) 将文件路径和文件名分割(会将最后一个目录作为文件名而分离)
    os.path.dirname(filename) 返回文件路径的目录部分
    os.path.basename(filename) 返回文件路径的文件名部分
    ```

## sys模块
1.  sys模块是与python解释器交互的一个接口
    ```py
    sys.argv：命令行参数类似shell的参数
    sys.exit(n)：退出程序返回一个字节码
    sys.version：python解释器信息
    sys.path：模块搜索路径
    sys.platfrom：平台信息
    ```

## re正则模块
1.  re.match(pattern, string, flags=0)：re.match 尝试从字符串的起始位置匹配一个模式，如果不是起始位置匹配成功的话，match()就返回none。
2.  re.search(pattern, string, flags=0)：扫描整个字符串并返回第一个成功的匹配
3.  findall(string[, pos[, endpos]])：在字符串中找到正则表达式所匹配的所有子串，并返回一个列表，如果没有找到匹配的，则返回空列表；**match 和 search 是匹配一次 findall 匹配所有。**

# 异常处理
1.  为每一种异常定制了一个类型，然后提供了一种特定的语法结构用来进行异常处理
2.  基本语法
```py
try:
     被检测的代码块
except 异常类型：
     执行的操作
#try中一旦检测到异常，就执行这个位置的逻辑
## 多分支，通用异常，else方法，finally
try:
    int(s1)
except IndexError as e:
    print(e)
except KeyError as e:
    print(e)
except ValueError as e:
    print(e)
except Exception as e:  # 通用异常捕获
   print(e)
else:   # try 正常执行时，跳转到这个
    print('try内代码块没有异常则执行我')
finally:  # 无论如何都会运行
    print('无论异常与否,都会执行该模块,通常是进行清理工作')
## 主动抛出异常
try:
    raise TypeError('类型错误')
except Exception as e:
    print(e)
```
3.  异常操作的优点
    1.  把错误处理和真正的工作分开来
    2.  代码更易组织，更清晰，复杂的工作任务更容易实现
    3.  毫无疑问，更安全了，不至于由于一些小的疏忽而使程序意外崩溃了

# 面向对象编程
1.  面向对象编程的优点
    1.  少代码的重用性。
    2.  增强代码的可读性。
2.  构造
    ```py
    class ClassName(object):
      """docstring for ."""
      var = 'string'  # 静态变量，静态属性
      def __init__(self, arg):  # 方法、函数、动态属性
        super(, self).__init__()
        self.arg = arg
    ```
3.  创建对象
    1.  在内存中开辟了一个对象空间。
    2.  自动执行类中的init方法，并将这个对象空间（内存地址）传给了init方法的第一个位置参数self。
    3.  在init 方法中通过self给对象空间添加属性。
4.  操作和类中的属性：通过万能的点 . 进行操作；查看对象和类中的所有内容可以通过 **dic** 来查看
5.  类中的方法都会有一个self参数。因为一般情况下这些方法都是通过对象来执行的。在执行的时候将对象的地址空间传给第一个参数，这个self就是对象本省

# 类空间问题以及类之间的关系
1.  类和对象都可以在内外部添加
    ```py
    class A:
      def __init__(self, name):
        self.name = name
      def func(self, sex):
        self.sex = sex
    A.age = '12'  # 类内部
    A.func('男') # 类外部
    a = A('margin') # 对象
    a.age = '20'  # 对象内部
    a.func('女') # 对象外部
    ```
2.  如何找到属性
    1.  对象空间
        1.  产生这个对象空间，并有一个类对象指针
        2.  执行__init__方法，给对象封装属性
    2.  对象查找属性的顺序：先从对象空间找 ——> 类空间找 ——> 父类空间找 ——->…
    3.  类名查找属性的顺序：先从本类空间找 ——-> 父类空间找——–> …
3.  类之间关系
    1.  依赖关系
        1.  将大象装进冰箱，需要大象类和冰箱类相互依赖
    2.  关联关系、组合关系、聚合关系
        1.  关联关系. 两种事物必须是互相关联的. 但是在某些特殊情况下是**可以更改和更换的**
        2.  聚合关系. 属于关联关系中的⼀种特例. **侧重点是xxx和xxx聚合成xxx. 各⾃有各⾃的声明周期**. 比如电脑. 电脑⾥有CPU, 硬盘, 内存等等. 电脑挂了. CPU还是好的. 还是完整的个体
        3.  组合关系. 属于关联关系中的⼀种特例. 写法上差不多. **组合关系比聚合还要紧密**. 比如⼈的⼤脑, ⼼脏, 各个器官. 这些器官组合成⼀个⼈. 这时. ⼈如果挂了. 其他的东⻄也跟着挂了（**将一个类的对象封装到另一个类的对象的属性中，就叫组合**）
    3.  实现关系
    4.  继承关系(类的三大特性之一：继承。)

# 继承
1.  优点
    1.  增加了类的耦合性（耦合性不宜多，宜精）。
    2.  减少了重复代码。
    3.  使得代码更加规范化，合理化。
2.  python中类的类型
    1.  ⼀个叫经典类. 在python2.2之前. ⼀直使⽤的是经典类. 经典类在基类的根如果什么都不写.
    2.  ⼀个叫新式类. 在python2.2之后出现了新式类. 新式类的特点是基类的根是object类。
    3.  python3中使⽤的都是新式类. 如果基类谁都不继承. 那这个类会默认继承 object
3.  执行顺序
    1.  子类中重新方法就会覆盖
    2.  子类中调用父类方法
        1.  父类名.方法
        2.  super().方法
4.  多继承
    1.  经典类的计算：深度优先
    2.  新式类的计算：mro算法
        ```py
        mro(Child(Base1，Base2)) = [ Child ] + merge( mro(Base1), mro(Base2), [ Base1, Base2] )
        1-merge不为空，取出第一个列表列表①的表头E，进行判断                              
        各个列表的表尾分别是[O], [E,F,O]，E在这些表尾的集合中，因而跳过当前当前列表
        2-取出列表②的表头C，进行判断
        C不在各个列表的集合中，因而将C拿出到merge外，并从所有表头删除
        merge( [E,O], [C,E,F,O], [C]) = [C] + merge( [E,O], [E,F,O] )
        3-进行下一次新的merge操作 ......
        ```

# 面向对象编程特性：继承，封装，多态
1.  封装：把很多数据封装到⼀个对象中。把固定功能的代码封装到⼀个代码块，函数，对象，打包成模块
2.  继承： ⼦类可以⾃动拥有⽗类中除了私有属性外的其他所有内容；两个类具有相同的功能或者特征的时候就可以使用继承，提高代码的重用率
3.  多态： 同⼀个对象，多种形态；子类可以使用父类的方法也可以重写父类的方法
3.  类的约束
    1.  取⽗类：然后在⽗类中定义好⽅法。在这个⽅法中什么都不⽤⼲。就抛⼀个异常就可以了。这样所有的⼦类都必须重写这个⽅法。否则。访问的时候就会报错。⼈为抛出异常的⽅案
    2.  使⽤元类来描述⽗类：在元类中给出⼀个抽象⽅法。这样⼦类就不得不给出抽象⽅法的具体实现。也可以起到约束的效果。  
4.  super()深入了解？？？？？？？？

# 类的成员
1.  对于这些**私有**成员来说,他们**只能在类的内部使用,不能在类的外部以及派生类中使用**
```py
class A:
    company_name = '陈松'  # 静态变量(静态字段)
    __iphone = '132333xxxx'  # 私有静态变量(私有静态字段)
    ##
    def __init__(self,name,age): #特殊方法
        self.name = name  #对象属性(普通字段)
        self.__age = age  # 私有对象属性(私有普通字段)
    ##
    def func1(self):  # 普通方法
        pass
    ##
    def __func(self): #私有方法
        print(666)
    ##
    @classmethod  # 类方法
    def class_func(cls):
        """ 定义类方法，至少有一个cls参数 """
        print('类方法')
    ##
    @staticmethod  #静态方法
    def static_func():
        """ 定义静态方法 ，无默认参数"""
        print('静态方法')
    ##
    @property  # 属性
    def prop(self):
        pass
```
2.  方法：普通方法、静态方法和类方法，三种方法在内存中都归属于类
    1.  实例方法
        ```
        定义：第一个参数必须是实例对象，该参数名一般约定为“self”，通过它来传递实例的属性和方法（也可以传类的属性和方法）；
        调用：只能由实例对象调用。
        ```
    2.  类方法：通过类调用
        ```
        定义：使用装饰器@classmethod。第一个参数必须是当前类对象，该参数名一般约定为“cls”，通过它来传递类的属性和方法（不能传实例的属性和方法）；
        调用：实例对象和类对象都可以调用。
        ```
    3.  静态方法：逻辑上属于类，但是和类本身没有关系，也就是说在静态方法中，不会涉及到类中的属性和方法的操作。可以理解为，静态方法是个独立的、单纯的函数
        ```
        定义：使用装饰器@staticmethod。参数随意，没有“self”和“cls”参数，但是方法体中不能使用类或实例的任何属性和方法；
        调用：实例对象和类对象都可以调用。
        ```
3.  属性：property：property是一种特殊的属性，访问它时会执行一段功能（函数）然后返回值；将一个类的函数定义成特性以后，对象再去使用的时候obj.name,根本**无法察觉自己的name是执行了一个函数然后计算出来的**，这种特性的使用方式遵循了统一访问的原则
    ```py
    class Foo:
        @property
        def AAA(self):
            print('get的时候运行我啊')
        @AAA.setter
        def AAA(self,value):
            print('set的时候运行我啊')
        @AAA.deleter
        def AAA(self):
            print('delete的时候运行我啊')
    #只有在属性AAA定义property后才能定义AAA.setter,AAA.deleter
    f1=Foo()
    f1.AAA
    f1.AAA='aaa'
    del f1.AAA
    ```
4.  isinstance(a,b)：判断a是否是b类（或者b类的派生类）实例化的对象
5.  issubclass(a,b)： 判断a类是否是b类（或者b的派生类）的派生类

# 对象反射
1.  通过字符串的形式操作对象相关的属性
    1.  hasattr()：判断是否有属性
    2.  getattr()：获取这个属性
2.  函数和方法的区别
    1.  数的是显式传递数据的。如我们要指明为len()函数传递一些要处理数据。
    2.  **函数则跟对象无关。**
    3.  方法中的数据则是隐式传递的。
    4.  方法可以操作类内部的数据。
    5.  **方法跟对象是关联的**。如我们在用strip()方法是，是不是都是要通过str对象调用，比如我们有字符串s,然后s.strip()这样调用。是的，strip()方法属于str对象

# 序列化
1.  在程序运行的过程中，所有的变量都是在内存中，程序结束后全部回收，没有吧变量存储下来；我们把变量从内存中变成可存储或传输的过程称之为序列化；python的pickle模块可以将变量序列化存储到磁盘中；但是这个只适用于python，无法在其他语言中恢复
    ```py
    import pickle
    d = dict(name='Bob', age=20, score=88)
    pickle.dumps(d)
    f = open('dump.txt', 'wb')
    pickle.dump(d, f)
    f.close()
    f = open('dump.txt', 'rb')
    d = pickle.load(f)
    f.close()
    ```
2.  JSON提供一种通用的序列化格式；dict对象可以直接序列化为JSON的{}

JSON类型 | Python类型
---|---
{} | dict
[] | list
"string" | str
1234.56 | int或float
true/false | True/False
null | None

3.  JSON模块：
    ```py
    >>> import json
    >>> d = dict(name='Bob', age=20, score=88)
    >>> json.dumps(d)
    '{"age": 20, "score": 88, "name": "Bob"}' # 返回一个str
    >>> json_str = '{"age": 20, "score": 88, "name": "Bob"}'
    >>> json.loads(json_str)
    {'age': 20, 'score': 88, 'name': 'Bob'}
    ```
4.  在序列化对象的时候，我们需要将其字典化
    ```py
    def student2dict(std):
        return {
            'name': std.name,
            'age': std.age,
            'score': std.score
        }
    >>> print(json.dumps(s, default=student2dict))
    {"age": 20, "name": "Bob", "score": 88}
    ```
