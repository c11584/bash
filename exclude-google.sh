#!/bin/bash


dig pay.google.com  +short  > google_ipv4.txt
while read line; do ipset add google_pay_block_v4 $line; done < google_ipv4.txt  

dig payments.google.com  +short  > google_ipv4.txt
while read line; do ipset add google_pay_block_v4 $line; done < google_ipv4.txt  

dig wallet.google.com  +short  > google_ipv4.txt
while read line; do ipset add google_pay_block_v4 $line; done < google_ipv4.txt  

dig play-fe.googleapis.com +short  > google_ipv4.txt
while read line; do ipset add google_pay_block_v4 $line; done < google_ipv4.txt  



iptables -I INPUT -m set --match-set google_pay_block_v4 src -j DROP 
