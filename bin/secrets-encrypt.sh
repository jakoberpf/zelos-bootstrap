#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

sops --encrypt --input-type yaml --output-type yaml terraform/terragrunt.yaml > terraform/terragrunt.yaml.enc
sops --encrypt --input-type yaml --output-type yaml kubespray/kubespray.yaml > kubespray/kubespray.yaml.enc
