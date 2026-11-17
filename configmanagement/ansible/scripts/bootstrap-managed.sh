#!/usr/bin/env bash
set -euo pipefail

# Autorise la clé publique du nœud de contrôle pour l'utilisateur vagrant
PUB=/vagrant/.lab-keys/id_ed25519.pub
if [ -f "$PUB" ]; then
  install -d -m 700 -o vagrant -g vagrant /home/vagrant/.ssh
  touch /home/vagrant/.ssh/authorized_keys
  grep -qF "$(cat $PUB)" /home/vagrant/.ssh/authorized_keys || cat "$PUB" >> /home/vagrant/.ssh/authorized_keys
  chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
  chmod 600 /home/vagrant/.ssh/authorized_keys
else
  echo "Clé du nœud de contrôle introuvable : lancez d'abord 'vagrant up control'." >&2
  exit 1
fi

# Python est requis par Ansible sur les nœuds gérés
apt-get update -y
apt-get install -y python3
