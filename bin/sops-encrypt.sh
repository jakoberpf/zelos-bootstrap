#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

sops --encrypt terraform/backend.conf > terraform/backend.conf.enc
sops --encrypt terraform/terragrunt.json > terraform/terragrunt.json.enc
sops --encrypt terraform/variables.tfvars > terraform/variables.tfvars.enc

sops --encrypt .oci/fabian.pem > .oci/fabian.pem.enc
sops --encrypt .oci/jakob.pem > .oci/jakob.pem.enc
sops --encrypt .oci/tanja.pem > .oci/tanja.pem.enc
sops --encrypt .oci/tobias.pem > .oci/tobias.pem.enc
sops --encrypt .oci/ulrike.pem > .oci/ulrike.pem.enc

sops --encrypt .ssh/automation > .ssh/automation.enc
sops --encrypt .ssh/automation.pub > .ssh/automation.pub.enc
