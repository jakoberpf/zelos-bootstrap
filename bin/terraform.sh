#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Source python tooling
source $GIT_ROOT/.venv/bin/activate

# Run terraform apply
cd $GIT_ROOT/terraform
terragrunt init -upgrade

if [[ $* == *--loop* ]]; then
  start=`date +%s`
  until terragrunt apply -auto-approve # | grep -q 'Out of host capacity'
  do
    now=`date +%s`
    runtime=$((now-start))
    echo "Error during apply. OCI Hosts possibly out of capacity. Try again... (running for $runtime s)"
    sleep 10
  done
else
  terragrunt apply
fi

cd $GIT_ROOT
