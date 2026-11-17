#!/usr/bin/env bash
set -euo pipefail

MASTER_IP="$1"
MINION_ID="$2"

curl -fsSL https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh \
  -o /tmp/bootstrap-salt.sh

sh /tmp/bootstrap-salt.sh -A "$MASTER_IP" -i "$MINION_ID" stable

systemctl enable --now salt-minion