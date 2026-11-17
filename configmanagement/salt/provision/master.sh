#!/usr/bin/env bash
set -euo pipefail

MASTER_IP="$1"

curl -fsSL https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh \
  -o /tmp/bootstrap-salt.sh

echo "--------------------------------"
echo "Installation du master Salt"
echo "--------------------------------"
sh /tmp/bootstrap-salt.sh -M -A "$MASTER_IP" -i salt-master stable

echo "--------------------------------"
echo "Configuration du master Salt"
echo "--------------------------------"
mkdir -p /etc/salt/master.d
cat > /etc/salt/master.d/lab.conf <<EOF
# LAB UNIQUEMENT : acceptation automatique des clés des minions
auto_accept: True

interface: 0.0.0.0

file_roots:
  base:
    - /srv/salt

pillar_roots:
  base:
    - /srv/pillar
EOF

systemctl restart salt-master
systemctl restart salt-minion