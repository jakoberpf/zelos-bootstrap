#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

sops --encrypt terraform/backend.conf > terraform/backend.enc.conf
sops --encrypt terraform/terragrunt.json > terraform/terragrunt.enc.json
sops --encrypt terraform/variables.tfvars > terraform/variables.enc.tfvars

sops --encrypt .oci/fabian.pem > .oci/fabian.enc.pem
sops --encrypt .oci/jakob.pem > .oci/jakob.enc.pem
sops --encrypt .oci/tanja.pem > .oci/tanja.enc.pem
sops --encrypt .oci/tobias.pem > .oci/tobias.enc.pem
sops --encrypt .oci/ulrike.pem > .oci/ulrike.enc.pem
