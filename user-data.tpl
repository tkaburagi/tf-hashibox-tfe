#!/bin/bash

# create replicated unattended installer config
cat > /etc/replicated.conf <<EOF
{
  "DaemonAuthenticationType": "password",
  "DaemonAuthenticationPassword": "ptfe-pwd",
  "TlsBootstrapType": "self-signed",
  "LogLevel": "debug",
  "ImportSettingsFrom": "/tmp/replicated-settings.json",
  "LicenseFileLocation": "/tmp/license.rli"
  "BypassPreflightChecks": true
}
EOF
cat > /tmp/replicated-settings.json <<EOF
{
  "hostname": {
    "value": "res-ptfe.hashicorp.fun"
  }
  "installation_type": {
    "value": "production"
  },
  "production_type": {
    "value": "disk"
  },
  "disk_path": {
    "value": "/data"
  },
  "letsencrypt_auto": {
    "value": "1"
  },
  "letsencrypt_email": {
    "value": "null@null.com"
  },
}
EOF


#!/usr/bin/env bash
set -e

echo "==> Base"

function ssh-apt {
  sudo DEBIAN_FRONTEND=noninteractive apt-get -yqq \
    --allow-downgrades \
    --allow-remove-essential \
    --allow-change-held-packages \
    -o Dpkg::Use-Pty=0 \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" \
    "$@"
}

echo "--> Adding helper for IP retrieval"
sudo tee /etc/profile.d/ips.sh > /dev/null <<EOF
function private_ip {
  curl -s http://169.254.169.254/latest/meta-data/local-ipv4
}

function public_ip {
  curl -s http://169.254.169.254/latest/meta-data/public-ipv4
}
EOF
source /etc/profile.d/ips.sh

echo "--> Updating apt-cache"
ssh-apt update



echo "--> Installing common dependencies"
ssh-apt install \
  build-essential \
  curl \
  emacs \
  git \
  jq \
  tmux \
  unzip \
  vim \
  wget \
  tree \
  sudo apt-get -y update
  &>/dev/null

echo "--> Installing git secrets"
git clone https://github.com/awslabs/git-secrets
cd git-secrets
sudo make install
cd -
rm -rf git-secrets

echo "--> Disabling checkpoint"
sudo tee /etc/profile.d/checkpoint.sh > /dev/null <<"EOF"
export CHECKPOINT_DISABLE=1
EOF
source /etc/profile.d/checkpoint.sh

echo "--> Setting hostname..."
echo "res-ptfe.hashicorp.fun" | sudo tee /etc/hostname
sudo hostname -F /etc/hostname

echo "--> Adding hostname to /etc/hosts"
sudo tee -a /etc/hosts > /dev/null <<EOF

# For local resolution
$(private_ip)  res-ptfe.hashicorp.fun
EOF

echo "==> Base is done!"


#!/bin/bash
sudo curl https://install.terraform.io/ptfe/beta > /home/ubuntu/install.sh
sudo bash /home/ubuntu/install.sh no-proxy


#!/usr/bin/env bash
set -e

# Trap the reboot as an exit, because the script has to return 0 or else
# Terraform will think it failed.
function reboot {
  sudo systemctl reboot
}

trap reboot EXIT

echo "==> Rebooting"
