#!/bin/bash
yum install squid ipset bind-utils -y

ipset create google_pay_block_v4 hash:net family inet
ipset create google_pay_block_v6 hash:net family inet6
iptables -A OUTPUT -d 8.8.8.8 -p tcp --dport 853 -j DROP

cd /usr/local/
wget --no-check-certificate -O /usr/local/time.sh https://raw.githubusercontent.com/c11584/bash/main/exclude-google.sh
chmod +x /usr/local/time.sh

sh -c 'echo "* * * * * root /usr/local/time.sh  >>/var/log/script.log  2>&1" >> /etc/crontab'

iptables -I INPUT -m set --match-set google_pay_block_v4 src -j DROP
ip6tables -A OUTPUT -m set --match-set google_pay_block_v6 dst -j DROP 

systemctl restart crond
