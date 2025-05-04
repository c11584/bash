#!/bin/bash
 
# 检查是否提供了端口号和速率限制作为参数 
if [ $# -ne 2 ]; then 
    echo "Usage: $0 <port> <limit>" 
    exit 1 
fi 
 
port=$1 
limit=$2 
 
# 获取除 tun 和 lo 之外的所有网卡接口 
interfaces=$(ip link show | grep -oP '^\d+: \K\w+' | grep -v '^tun' | grep -v 'lo') 
 
# 循环遍历每个网卡接口 
for interface in $interfaces; do 
    # 添加根 qdisc 
    tc qdisc add dev $interface root handle 1: htb 
    # 添加类 
    tc class add dev $interface parent 1: classid 1:$limit htb rate ${limit}Mbit ceil ${limit}Mbit 
    # 添加过滤器 
    tc filter add dev $interface parent 1: protocol ip u32 match ip sport $port 0xffff classid 1:$limit 
    echo -e "Limit set successfully for interface $interface" 
done 

echo -e "limit success"
