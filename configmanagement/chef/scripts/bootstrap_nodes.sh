#!/usr/bin/env bash
set -euo pipefail

echo "--------------------------------"
echo "Bootstrap des noeuds"
echo "--------------------------------"
set -euo pipefail
cd ~/chef-repo
export CHEF_LICENSE=accept-silent

knife ssl fetch
for n in web1 web2 app1 db1; do
  knife bootstrap "$n" \
    --connection-user vagrant --connection-password vagrant \
    --sudo --node-name "$n" --yes
done
knife node list
