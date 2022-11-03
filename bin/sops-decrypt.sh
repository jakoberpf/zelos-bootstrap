#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

sops --decrypt terraform/backend.enc.conf > terraform/backend.conf

sops --decrypt .oci/fabian.enc.pem > .oci/fabian.pem
sops --decrypt .oci/jakob.enc.pem > .oci/jakob.pem
sops --decrypt .oci/tanja.enc.pem > .oci/tanja.pem
sops --decrypt .oci/tobias.enc.pem > .oci/tobias.pem
sops --decrypt .oci/ulrike.enc.pem > .oci/ulrike.pem
