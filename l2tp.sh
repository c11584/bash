#!/bin/bash 
sudo su root 
yum -y install wget
#wget -c https://github.com/YangJhao/xxxx1/raw/main/yjl2tp.sh && bash yjl2tp.sh
wget https://get.vpnsetup.net -O vpn.sh
sudo VPN_IPSEC_PSK='3' VPN_USER='3' VPN_PASSWORD='3' sh vpn.sh


sleep 2
systemctl stop firewalld
systemctl mask firewalld
apt install -y iptables
apt install -y iptables-services
iptables -P INPUT ACCEPT
iptables -F
iptables -F
iptables -X
iptables -Z
service iptables save
systemctl restart iptables
systemctl status iptables
systemctl status ipsec
systemctl status xl2tpd
systemctl enable ipsec
systemctl enable xl2tpd
systemctl restart iptables
systemctl restart ipsec
systemctl restart xl2tpd
systemctl start iptables
systemctl start ipsec
systemctl start xl2tpd


echo -e "install success"
