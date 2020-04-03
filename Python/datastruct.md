---
title: 数据结构基础
date: 2020-03-20 22:00:00
categories: Python
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [八大数据结构](#八大数据结构)
  - [数组、链表、队列、栈、树、图、堆、散列表](#数组链表队列栈树图堆散列表)
  - [数组](#数组)
  - [栈](#栈)
  - [队列](#队列)
  - [链表](#链表)
  - [树](#树)
  - [散列表](#散列表)
  - [堆](#堆)
  - [图](#图)
- [基础算法](#基础算法)
  - [冒泡排序](#冒泡排序)
  - [插入排序](#插入排序)
  - [选择排序](#选择排序)
  - [归并排序](#归并排序)
  - [快速排序](#快速排序)
  - [扩展排序](#扩展排序)
  - [二分查找](#二分查找)
  - [树的遍历](#树的遍历)
<!-- TOC END -->
<!--more-->

# 八大数据结构

## 数组、链表、队列、栈、树、图、堆、散列表

## 数组
1.  数组是可以再内存中连续存储多个元素的结构，在内存中的分配也是连续的，数组中的元素通过数组下标进行访问，数组下标从0开始
2.  索引查询快；遍历速度快
3.  扩容不方便，在内存中需要连续的存储空间；组只能存储一种类型的数据添加，删除的操作慢，因为要移动其他的元素。
4.  使用场景：频繁查询，对存储空间要求不大，很少增加和删除的情况

## 栈
1.  栈是一种特殊的线性表，仅能在线性表的一端操作，栈顶允许操作，栈底不允许操作。 栈的特点是：先进后出，或者说是后进先出，从栈顶放入元素的操作叫入栈，取出元素叫出栈；
2.  类似集装箱，先装入的后取出；所以，栈常应用于实现递归功能方面的场景，例如斐波那契数列

## 队列
1.  队列是一种特殊的线性表；不同的是，队列可以在一端添加元素，在另一端取出元素，也就是：先进先出。从一端放入元素的操作称为入队，取出元素为出队
2.  使用场景：因为队列先进先出的特点，在多线程阻塞队列管理中非常适用

## 链表
1.  链表是物理存储单元上非连续的、非顺序的存储结构，数据元素的逻辑顺序是通过链表的指针地址实现，每个元素包含两个结点，一个是存储元素的数据域 (内存空间)，另一个是指向下一个结点地址的指针域。根据指针的指向，链表能形成不同的结构，例如单链表，双向链表，循环链表等
2.  优点：添加和删除元素熟读快；不需要连续的地址空间
3.  缺点：需要额外的空间存储指针，不适合数据量大的场景；查找时比较麻烦
4.  适用场景：数据量较小，需要频繁增加，删除操作的场景

## 树
1.  树是一种数据结构，它是由n（n>=1）个有限节点组成一个具有层次关系的集合
2.  特点
    1.  每个节点有零个或多个子节点；
    2.  没有父节点的节点称为根节点；
    3.  每一个非根节点有且只有一个父节点；
    4.  除了根节点外，每个子节点可以分为多个不相交的子树；
3.  二叉树
    1.  每个结点最多有两颗子树，结点的度最大为2。
    2.  左子树和右子树是有顺序的，次序不能颠倒。
    3.  即使某结点只有一个子树，也要区分左右子树。
    4.  增删数据，查询数据都比较快，适合处理大批量数据

## 散列表
1.  散列表，也叫哈希表，是根据关键码和值 (key和value) 直接进行访问的数据结构，通过key和value来映射到集合中的一个位置，这样就可以很快找到集合中的对应元素。
2.  **记录的存储位置=f(key)**

## 堆
1.  堆是一种比较特殊的数据结构，可以被看做一棵树的数组对象，具有以下的性质：
    1.  堆中某个节点的值总是不大于或不小于其父节点的值；
    2.  堆总是一棵完全二叉树。
2.  堆的定义如下：n个元素的序列{k1,k2,ki,…,kn}当且仅当满足下关系时，称之为堆。(ki <= k2i,ki <= k2i+1)或者(ki >= k2i,ki >= k2i+1), (i = 1,2,3,4…n/2)，满足前者的表达式的成为小顶堆，满足后者表达式的为大顶堆

## 图
1.  图由节点的又穷集合和边的集合组成
2.  图是一种比较复杂的数据结构，在存储数据上有着比较复杂和高效的算法

# 基础算法

## 冒泡排序

```py
def bubble(li: List, le: int):
    if le <= 1:
        return
    for i in range(le):
        flag = False
        for j in range(0, le - i - 1):
            if li[j] > li[j + 1]:
                li[j], li[j + 1] = li[j + 1], li[j]
                flag = True
        if not flag:
            break
```

## 插入排序

```py
def insert(li: List, le: int):
    for i in range(1, le):
        j, tmp = i - 1, li[i]
        while j >= 0 and li[j] > tmp:
            li[j + 1] = li[j]
            j -= 1
        li[j + 1] = tmp
```

## 选择排序

```py
def select(li: List, le: int):
    for i in range(le):
        min_index, min_value = i, li[i]
        for j in range(i, le):
            if li[j] < min_value:
                min_value, min_index = li[j], j
        li[i], li[min_index] = li[min_index], li[i]
```

## 归并排序

```py
def gb(li, low, high):
    if low >= high:
        return
    mid = low + (high - low) // 2
    gb(li, low, mid)
    gb(li, mid + 1, high)
    merger(li, low, mid, high)


def merger(li, low, mid, high):
    i, j = low, mid + 1
    tmp = []
    while i <= mid and j <= high:
        if li[i] <= li[j]:
            tmp.append(li[i])
            i += 1
        else:
            tmp.append(li[j])
            j += 1
    start = i if i <= mid else j
    end = mid if i <= mid else high
    tmp.extend(li[start: end + 1])
    li[low: high + 1] = tmp
```

## 快速排序

- ### 基本实现
    ```py
    def fast(li, low, high):
    if low >= high:
        return
    number = random.randrange(low, high)
    li[high], li[number] = li[number], li[high]
    p = partition(li, low, high)
    fast(li, low, p - 1)
    fast(li, p + 1, high)


    def partition(li, low, high):
        i, value = low, li[high]
        for j in range(low, high):
            if li[j] <= value:
                li[i], li[j] = li[j], li[i]
                i += 1
        li[i], li[high] = li[high], li[i]
        return i
    ```

- ### 双路排序

## 扩展排序

- ### 桶排序

- ### 计数排序

- ### 基数排序

## 二分查找

- ### 基本实现
    ```py
    def half(li, low, high, value):
    while low <= high:
        mid = low + (high - low) // 2
        if li[mid] < value:
            low = mid + 1
        elif li[mid] > value:
            high = mid - 1
        else:
            return mid
    return -1
    ```
    
- ### 扩展二分

## 树的遍历

```py
class TreeNode(object):
    def __init__(self, value):
        self.value = value
        self.left = None
        self.right = None
```

- ### 前序遍历
    ```py
    def pre_order(root: TreeNode):
        if root:
            print(root.value)
            pre_order(root.left)
            pre_order(root.right)
    ```

- ### 中序遍历
    ```py
    def in_order(root: TreeNode):
        if root:
            in_order(root.left)
            print(root.value)
            in_order(root.right)
    ```

- ### 后续遍历
    ```py
    def post_order(root: TreeNode):
        if root:
            post_order(root.left)
            post_order(root.right)
            print(root.value)
    ```

- ### 层次遍历
    ```py
    def level_order(root: TreeNode):
        if not root:
            return
        else:
            queue = [root]
        while queue:
            current = queue.pop(0)
            print(current.value)
            if current.left:
                queue.append(current.left)
            if current.right:
                queue.append(current.right)
    ```
