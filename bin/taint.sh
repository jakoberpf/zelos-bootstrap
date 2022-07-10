#!/usr/bin/env bash

set -eo pipefail

GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Run terraform apply
cd terraform
nodes+=$(terraform state list | grep oci_core_instance)
for node in ${nodes}; do
    terraform taint ${node}
done
cd $GIT_ROOT

