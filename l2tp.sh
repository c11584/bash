#!/bin/bash 
 
# 检测系统类型 
if [ -f /etc/redhat-release ]; then 
    PACKAGE_MANAGER="yum" 
elif [ -f /etc/debian_version ]; then 
    PACKAGE_MANAGER="apt-get" 
else 
    echo "不支持的 Linux 系统类型。" 
    exit 1 
fi 
 
# 安装 wget 
if [ "$PACKAGE_MANAGER" = "yum" ]; then 
    $PACKAGE_MANAGER -y install wget 
else 
    $PACKAGE_MANAGER update 
    $PACKAGE_MANAGER -y install wget 
fi 
 
# 下载并设置 vpn.sh  脚本 
wget https://get.vpnsetup.net  -O vpn.sh  
chmod u+x vpn.sh  
 
# 设置 VPN 环境变量并运行脚本 
VPN_IPSEC_PSK='3' VPN_USER='3' VPN_PASSWORD='3' ./vpn.sh  
 
# 防火墙操作 
if [ "$PACKAGE_MANAGER" = "yum" ]; then 
    # 基于 Red Hat 系统的防火墙操作 
    systemctl stop firewalld 
    systemctl mask firewalld 
    $PACKAGE_MANAGER -y install iptables iptables-services 
else 
    # 基于 Debian 系统的防火墙操作 
    $PACKAGE_MANAGER -y install iptables 
fi 
 
# 配置 iptables 
iptables -P INPUT ACCEPT 
iptables -F 
iptables -F 
iptables -X 
iptables -Z 
 
# 保存 iptables 规则 
if [ "$PACKAGE_MANAGER" = "yum" ]; then 
    service iptables save 
fi 
 
# 重启和启动服务 
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
