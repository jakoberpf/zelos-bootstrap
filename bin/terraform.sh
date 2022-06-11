#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Run terraform apply
cd $GIT_ROOT/terraform
terragrunt init -backend-config=backend.conf -upgrade

if [[ $* == *--loop* ]]; then
  start=`date +%s`
  until terraform apply -var-file="variables.tfvars" -auto-approve
  do
    now=`date +%s`
    runtime=$((now-start))
    echo "Error during apply. OCI Hosts possibly out of capacity. Try again... (running for $runtime)"
  done
else
  terraform apply -var-file="variables.tfvars"
fi

cd $GIT_ROOT
