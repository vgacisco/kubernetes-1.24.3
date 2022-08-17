#! /bin/bash

# 维护者: vgacisco
# 
#
# 这个脚本用来准备二进制文件
# 就是从 kubernetes etcd里 解压文件 后面的角色安装会用到
# version: v1.0

# 修改日期: 8/10/22

if [ ! -f kubectl ]
then
    tarfile=$(ls -laf |grep kubernetes |awk 'NR==1')
    # 注意这里要保证kubernetes压缩包正确并且只有一份
    tar xf $tarfile
    mv kubernetes/server/bin/{kube-apiserver,kube-controller-manager,kube-scheduler,kube-proxy,kubelet,kubectl} .
    rm -rf kubernetes
fi


if [ ! -f etcd ]
then
    etcd_tarfile=$(ls -laf | grep etcd- |awk 'NR==1')
    etcd_dir_name=$(echo $etcd_tarfile| grep -o 'etcd-v[0-9].[0-9]\{1,2\}.[0-9]\{1,2\}-linux-amd64')
    tar xf $etcd_tarfile
    cp $etcd_dir_name/etcd .
    rm -rf $etcd_dir_name
fi
