#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Run terraform apply
cd $GIT_ROOT/terraform/$1
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
