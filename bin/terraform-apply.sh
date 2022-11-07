#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Source python tooling
source $GIT_ROOT/.venv/terraform/bin/activate

# Run terraform apply
cd terraform
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
  terragrunt apply -auto-approve
fi

cd $GIT_ROOT
