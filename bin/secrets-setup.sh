#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

mkdir -p .ssh
echo -e $(yq e -o=j -I=0 '.ssh.private_key' terraform/terragrunt.yaml | tr -d '"') > .ssh/automation
chmod 600 .ssh/automation
