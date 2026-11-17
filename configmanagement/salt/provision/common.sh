#!/usr/bin/env bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

echo "--------------------------------"
echo "Résolution de noms interne"
echo "--------------------------------"
sed -i '/# salt-lab/,$d' /etc/hosts
{
  echo "# salt-lab"
  echo "$HOSTS_ENTRIES"
} >> /etc/hosts

echo "--------------------------------"
echo "Mise à jour des paquets"
echo "--------------------------------"
apt-get update -y
apt-get install -y curl vim htop net-tools

echo "--------------------------------"
echo "Installation des paquets"
echo "--------------------------------"
apt-get install -y curl vim htop net-tools