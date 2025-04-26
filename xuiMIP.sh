
#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

cur_dir=$(pwd)

xport=$1
xuser=$2
xpass=$3

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}错误：${plain} 必须使用root用户运行此脚本！\n" && exit 1

# check os
if [[ -f /etc/redhat-release ]]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
else
    echo -e "${red}未检测到系统版本，请联系脚本作者！${plain}\n" && exit 1
fi

osName="linux"
arch=$(arch)
osType=""

if [[ $arch == "x86_64" || $arch == "x64" || $arch == "amd64" ]]; then
    arch="amd64"
    osType="64"
elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
    arch="arm64"
    osType="arm64-v8a"
elif [[ $arch == "s390x" ]]; then
    arch="s390x"
else
    arch="amd64"
    osType="64"
    echo -e "${red}检测架构失败，使用默认架构: ${arch}${plain}"
fi

echo "架构: ${arch}"

if [ $(getconf WORD_BIT) != '32' ] && [ $(getconf LONG_BIT) != '64' ]; then
    echo "本软件不支持 32 位系统(x86)，请使用 64 位系统(x86_64)，如果检测有误，请联系作者"
    exit -1
fi

echo "架构: ${arch}，系统：${osType}"
xrayVersion="v25.3.6"
fileName="Xray-$osName-$osType.zip"

# os version
if [[ -f /etc/os-release ]]; then
    os_version=$(awk -F'[= ."]' '/VERSION_ID/{print $3}' /etc/os-release)
fi
if [[ -z "$os_version" && -f /etc/lsb-release ]]; then
    os_version=$(awk -F'[= ."]+' '/DISTRIB_RELEASE/{print $2}' /etc/lsb-release)
fi

if [[ x"${release}" == x"centos" ]]; then
    if [[ ${os_version} -le 6 ]]; then
        echo -e "${red}请使用 CentOS 7 或更高版本的系统！${plain}\n" && exit 1
    fi
elif [[ x"${release}" == x"ubuntu" ]]; then
    if [[ ${os_version} -lt 16 ]]; then
        echo -e "${red}请使用 Ubuntu 16 或更高版本的系统！${plain}\n" && exit 1
    fi
elif [[ x"${release}" == x"debian" ]]; then
    if [[ ${os_version} -lt 8 ]]; then
        echo -e "${red}请使用 Debian 8 或更高版本的系统！${plain}\n" && exit 1
    fi
fi

install_base() {
    if [[ x"${release}" == x"centos" ]]; then
        yum install wget curl tar -y
    else
        apt install wget curl tar -y
    fi
}

#This function will be called when user installed x-ui out of sercurity
config_after_install() {

    /usr/local/x-ui/x-ui setting -username $xuser -password $xpass
    /usr/local/x-ui/x-ui setting -port $xport
    echo -e "${yellow} port: $xport, user: $xuser, pass: $xpass set success!${plain}"
}

install_x-ui() {
    systemctl stop x-ui
    cd /usr/local/

    last_version="0.3.2"
    url="https://github.com/vaxilu/x-ui/releases/download/${last_version}/x-ui-linux-${arch}.tar.gz"
    echo -e "开始安装 x-ui v$last_version"
    wget -N --no-check-certificate -O /usr/local/x-ui-linux-${arch}.tar.gz ${url}
    if [[ $? -ne 0 ]]; then
        echo -e "${red}下载 x-ui v$last_version 失败，请确保此版本存在${plain}"
        exit 1
    fi

    if [[ -e /usr/local/x-ui/ ]]; then
        rm /usr/local/x-ui/ -rf
    fi

    tar zxvf x-ui-linux-${arch}.tar.gz
    rm x-ui-linux-${arch}.tar.gz -f
    cd x-ui
    chmod +x x-ui bin/xray-linux-${arch}
    cp -f x-ui.service /etc/systemd/system/
    wget --no-check-certificate -O /usr/bin/x-ui https://raw.githubusercontent.com/vaxilu/x-ui/main/x-ui.sh
    chmod +x /usr/local/x-ui/x-ui.sh
    chmod +x /usr/bin/x-ui
    config_after_install
   
    yum install unzip -y
    wget -O  $fileName https://github.com/XTLS/Xray-core/releases/download/$xrayVersion/$fileName
    wget -O config.json https://raw.githubusercontent.com/c11584/bash/main/xuiIp.json
    
    unzip -o $fileName

    mv -f xray /usr/local/x-ui/bin/xray-linux-$arch
    mv -f geosite.dat /usr/local/x-ui/bin/geosite.dat
    mv -f geoip.dat /usr/local/x-ui/bin/geoip.dat
    mv -f config.json /usr/local/x-ui/bin/config.json
    
    systemctl daemon-reload
    systemctl enable x-ui
    systemctl start x-ui

    echo -e "install success"
}

echo -e "${green}开始安装${plain}"
install_base
install_x-ui
