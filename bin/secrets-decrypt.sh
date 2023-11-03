#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

sops --decrypt --input-type yaml --output-type yaml terraform/blue/terragrunt.yaml.enc > terraform/blue/terragrunt.yaml
