#! /bin/bash

#
# 维护都： vgacisco
# 
# version: v1.0
# 
#

####################################################################################
#
#
#
# 这是个安装脚本 
#
#
#
####################################################################################

workdir=`pwd`

# ##############################    readiness   ###############################################
#
#  函数调用 yaml_run/readiness.yaml 如果出错则退出
#

function readiness() {
    if ! ansible-playbook yaml_run/readiness.yaml;then
        exit 1;
    fi
    return 0 
}

# ##############################   admin    ###############################################
# 安装 kubectl, 调用 yaml_run/admin.yaml 

function admin() {
    if ! ansible-playbook yaml_run/admin.yaml;then
        exit 2;
    fi
    return 0 
}

##############################  apiserver ###################
# apiserver.yaml 调用 

function apiserver() {
    if ! ansible-playbook yaml_run/apiserver.yaml;then
        exit 3;
    fi
    return 0 
}

##############################  containerd  ###################
# containerd.yaml 调用 

function containerd() {
    if ! ansible-playbook yaml_run/containerd.yaml;then
        exit 3;
    fi
    return 0 
}


##############################  controller  ###################
# controller.yaml 调用 

function controller() {
    if ! ansible-playbook yaml_run/controller.yaml;then
        exit 3;
    fi
    return 0 
}


##############################  etcd  ###################
# etcd.yaml 调用 

function etcd() {
    if ! ansible-playbook yaml_run/etcd.yaml;then
        exit 3;
    fi
    return 0 
}


##############################  installyaml ###################
# installyaml.yaml 调用 

function installyaml() {
    if ! ansible-playbook yaml_run/installyaml.yaml;then
        exit 3;
    fi
    return 0 
}


##############################  kubelet  ###################
# kubelet.yaml 调用 

function kubelet() {
    if ! ansible-playbook yaml_run/kubelet.yaml;then
        exit 3;
    fi
    return 0 
}


##############################  nginx  ###################
# nginx.yaml 调用 

function nginx() {
    if ! ansible-playbook yaml_run/nginx.yaml;then
        exit 3;
    fi
    return 0 
}


##############################  proxy  ###################
# proxy.yaml 调用 

function proxy() {
    if ! ansible-playbook yaml_run/proxy.yaml;then
        exit 3;
    fi
    return 0 
}


##############################  scheduler  ###################
# scheduler.yaml 调用 

function scheduler() {
    if ! ansible-playbook yaml_run/scheduler.yaml;then
        exit 3;
    fi
    return 0 
}


##############################  setbootstrap  ###################
# setbootstrap.yaml 调用 

function setbootstrap() {
    if ! ansible-playbook yaml_run/setbootstrap.yaml;then
        exit 3;
    fi
    return 0 
}


##############################  system  ###################
# system.yaml 调用 

function system() {
    if ! ansible-playbook yaml_run/system.yaml;then
        exit 3;
    fi
    return 0 
}

############################ print usage ####################
function print_usage(){
    echo " Usage: $0 "
    return 0
}


############################ auto install ####################
function auto_install() {
    for run in system etcd containerd nginx apiserver controller scheduler admin setbootstrap kubelet proxy installyaml;do
        $run
    done
    return 0
}

############################ function lazy ###################
#
# 这个是懒人的函数 
#
# 这个函数会调用两个 sh文件，
# 
# make_host.sh 用来生成虚拟机并配置 网络，这里要求kvm 虚拟机并且 系统为centos8/redhat8 ，开启串口通信
#
# expect-host.sh 用来对虚拟机进行免密配置

function lazy(){

    readiness
    
    if ! sudo virsh list --all |grep "$2";then
        echo base virtual host not fond
    fi
    
    export base_system=$1
    export passwd=$2

    ./yaml_run/make_host.sh 
    ./yaml_run/expect-host.sh 
    return 0

}

################################
#
#
#
#
# 持行逻辑，以参数 $1 选择持行,如果有三个参数，并且 第一个参数 是 auto_install，就会调用 laxy函数。以 第二个参数 为模板生成虚拟机
# 以 readiness 生成的 roles/files/hosts 为参数配置虚拟机的网络 ，
# PS: 虚拟机模板请使用 centos8/redhat8 ,第三个参数 为模板虚拟机的root密码
# 


if [ "$#" == 3 ] && [ "$1" == "auto_install" ];then
    lazy $2 $3
fi

case $1 in
    readiness)
        readiness
        ;;
    auto_install)
        auto_install
        ;;
    admin)
        admin
        ;;
    apiserver)
        apiserver
        ;;
    containerd)
        containerd
        ;;
    controller)
        controller
        ;;
    etcd)
        etcd
        ;;
    installyaml)
        installyaml
        ;;
    kubelet)
        kubelet
        ;;
    nginx)
        nginx
        ;;
    proxy)
        proxy
        ;;
    scheduler)
        scheduler
        ;;
    setbootstrap)
        setbootstrap
        ;;
    system)
        system
        ;;
    *)
        print_usage
        ;;
esac
        
