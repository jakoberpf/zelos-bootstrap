#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

sops --encrypt --input-type yaml --output-type yaml terraform/blue/terragrunt.yaml > terraform/blue/terragrunt.yaml.enc
