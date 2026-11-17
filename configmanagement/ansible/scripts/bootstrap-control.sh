#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "--------------------------------"
echo "Installation d'Ansible"
echo "--------------------------------"
sudo apt-get update -y
sudo apt-get install -y software-properties-common sshpass
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible

echo "--------------------------------"
echo "Configuration des clés SSH"
echo "--------------------------------"
mkdir -p /vagrant/.lab-keys
if [ ! -f /vagrant/.lab-keys/id_ed25519 ]; then
  ssh-keygen -t ed25519 -N "" -f /vagrant/.lab-keys/id_ed25519 -C "ansible-lab"
fi

mkdir -p ~/.ssh
cp /vagrant/.lab-keys/id_ed25519 ~/.ssh/id_ed25519
cp /vagrant/.lab-keys/id_ed25519.pub ~/.ssh/id_ed25519.pub
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519

cat > ~/.ssh/config <<'CFG'
Host *
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  LogLevel ERROR
CFG
chmod 600 ~/.ssh/config

echo "Nœud de contrôle prêt : ansible --version"
