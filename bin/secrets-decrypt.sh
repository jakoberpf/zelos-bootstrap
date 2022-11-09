#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

sops --decrypt --input-type yaml --output-type yaml terraform/terragrunt.yaml.enc > terraform/terragrunt.yaml
sops --decrypt --input-type yaml --output-type yaml kubespray/kubespray.yaml.enc > kubespray/kubespray.yaml
sops --decrypt terraform/variables.tfvars.enc > terraform/variables.tfvars
