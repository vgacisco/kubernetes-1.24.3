#! /bin/bash
#
#
# 维护者: vgacisco

###################################################################################################
#
#
#
# 启动/停止 k8s集群的虚拟机, 只能操作 kvm的虚拟机
#
#
#
###################################################################################################

if [ "$1" == "start" ];then

    cat roles/files/hosts |grep -v "localhost" |while read host_info
    do
    
        host=$(echo $host_info |awk '{print $2}')
    
        if ! sudo virsh list |grep "$host";then
            sudo virsh start $host
        fi
    
    done

elif [ "$1" == "stop" ];then

    
    cat roles/files/hosts |grep -v "localhost" |while read host_info
    do
    
        host=$(echo $host_info |awk '{print $2}')
    
        if  sudo virsh list |grep "$host";then
            sudo virsh shutdown $host
        fi
    
    done

else 
    echo " args onle start/stop "
fi
