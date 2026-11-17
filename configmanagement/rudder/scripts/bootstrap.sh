#!/usr/bin/env bash
set -euo pipefail

ROLE="${1:?role manquant (server|agent)}"
NODE_NAME="${2:?nom de machine manquant}"
RUDDER_VERSION="${RUDDER_VERSION:-9.2}"
SERVER_NAME="rudder-server"
SERVER_IP="192.168.56.10"

export DEBIAN_FRONTEND=noninteractive

echo "[${NODE_NAME}] Configuration de base"
hostnamectl set-hostname "${NODE_NAME}"

echo "--------------------------------"
echo "Résolution stable entre les six machines, sans dépendre d'un DNS local."
echo "--------------------------------"
if ! grep -qE "[[:space:]]${SERVER_NAME}([[:space:]]|$)" /etc/hosts; then
  cat >> /etc/hosts <<EOF
${SERVER_IP} ${SERVER_NAME} ${SERVER_NAME}.lab.local
192.168.56.11 rudder-node-01
192.168.56.12 rudder-node-02
192.168.56.13 rudder-node-03
192.168.56.14 rudder-node-04
192.168.56.15 rudder-node-05
EOF
fi

echo "--------------------------------"
echo "Mise à jour des paquets"
echo "--------------------------------"
apt-get update
apt-get install -y curl wget ca-certificates gnupg lsb-release apt-transport-https

echo "--------------------------------"
echo "Installation du serveur Rudder ${RUDDER_VERSION}"
echo "--------------------------------"
if [[ "${ROLE}" == "server" ]]; then
  echo "[${NODE_NAME}] Installation du serveur Rudder ${RUDDER_VERSION}"
  curl -fsSL https://repository.rudder.io/tools/rudder-setup \
    -o /usr/local/sbin/rudder-setup
  chmod 0755 /usr/local/sbin/rudder-setup
  /usr/local/sbin/rudder-setup setup-server "${RUDDER_VERSION}"

  echo "[${NODE_NAME}] Serveur installé. Vérifier l'interface et terminer l'assistant initial."
  echo "URL depuis l'hôte : https://localhost:8443/rudder/"
elif [[ "${ROLE}" == "agent" ]]; then
  echo "[${NODE_NAME}] Attente du serveur Rudder"
  for attempt in $(seq 1 60); do
    if timeout 2 bash -c ":</dev/tcp/${SERVER_IP}/443" >/dev/null 2>&1; then
      break
    fi
    sleep 10
  done

  echo "--------------------------------"
  echo "Installation de l'agent Rudder ${RUDDER_VERSION}"
  echo "--------------------------------"
  echo "[${NODE_NAME}] Installation de l'agent Rudder ${RUDDER_VERSION}"
  curl -fsSL https://repository.rudder.io/tools/rudder-setup \
    -o /usr/local/sbin/rudder-setup
  chmod 0755 /usr/local/sbin/rudder-setup
  /usr/local/sbin/rudder-setup setup-agent "${RUDDER_VERSION}" "${SERVER_NAME}"

  echo "--------------------------------"
  echo "Activation et démarrage de l'agent Rudder"
  echo "--------------------------------"
  systemctl enable --now rudder-agent
  echo "[${NODE_NAME}] Agent installé. Il devra être accepté depuis l'interface Rudder."
else
  echo "Rôle inconnu : ${ROLE}" >&2
  exit 2
fi
