#!/bin/bash
# This script is pre setup scrpt.
# Please use root user
# sh normal_node_setup.sh

# set the enviroment
# Local: Set /etc/resolve.cfg
wget https://goo.gl/ojQzx5 -O pre_setup_resolve.conf
cp pre_setup_resolve.conf /etc/resolve.conf
# Network restart & install package
/etc/init.d/networking restart
UBUNTU_APT_SITE=free.nchc.org.tw
sed -i 's/^deb-src\ /\#deb-src\ /g' /etc/apt/sources.list
sed -E -i "s/([a-z]+.)?archive.ubuntu.com/$UBUNTU_APT_SITE/g" /etc/apt/sources.list
sed -i "s/security.ubuntu.com/$UBUNTU_APT_SITE/g" /etc/apt/sources.list
apt update
apt upgrade -y && \
apt install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
vim nmap iperf iperf3 tmux traceroute git sshpass curl openssh-server tree htop build-essential bash-completion python-pip python-dev build-essential python-setuptools python-numpy python-scipy python-matplotlib ipython python-setuptools software-properties-common && \
apt clean

sed -i "s/PermitRootLogin no/PermitRootLogin yes/g" /etc/ssh/sshd_config
systemctl reload ssh.service
service ssh restart
chkconfig sshd on

sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update
apt install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
python3.6 python3-pip python3-dev && \
apt clean

rm pre_setup_resolve.conf

echo "Setup finish!"
