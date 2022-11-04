#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

sops --decrypt terraform/backend.conf.enc > terraform/backend.conf
sops --output-type json --decrypt terraform/terragrunt.json.enc > terraform/terragrunt.json
sops --decrypt terraform/variables.tfvars.enc > terraform/variables.tfvars

sops --decrypt .oci/fabian.pem.enc > .oci/fabian.pem
sops --decrypt .oci/jakob.pem.enc > .oci/jakob.pem
sops --decrypt .oci/tanja.pem.enc > .oci/tanja.pem
sops --decrypt .oci/tobias.pem.enc > .oci/tobias.pem
sops --decrypt .oci/ulrike.pem.enc > .oci/ulrike.pem

sops --encrypt .ssh/automation.enc > .ssh/automation
sops --encrypt .ssh/automation.pub.enc > .ssh/automation.pub
