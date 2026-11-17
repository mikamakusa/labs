#!/usr/bin/env bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

echo "--------------------------------"
echo "Configuration de la résolution de noms des hôtes"
echo "--------------------------------"
sed -i '/# chef-lab/d' /etc/hosts
cat >> /etc/hosts <<HOSTS
192.168.56.10 chef-workstation # chef-lab
192.168.56.11 chef-server      # chef-lab
192.168.56.12 web1             # chef-lab
192.168.56.13 web2             # chef-lab
192.168.56.14 app1             # chef-lab
192.168.56.15 db1              # chef-lab
HOSTS

echo "vagrant:vagrant" | chpasswd
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
rm -f /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
systemctl restart ssh

apt-get update -y
apt-get install -y curl wget vim git sshpass
