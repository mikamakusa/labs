#!/usr/bin/env bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive
PUPPET_REPO_DEB="/tmp/puppet8-release-jammy.deb"

apt-get update
apt-get install -y curl wget ca-certificates gnupg lsb-release

# Dépôt historique Puppet 8 pour Ubuntu 22.04.
wget -q "https://apt.puppet.com/puppet8-release-jammy.deb" -O "$PUPPET_REPO_DEB"
dpkg -i "$PUPPET_REPO_DEB"
apt-get update
apt-get install -y puppetserver

# Réglages adaptés à une VM de laboratoire.
if grep -q '^JAVA_ARGS=' /etc/default/puppetserver; then
  sed -i 's/^JAVA_ARGS=.*/JAVA_ARGS="-Xms512m -Xmx1g"/' /etc/default/puppetserver
else
  echo 'JAVA_ARGS="-Xms512m -Xmx1g"' >> /etc/default/puppetserver
fi

# Configuration du serveur et de son environnement de production.
install -d -m 0755 /etc/puppetlabs/puppet
cat > /etc/puppetlabs/puppet/puppet.conf <<'EOF'
[main]
certname = puppet-master.lab.local
server = puppet-master.lab.local
environment = production
runinterval = 30m

[server]
vardir = /opt/puppetlabs/server/data/puppetserver
logdir = /var/log/puppetlabs/puppetserver
rundir = /var/run/puppetlabs/puppetserver
pidfile = /var/run/puppetlabs/puppetserver/puppetserver.pid
codedir = /etc/puppetlabs/code
EOF

# Déploiement des manifests du dépôt partagé Vagrant.
install -d -m 0755 /etc/puppetlabs/code/environments/production
cp -a /vagrant/puppet/environments/production/. \
  /etc/puppetlabs/code/environments/production/

chown -R puppet:puppet /etc/puppetlabs/code
chmod -R u=rwX,g=rX,o=rX /etc/puppetlabs/code

systemctl enable puppetserver
systemctl restart puppetserver

echo
echo "Puppet Server installé."
echo "Vérification : /opt/puppetlabs/bin/puppetserver --version"
echo "Les demandes de certificats des agents devront être signées manuellement."
