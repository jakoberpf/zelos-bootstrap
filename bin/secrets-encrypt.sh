#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Terragrunt / Terraform
sops --encrypt --input-type yaml --output-type yaml $GIT_ROOT/terraform/$1/terragrunt.yaml > $GIT_ROOT/terraform/$1/terragrunt.yaml.enc

# Ansible
sops --encrypt --input-type txt --output-type txt $GIT_ROOT/ansible/inventory/$1/.vault_pass > $GIT_ROOT/ansible/inventory/$1/.vault_pass.enc
