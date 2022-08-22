#! /bin/bash

#这个脚本 用来给hosts中的主机做免密登录

passwd="$1"

cat roles/files/hosts |grep -v "localhost" 

IFS_SAVE=$IFS
IFS=$'\n'
for host_info in `cat roles/files/hosts |grep -v localhost`
do
    
    ip=$(echo "$host_info" | awk '{print $1}')
    host=$(echo $host_info | awk '{print $2}')

    ssh-keygen -R $ip

  /usr/bin/expect <<EOF
    set timeout 30
    spawn ssh-copy-id root@$ip
            expect {
                "yes/no"  { send "yes\r"; exp_continue }
                "login:" { send "root\r"; exp_continue }
                "assword:" { send "$passwd\r" }
            }
            expect eof
EOF

    scp roles/files/repo.tar root@$ip:/root
    ssh root@$ip tar xf /root/repo.tar -C /etc/yum.repos.d/

done
