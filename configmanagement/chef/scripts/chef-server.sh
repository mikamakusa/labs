#!/usr/bin/env bash
set -euo pipefail

SHARED=/vagrant/shared
mkdir -p "$SHARED"

if ! command -v chef-server-ctl >/dev/null; then
  curl -L https://omnitruck.chef.io/install.sh | bash -s -- -P chef-server
fi

chef-server-ctl reconfigure --chef-license accept
sleep 10

chef-server-ctl user-create admin Admin Lab admin@lab.local 'ChefLab123!' \
  --filename "$SHARED/admin.pem" || true
chef-server-ctl org-create lab "Chef Lab" \
  --association_user admin --filename "$SHARED/lab-validator.pem" || true
