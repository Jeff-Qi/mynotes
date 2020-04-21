#!/bin/bash
SHHOME=$(cd `dirname $0`; pwd)
BASEHOME=$(cd $SHHOME/..; pwd)
#CONFIGFILE=$BASEHOME/conf/nls.conf
COMPOSEFILE=$BASEHOME/.nls-compose.yml
COMPOSE_VERSION="2.1"

MSGFILE=$BASEHOME/.msg

#logsdir=`cat $CONFIGFILE | grep "^host_logs_dir" | sed "s/host_logs_dir=//g" | tr -d "\r\n"`
#diskdir=`cat $CONFIGFILE | grep "^host_disk_dir" | sed "s/host_disk_dir=//g" | tr -d "\r\n"`
#resdir=`cat $CONFIGFILE | grep "^host_res_dir" | sed "s/host_res_dir=//g" | tr -d "\r\n"`
#run_uid=`cat $CONFIGFILE | grep "^run_uid" | sed "s/run_uid=//g" | tr -d "\r\n"`

cd $BASEHOME

#mkdir -p ${diskdir}
#mkdir -p ${logsdir}
#NLSLOGDIR=$(cd $logsdir; pwd)
#NLSDATADIR=$(cd $diskdir; pwd)

#StartLogFile=${NLSLOGDIR}/start.log

#function sysOptimzation {
#    if [ X$USER == X"root" ];then
#        sudo sysctl -w net.ipv4.ip_local_port_range="10000 64000"
#    fi
#}

#echo "" > $StartLogFile

function log_error() {
    echo -e "\033[31m [ERROR] $@ \033[0m"
    echo "ERROR $@"  >> $StartLogFile
}

function log_info() {
    echo -e "\033[32m [INFO] $@ \033[0m"
    echo "INFO $@"  >> $StartLogFile
}

function log_warn() {
    echo -e "\033[33m [WARN] $@ \033[0m"
    echo "WARN $@"  >> $StartLogFile
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
    log_info `cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c`
    CPUHZ=`cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c | awk '{print $8}' | awk -F 'G' '{print $1}'`
    if [ $(echo "$CPUHZ < 2.5"|bc) = 1 ]; then 
        log_error "CPU 主频低于2.5GHz, 性能将无法达到指标"
    fi

    log_info "[内存信息]"
    log_info `free -g`
    FreeMem=`free -g | grep "Mem"  | awk '{print $7}'`
    if [ $FreeMem -lt 10 ]; then
        log_warn "Insufficient mem size 可用内存过低"
        log_warn "系统可用内存过低, 剩余[$FreeMem]GB"
    fi

    log_info "[系统资源信息]"

    ulimit -a
    log_info `ulimit -a`

    sfd=`ulimit -Sn`
    if [ $sfd -lt 655350 ]; then
        log_warn "系统文件描述符配置较低(ulimit -Sn) $sfd < 655350, 请参考文档进行系统级优化"
    fi

    hfd=`ulimit -Hn`
    if [ $hfd -lt 655350 ]; then
        log_warn "系统文件描述符配置较低(ulimit -Hn) $hfd < 655350, 请参考文档进行系统级优化"
    fi

    log_info "[日志目录]: $NLSLOGDIR"

    log_info "[运行数据目录]: "$NLSDATADIR""
}

function main {
    sysOptimzation

    check

cat << EOF
+-------------------------------------------------+
|                启动容器                          |
+-------------------------------------------------+
EOF

    export COMPOSE_HTTP_TIMEOUT=120

    $SHHOME/docker-compose -f $COMPOSEFILE up -d $@

    log_info "--重要消息，请关注--" 

    log_info "[日志目录]: $NLSLOGDIR"

    log_info "[运行数据目录]: "$NLSDATADIR""

    log_info "注意 预计3分钟后可以通过\"sh $BASEHOME/bin/status.sh\" 查看各服务主端口状态"

    log_info "注意 预计3分钟后可以通过\"sh $BASEHOME/demo/demo.sh\" 进行自验证 "

}

main $@
