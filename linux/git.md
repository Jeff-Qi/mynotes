---
title: Git学习
date: 2019-11-10 14:19:00
categories: Linux
---
<!-- TOC START min:1 max:3 link:true asterisk:false update:true -->
- [分布式与集中式](#分布式与集中式)
- [git起步](#git起步)
- [版本控制](#版本控制)
  - [第一个任务](#第一个任务)
  - [版本回退](#版本回退)
    - [工作区与暂存区](#工作区与暂存区)
  - [撤销修改和删除](#撤销修改和删除)
- [远程仓库](#远程仓库)
  - [创建远程仓库](#创建远程仓库)
  - [远程克隆仓库](#远程克隆仓库)
- [分支管理](#分支管理)
  - [创建与合并分支](#创建与合并分支)
  - [分支管理](#分支管理-1)
  - [Bug分支](#bug分支)
  - [featurre分支](#featurre分支)
- [多人协作](#多人协作)
- [标签](#标签)
- [创建git仓库](#创建git仓库)
- [其他git配置使用](#其他git配置使用)
<!-- TOC END -->
<!--more-->

# 分布式与集中式
- 集中式CVS，SVN：
    1. 速度慢，必须联网，开源精神不符
    2. 版本库集中放在中央服务器，工作时，获取最新版本，工作完成后，再推送给中央服务器！

- 分布式GIT：
    1. 无中央服务器，每个人的电脑都是一个完整的版本库
    1. 安全性能更高
    1. 通常有一台充当“中央服务器”的电脑，仅仅作为方便“交换”大家的修改

- 所有的版本控制系统，其实**只能跟踪文本文件的改动**，比如TXT文件，网页，所有的程序代码等等，Git也不例外。版本控制系统可以告诉你每次的改动，图片、视频这些二进制文件，虽然也能由版本控制系统管理，但没法跟踪文件的变化，只能把二进制文件每次改动串起来，也就是只知道图片从100KB改成了120KB，但到底改了啥，版本控制系统不知道，也没法知道。

# git起步
1. 安装
  ```
  yum install  -y git
  ```

2. 初始化
  ```
  git init
  ```

# 版本控制

## 第一个任务
1. 工作区文件放入站暂存区
  ```
  git add xx.txt
  ```

2. 暂存区文件提交(设置你的git邮箱和git姓名)
  ```
  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"
  git commit -m 'message'
  ```

3. 看查当前状态
  ```
  git status
  ```

4. 查看修改文件不同
  ```
  git diff xx.txt
  ```

## 版本回退
1. 查看提交记录
  ```
  git log [--pretty=oneline]
  git reflog #查看历史记录
  ```

2. 回退版本
  ```
  git reset --hard HEAD^(hash码)
  ```

- 控制版本历史记录：因为git内部有个Head指针指向当前的版本，如果需要退回版本，只需要将Head指针指向相对应的版本号，并且更新工作区文件

### 工作区与暂存区
- 工作区：当前所在的firstgit目录就是一个工作区
- 暂存区：git add 后的状态
- master：git commit 后的状态保存到master上
- **git跟踪的是每次修改而不是文件，如果不将修改添加到暂存区是无法加入commit中的**

## 撤销修改和删除
1. 丢弃工作区修改
  ```
  git checkout -- xx.txt
  ```

2. 将暂存区文件拉回工作区
  ```
  git reset HEAD xx.txt
  ```

3. 删除文件
  ```
  git rm xx.txt
  ```

# 远程仓库

## 创建远程仓库
1. 新建github仓库
2. 添加ssh密钥
3. 关联远程仓库
  ```
  git remote add origin url
  ```

4. 首次推送分支
  ```
  git push -u origin master
  git push origin master  #以后提交
  ```

## 远程克隆仓库
1. 克隆
  ```
  git clone url
  ```

# 分支管理
- 你创建了一个属于你自己的分支，别人看不到，还继续在原来的分支上正常工作，而你在自己的分支上干活，想提交就提交，直到开发完毕后，再一次性合并到原来的分支上，这样，既安全，又不影响别人工作

## 创建与合并分支
1. 创建新分支
  ```
  git branch dev
  git checkout -b dev #创建并切换
  git switch -c dev #创建并切换
  ```

2. 切换分支
  ```
  git switch dev
  ```

3. 查看当前分支
  ```
  git branch
  ```

4. 合并分支
  ```
  git merge dev
  ```

5. 删除分支
  ```
  git branch -d dev
  ```

## 分支管理
1. 分支合并
  ```
  git merge --no-ff -m 'message' dev
  ```

  - 合并分支时，加上--no-ff参数关闭fast forward合并就可以用普通模式合并，合并后的历史
  有分支，能看出来曾经做过合并，而fast forward合并就看不出来曾经做过合并

2. 查看合并记录
  ```
  git log --graph --pretty=oneline --abbrev-commit
  ```

## Bug分支
1. 将当前工作区内容藏起来
  ```
  git stash
  ```

2. 修改完后，将藏起来的内容恢复修改
  ```
  git stash list
  git stash apply # 用git stash apply恢复，但是恢复后，stash内容并不删除，你需要用git stash drop来删除；
  git stash pop
  git stash apply stash@{0} # 多次stash，恢复的时候，先用git stash list查看，然后恢
  复指定的stash
  ```

3. 修改bug后，将修改的bug分支复制到dev分支，完成修改工作
  ```
  git cherry-pick hash
  ```

## featurre分支
1. 删除未合并的分支
  ```
  git branch -D tempbranch
  ```

# 多人协作
1. 首先，可以试图用git push origin <branch-name>推送自己的修改；
2. 如果推送失败，则因为远程分支比你的本地更新，需要先用git pull试图合并；
3. 如果合并有冲突，则解决冲突，并在本地提交；
4. 没有冲突或者解决掉冲突后，再用git push origin <branch-name>推送就能成功！
5. 如果git pull提示no tracking information，则说明本地分支和远程分支的链接关系没有创
建，用命令git branch --set-upstream-to <branch-name> origin/<branch-name>。
6. 在本地创建和远程分支对应的分支，使用git checkout -b branch-name origin/branch-name，本地和远程分支的名称最好一致；

# 标签

1. 创建标签
    ```sh
    git tag tag_name
    ```

2. 查看标签
    ```sh
    git tag
    ```

3. 绑定标签
    ```sh
    git tag tag_name hash_id
    ```

4. 标签需要和一个commit版本绑定
    ```sh
    git tag -a tag_name -m 'information' hash_id
    ```

5. 标签删除
    ```sh
    git tag -d tag_name
    # 远程删除比较麻烦，先本地删除，在同步push远程
    # git push origin :refs/tags/tag_name
    ```

6. 通过标签推送
    ```sh
    git push origin tag_name
    # git push origin --tags
    ```

# 创建git仓库
1. 安装git
2. 创建git用户
3. 收集公钥（id_rsa.pub文件），把所有公钥导入到/home/git/.ssh/authorized_keys文件里，一行一个
4. 选定目录初始化
    ```sh
    git init --bare sample.git
    ```
5. 修改仓库的owner与group
6. 修改git用户登录shell
    ```sh
    vim /etc/passwd
    /usr/bin/git-shell
    ```

# 其他git配置使用
1. 使用颜色
    ```sh
    git config --global color.ui true
    ```

2. 忽略git文件
    - 必须把某些文件放到Git工作目录中，但又不能提交它们
    - 在Git工作区的根目录下创建一个特殊的.gitignore文件，然后把要忽略的文件名填进去，Git就会自动忽略这些文件
