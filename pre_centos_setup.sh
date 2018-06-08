#!/bin/bash
# This script is pre setup scrpt.
# Please use root user

# set the enviroment
# Local: Set /etc/resolve.cfg
wget https://goo.gl/ojQzx5 -O pre_setup_resolve.conf
cp pre_setup_resolve.conf /etc/resolve.conf
# Maybe need to add the following lines, if the hosts use server version OS image
# echo "dns-nameservers 8.8.8.8,8.8.4.4" >> /etc/network/interface

# Network restart & install package
/etc/init.d/networking restart

yum update
yum upgrade -y

# Timezone Set
#TZ=Asia/Taipei
#export DEBIAN_FRONTEND=noninteractive
#yum install -y tzdata
#dpkg-reconfigure --frontend noninteractive tzdata
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
timedatectl set-timezone Asia/Taipei

yum install -y \
vim nmap iperf iperf3 tmux traceroute git sshpass curl openssh-server tree htop build-essential bash-completion python-pip python-dev build-essential python-setuptools python-setuptools software-properties-common yum-utils groupinstall development && \
apt clean
sed -i "s/PermitRootLogin no/PermitRootLogin yes/g" /etc/ssh/sshd_config
sed -i "s/PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
sed -i "s/PermitRootLogin no/PermitRootLogin yes/g" /etc/ssh/sshd_config
sed -i "s/PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
systemctl reload ssh.service
service ssh restart
chkconfig sshd on

cd ~/ && yum -y install https://centos7.iuscommunity.org/ius-release.rpm
yum -y install python36u python36u-pip python36u-devel

# Add user
PASSWORD=$1
if  [ -z $PASSWORD ]; then
    useradd -m opadmin -s /bin/bash && echo "opadmin:OPgreatW0rld" | chpasswd && passwd -u opadmin
    sshpass -p OPgreatW0rld ssh -o StrictHostKeyChecking=no opadmin@localhost "touch ~/.sudo_as_admin_successful"
    echo "root:OPgreatW0rld" | chpasswd && passwd -u root
else
    useradd -m opadmin -s /bin/bash && echo "opadmin:$PASSWORD" | chpasswd && passwd -u opadmin
    sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no opadmin@localhost "touch ~/.sudo_as_admin_successful"
    echo "root:$PASSWORD" | chpasswd && passwd -u root
fi

adduser opadmin sudo
adduser opadmin adm
adduser opadmin dip
adduser opadmin cdrom
adduser opadmin plugdev
adduser opadmin lxd
adduser opadmin lpadmin
adduser opadmin sambashare
echo "opadmin ALL=NOPASSWD: ALL" >> /etc/sudoers

rm -f pre_setup_resolve.conf

# Local: install Ansible
yum install ansible -y

echo "Please download KaaS deploy tool"