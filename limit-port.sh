#!/bin/bash

interfaces=$(ip link show | grep -oP '^\d+: \K\w+' | grep -v '^tun' | grep -v 'lo')
port=$1
limit=$2

tc qdisc add dev $interfaces root handle 1: htb
tc class add dev $interfaces parent 1: classid 1:$limit htb rate ${limit}Mbit ceil ${limit}Mbit
tc filter add dev $interfaces parent 1: protocol ip u32 match ip sport $port 0xffff classid 1:$limit

echo -e "limit success"
