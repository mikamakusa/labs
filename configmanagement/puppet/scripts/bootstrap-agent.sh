#!/usr/bin/env bash
set -euxo pipefail

NODE_NAME="${1:?Nom du noeud obligatoire}"
export DEBIAN_FRONTEND=noninteractive
PUPPET_REPO_DEB="/tmp/puppet8-release-jammy.deb"

apt-get update
apt-get install -y curl wget ca-certificates gnupg lsb-release

wget -q "https://apt.puppet.com/puppet8-release-jammy.deb" -O "$PUPPET_REPO_DEB"
dpkg -i "$PUPPET_REPO_DEB"
apt-get update
apt-get install -y puppet-agent

cat > /etc/puppetlabs/puppet/puppet.conf <<EOF
[main]
certname = ${NODE_NAME}.lab.local
server = puppet-master.lab.local
environment = production
runinterval = 30m
EOF

# Déclenche une première demande de certificat.
# Le service agent ne sera activé qu'après signature côté serveur.
systemctl stop puppet || true
/opt/puppetlabs/bin/puppet ssl bootstrap || true

echo
echo "Agent ${NODE_NAME} installé."
echo "Demande de certificat envoyée si le Puppet Server était joignable."
echo "Après signature sur le master, lancer :"
echo "  sudo systemctl enable --now puppet"
echo "  sudo /opt/puppetlabs/bin/puppet agent -t"
