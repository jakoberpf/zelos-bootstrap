#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

sops --output-type json --decrypt terraform/terragrunt.json.enc > terraform/terragrunt.json
sops --decrypt terraform/terragrunt.yaml.enc > terraform/terragrunt.yaml
sops --decrypt terraform/variables.tfvars.enc > terraform/variables.tfvars

sops --decrypt .oci/fabian.pem.enc > .oci/fabian.pem
sops --decrypt .oci/jakob.pem.enc > .oci/jakob.pem
sops --decrypt .oci/tanja.pem.enc > .oci/tanja.pem
sops --decrypt .oci/tobias.pem.enc > .oci/tobias.pem
sops --decrypt .oci/ulrike.pem.enc > .oci/ulrike.pem

sops --decrypt .ssh/automation.enc > .ssh/automation
sops --decrypt .ssh/automation.pub.enc > .ssh/automation.pub
