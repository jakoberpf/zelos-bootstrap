#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# get list of nodes
ids=$(yq '.oci[].id' terraform/terragrunt.yaml)
echo ${ids[-1]}

for i in $ids
do
    echo "Redeploying node-$i"
    ./bin/terraform-set-dynamic.sh -n $i

    # TODO run terraform to apply new dns
    # TODO drain node with timeout 60 kubectl drain --ignore-daemonsets --delete-emptydir-data "node-$i"
    # TODO run kubespray to remove node from cluster https://www.techbeatly.com/remove-nodes-from-kubespray-managed-kubernetes-cluster/
    # TODO run terraform taint module.node-$i.oci_core_instance.this to taint instance
    # TODO run terraform apply to recreate instance
    # TODO run kubespray to add node to cluster
done