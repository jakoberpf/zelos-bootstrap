#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# get list of nodes
ids=$(yq '.oci[].id' terraform/terragrunt.yaml)
echo ${ids[-1]}

for i in $ids
do
    echo "Redeploying node-$i"
    $GIT_ROOT/bin/terraform-set-dynamic.sh -n $i
    # $GIT_ROOT/bin/terraform-apply.sh --loop
    # timeout 60 kubectl drain --ignore-daemonsets --delete-emptydir-data "node-$i"
    # timeout 120 $GIT_ROOT/bin/kubespray-remove-node.sh "node-$i"
    # timeout 60 kubectl delete node "node-$i"
    # cd terraform && terraform taint module.node-$i.oci_core_instance.this && cd ../
    # $GIT_ROOT/bin/terraform-apply.sh --loop
    # sleep 120
    # $GIT_ROOT/bin/ansible-playbook.sh
    # $GIT_ROOT/bin/kubespray-deploy.sh
done