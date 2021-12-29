#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# SSH Keys
mkdir -p "$GIT_ROOT/.ssh"
cd .ssh

vault2env CICD/global/ssh/automation .env
source .env

echo "$PRIVAT_KEY_OPENSSH_PEM" | base64 --decode >> automation
chmod 600 automation
echo "$PUBLIC_KEY_SSH" | base64 --decode >> automation.pub
chmod 600 automation.pub

rm .env

sd '<relative-path>' $GIT_ROOT config
