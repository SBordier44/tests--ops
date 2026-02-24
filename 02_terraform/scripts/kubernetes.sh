#!/bin/bash
set -euo pipefail

# EC2 Instance Metadata
TOKEN="$(curl -sX PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" || true)"
HDR=()
if [ -n "${TOKEN}" ]; then
  HDR=(-H "X-aws-ec2-metadata-token: ${TOKEN}")
fi

PUBLIC_IP="$(curl -s "${HDR[@]}" http://169.254.169.254/latest/meta-data/public-ipv4 || true)"
PUBLIC_DNS="$(curl -s "${HDR[@]}" http://169.254.169.254/latest/meta-data/public-hostname || true)"
PRIVATE_IP="$(curl -s "${HDR[@]}" http://169.254.169.254/latest/meta-data/local-ipv4 || true)"

echo "PUBLIC_IP=${PUBLIC_IP}"
echo "PUBLIC_DNS=${PUBLIC_DNS}"
echo "PRIVATE_IP=${PRIVATE_IP}"

sudo apt-get update && apt-get dist-upgrade -y
sudo apt-get install -y curl wget git ca-certificates
sudo mkdir -p /etc/rancher/k3s
sudo tee /etc/rancher/k3s/config.yaml >/dev/null <<EOF
disable:
  - traefik
write-kubeconfig-mode: "0644"
tls-san:
  - ${PUBLIC_IP}
  - ${PUBLIC_DNS}
  - ${PRIVATE_IP}
  - 127.0.0.1
  - localhost
EOF

curl -sfL https://get.k3s.io | sudo sh -
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
