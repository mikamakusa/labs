#!/usr/bin/env bash
set -euo pipefail

echo "--------------------------------"
echo "Installation de Chef Workstation"
echo "--------------------------------"
if ! command -v chef >/dev/null; then
  curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chef-workstation
fi

mkdir -p ~/chef-repo/.chef ~/chef-repo/cookbooks ~/chef-repo/profiles
cd ~/chef-repo

echo "--------------------------------"
echo "Génération des clés de l'administrateur"
echo "--------------------------------"
for i in $(seq 1 60); do
  [ -f /vagrant/shared/admin.pem ] && break
  sleep 5
done
cp /vagrant/shared/admin.pem .chef/ 2>/dev/null || true

cat > .chef/config.rb <<CFG
current_dir = File.dirname(__FILE__)
node_name        "admin"
client_key       "#{current_dir}/admin.pem"
chef_server_url  "https://chef-server/organizations/lab"
cookbook_path    ["#{current_dir}/../cookbooks"]
CFG

cp /vagrant/scripts/bootstrap_nodes.sh ~/chef-repo/ && chmod +x ~/chef-repo/bootstrap_nodes.sh
grep -q CHEF_LICENSE ~/.bashrc || echo 'export CHEF_LICENSE=accept-silent' >> ~/.bashrc
