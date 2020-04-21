#!/bin/bash
SHHOME=$(cd `dirname $0`; pwd)
BASEHOME=$(cd $SHHOME/..; pwd)

function log_error() {
    echo -e "\033[31m [ERROR] $@ \033[0m"
}

function log_info() {
    echo -e "\033[32m [INFO] $@ \033[0m"
}

function log_warn() {
    echo -e "\033[33m [WARN] $@ \033[0m"
}

function check {

cat << EOF
+-------------------------------------------------+
|                检查系统相关信息                    |
+-------------------------------------------------+
EOF
    log_info "[Docker版本]"
    docker -v
    DockerRootDir=`docker info  | grep "Docker Root Dir" | awk '{print $4}'`
    if [ $? -eq 0 ]; then
        log_info "[Docker根目录]"
        log_info $DockerRootDir
        df -hl $DockerRootDir
        PUsedDisk=`df -hl $DockerRootDir | awk 'NR==2{print $5}' | sed 's/%//g'`
        if [ $PUsedDisk -gt 90 ]; then
            log_warn "Insufficient disk space 可用磁盘空间过低"
            log_warn "[$DockerRootDir]磁盘可用空间过低, 已使用[$PUsedDisk]%"
        fi
    fi

    log_info "[Workspace工作目录]"
    log_info $BASEHOME
    log_info `df -hl $BASEHOME`
    PUsedDisk=`df -hl $BASEHOME | awk 'NR==2{print $5}' | sed 's/%//g'`
    if [ $PUsedDisk -gt 90 ]; then
        log_warn "Insufficient disk space 可用磁盘空间过低"
        log_warn "[$BASEHOME] 磁盘可用空间过低, 已使用[$PUsedDisk]%"
    fi

    log_info "[CPU信息]"
    cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c
    log_info `cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c`
    CPUHZ=`cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c | awk '{print $8}' | awk -F 'G' '{print $1}'`
    if [ $(echo "$CPUHZ < 2.5"|bc) == 1 ]; then
        log_error "CPU 主频低于2.5GHz, 性能将无法达到指标"
    fi

    log_info "[内存信息]"
    free -g
    FreeMem=`free -g | grep "Mem"  | awk '{print $7}'`
    if [ $FreeMem -lt 10 ]; then
        log_warn "Insufficient mem size 可用内存过低"
        log_warn "系统可用内存过低, 剩余[$FreeMem]GB"
    fi

    log_info "[系统资源信息]"

    ulimit -a

    sfd=`ulimit -Sn`
    if [ $sfd -lt 655350 ]; then
        log_warn "系统文件描述符配置较低(ulimit -Sn) $sfd < 655350, 请参考文档进行系统级优化"
    fi

    hfd=`ulimit -Hn`
    if [ $hfd -lt 655350 ]; then
        log_warn "系统文件描述符配置较低(ulimit -Hn) $hfd < 655350, 请参考文档进行系统级优化"
    fi
}

function main {
    check
cat << EOF
+-------------------------------------------------+
|                备注                          |
+-------------------------------------------------+
EOF

    export COMPOSE_HTTP_TIMEOUT=120

    log_info "--重要消息，请关注--"

}

main $@
