---
title: Git学习
date: 2019-11-10 14:19:00
tags: Others
categories: Git
---

## git起步
1. 安装
  ```
  yum install  -y git
  ```

2. 初始化
  ```
  git init
  ```

## 版本控制
### 第一个任务
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

### 版本回退
1. 查看提交记录
  ```
  git log [--pretty=oneline]
  git reflog #查看历史记录
  ```

2. 回退版本
  ```
  git reset --hard HEAD^(hash码)
  ```

### 撤销修改和删除
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

## 远程仓库
### 创建远程仓库
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

### 远程克隆仓库
1. 克隆
  ```
  git clone url
  ```

## 分支管理

- 你创建了一个属于你自己的分支，别人看不到，还继续在原来的分支上正常工作，而你在自己的分
支上干活，想提交就提交，直到开发完毕后，再一次性合并到原来的分支上，这样，既安全，又不影
响别人工作

### 创建与合并分支
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

### 分支管理
1. 分支合并
  ```
  git merge --no-ff -m 'message' dev
  ```
  - 合并分支时，加上--no-ff参数关闭fast forward合并就可以用普通模式合并，合并后的历史
  有分支，能看出来曾经做过合并，而fast forward合并就看不出来曾经做过合并

### Bug分支
1. 将当前工作区内容藏起来
  ```
  git stash
  ```
2. 修改完后，将藏起来的内容恢复修改
  ```
  git stash list
  git stash pop
  git stash apply stash@{0} #多次stash，恢复的时候，先用git stash list查看，然后恢
  复指定的stash
  ```
3. 修改bug后，将修改的bug分支复制到dev分支，完成修改工作
  ```
  git cherry-pick hash
  ```

### featurre分支
1. 删除未合并的分支
  ```
  git branch -D tempbranch
  ```

### 多人协作
1. 首先，可以试图用git push origin <branch-name>推送自己的修改；
2. 如果推送失败，则因为远程分支比你的本地更新，需要先用git pull试图合并；
3. 如果合并有冲突，则解决冲突，并在本地提交；
4. 没有冲突或者解决掉冲突后，再用git push origin <branch-name>推送就能成功！
5. 如果git pull提示no tracking information，则说明本地分支和远程分支的链接关系没有创
建，用命令git branch --set-upstream-to <branch-name> origin/<branch-name>。
