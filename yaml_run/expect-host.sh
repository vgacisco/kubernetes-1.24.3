#! /bin/bash

#这个脚本 用来给hosts中的主机做免密登录

passwd="$1"

for host in `cat hosts |grep k8s |awk '{print $1}' |uniq`
do
    hostname=$(cat hosts |grep k8s |awk '{print $2}')

  /usr/bin/expect <<EOF
    set timeout 30
    spawn ssh-copy-id root@${host}
            expect {
                "yes/no"  { send "yes\r"; exp_continue }
                "login:" { send "root\r"; exp_continue }
                "assword:" { send "$passwd\r" }
            }
            expect eof
EOF

done
