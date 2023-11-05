#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Terragrunt / Terraform
sops --decrypt --input-type yaml --output-type yaml $GIT_ROOT/terraform/$1/terragrunt.yaml.enc > $GIT_ROOT/terraform/$1/terragrunt.yaml

# Ansible
sops --decrypt --input-type txt --output-type txt $GIT_ROOT/ansible/inventory/$1/.vault_pass.enc > $GIT_ROOT/ansible/inventory/$1/.vault_pass
