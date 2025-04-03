#!/bin/bash

dig pay.google.com +short >google_ipv4.txt
dig +short pay.google.com AAAA >google_ipv6.txt
while read line; do ipset add google_pay_block_v4 $line; done <google_ipv4.txt
while read line; do ipset add google_pay_block_v6 $line; done <google_ipv6.txt

dig payments.google.com +short >google_ipv4.txt
dig +short payments.google.com AAAA >google_ipv6.txt
while read line; do ipset add google_pay_block_v4 $line; done <google_ipv4.txt
while read line; do ipset add google_pay_block_v6 $line; done <google_ipv6.txt

dig wallet.google.com +short >google_ipv4.txt
dig +short wallet.google.com AAAA >google_ipv6.txt
while read line; do ipset add google_pay_block_v4 $line; done <google_ipv4.txt
while read line; do ipset add google_pay_block_v6 $line; done <google_ipv6.txt

dig play-fe.googleapis.com +short >google_ipv4.txt
dig +short play-fe.googleapis.com AAAA >google_ipv6.txt
while read line; do ipset add google_pay_block_v4 $line; done <google_ipv4.txt
while read line; do ipset add google_pay_block_v6 $line; done <google_ipv6.txt

iptables -I INPUT -m set --match-set google_pay_block_v4 src -j DROP
iptables -I INPUT -m set --match-set google_pay_block_v6 src -j DROP
