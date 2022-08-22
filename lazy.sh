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

function lazy(){

    ansible-playbook ./yaml_run/readiness.yaml
    
    if ! sudo virsh list -all |grep $2;then
        echo base virtual host not fond
    fi

    ./yaml_run/make_host.sh $2 $3
    ./yaml_run/expect-host.sh $3
    return 0

}

################################
#
#
#
#
# 持行逻辑，以参数 $1 选择持行
# 
if [ "$#" == 3 ] && [ "$1" == "auto_install" ];then
    lazy
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
        
