#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Run terraform apply
cd $GIT_ROOT/terraform
terraform init -upgrade
terraform apply -var-file="variables.tfvars"
cd $GIT_ROOT
