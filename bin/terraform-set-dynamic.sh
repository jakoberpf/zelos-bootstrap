#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

print_usage() {
  echo "Usage: -n <node-name>"
}

# get list of nodes
read -a ids <<< $(yq '.oci[].id' terraform/terragrunt.yaml | xargs)
nodename=${ids[0]}

while getopts 'n:' flag; do
  case "${flag}" in
    n) nodename=${OPTARG};;
    *) print_usage && exit 1;;
  esac
done

echo "Setting apiNode to ${nodename}"

nodename="node-$nodename" yq -i '.dns.apiNode = env(nodename)' terraform/dynamic.yaml
