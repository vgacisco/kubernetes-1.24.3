#! /bin/bash

# 这个脚本 用来配置虚拟机初始ipaddress

hostpro="Euler-k8s-"
passwd="wxh542wxh.p"

# 启动虚拟机
for i in {1..5}
do
    if ! sudo virsh list |grep "${hostpro}$i";then
        sudo virsh start ${hostpro}$i
    fi

done

# 配置虚拟机网络

for i in {1..5}
do
    domain=${hostpro}$i
    address=192.168.1.3$i
    ssh-keygen -R 192.168.1.$i
    /usr/bin/expect <<EOF
        set timeout 60
        spawn sudo virsh console $domain
            expect {
                "Ctrl ^]" { send "\r"; exp_continue }
                "Ctrl + ]" { send "\r"; exp_continue }
                "login:"    { send "root\r"; exp_continue }
                "assword:"  { send "$passwd\r" }
            }

            expect "]#" { send  "nmcli connection modify enp1s0 ipv4.addresses ${address}/24 \r" }
            expect "]#" { send  "nmcli connection modify enp1s0 ipv4.dns 192.168.1.1 ipv4.gateway 192.168.1.1 ipv4.method manual autoconnect yes \r" }
            expect "]#" { send  "nmcli connection up enp1s0 \r" }

            exec sleep 2
            expect "]#" { send "logout\r" }
            exec sleep 1
            expect "login:" { send "\x1D" }
            expect eof
EOF
done
