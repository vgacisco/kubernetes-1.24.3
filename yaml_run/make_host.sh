#! /bin/bash


####################################################################################################################################
#
# 紫脚本 用来生成虚拟机 和配置虚拟机ip , 依赖roles/files/hosts文档
#
#
###################################################################################################################################

base_system=$1
passwd=$2
dns="192.168.1.1"
gateway="192.168.1.1"

# 检查并 clone 虚拟机
cat roles/files/hosts |grep -v "localhost" |while read host_info
do
    
    ip=$(echo $host_info |awk '{print $1}')
    host=$(echo $host_info |awk '{print $2}')

    if ! sudo virsh list --all |grep "$host";then
        
        echo clone $base_system to $host
        sudo  virt-clone --auto-clone -o $base_system -n $host
    fi
done


# 启动虚拟机

cat roles/files/hosts |grep -v "localhost" |while read host_info
do
  
    host=$(echo $host_info |awk '{print $2}')

    if ! sudo virsh list |grep "$host";then
        sudo virsh start $host
    fi

done

# 配置虚拟机网络

cat roles/files/hosts |grep -v "localhost" |while read host_info
do

    ip=$(echo $host_info |awk '{print $1}')
    host=$(echo $host_info |awk '{print $2}')

    ssh-keygen -R $ip
    /usr/bin/expect <<EOF
        set timeout 60
        spawn sudo virsh console $host
            expect {
                "Ctrl ^]" { send "\r"; exp_continue }
                "Ctrl + ]" { send "\r"; exp_continue }
                "login:"    { send "root\r"; exp_continue }
                "assword:"  { send "$passwd\r" }
            }

            expect "]#" { send  "nmcli connection modify enp1s0 ipv4.addresses ${ip}/24 \r" }
            expect "]#" { send  "nmcli connection modify enp1s0 ipv4.dns $dns ipv4.gateway $gateway ipv4.method manual autoconnect yes \r" }
            expect "]#" { send  "nmcli connection up enp1s0 \r" }

            exec sleep 2
            expect "]#" { send "logout\r" }
            exec sleep 1
            expect "login:" { send "\x1D" }
            expect eof
EOF
done
