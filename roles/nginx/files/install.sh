#! /bin/bash
#
#维护者: vgacisco
# version: v1.2
# 8/10/22
# 8/28/22

############################################################################
#
# 这个脚本 用来安装 nginx
#
#
############################################################################


nginx_tarfile=$( ls -laf |grep nginx-.*tar.gz| awk 'NR==1')
nginx_dirfile=$(echo $nginx_tarfile | grep -o 'nginx-[0-9].[0-9]\{1,2\}.[0-9]\{1,2\}')

tar xf $nginx_tarfile

cd $nginx_dirfile

# yum install -y zlib-devel openssl-devel pcre-devel gcc make 

./configure --prefix=/opt/nginx --with-stream


make
make install
cd ..
cp nginx.conf /opt/nginx/conf/nginx.conf
cp nginx.service /usr/lib/systemd/system

systemctl enable --now nginx


