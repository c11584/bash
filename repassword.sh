#!/bin/bash 

cat /dev/null > /root/.ssh/authorized_keys
echo root:Aa6190360@| chpasswd root
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd


echo -e "install success"
