#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Refine kubernetes admin config
config_file="ansible/artifacts/k3s-$1.yaml"
cluster_endpoint="https://api.$1.zelos.k8s.erpf.de:6443"
ENDPOINT=${cluster_endpoint} yq -i '.clusters[0].cluster.server = env(ENDPOINT)' $config_file
NAME="erpf-zelos-$1" yq -i '.clusters[0].name = env(NAME)' $config_file
NAME="erpf-zelos-$1" yq -i '.contexts[0].context.cluster = env(NAME)' $config_file
NAME="erpf-zelos-$1" yq -i '.contexts[0].name = env(NAME)' $config_file
NAME="erpf-zelos-$1" yq -i '.current-context = env(NAME)' $config_file
yq -i '.contexts[0].context.user = "admin"' $config_file
yq -i '.users[0].name = "admin"' $config_file

# Upload config to vault
vault_admin_config_base64="$(cat $config_file | base64)"
vault kv put kubernetes-configs/zelos/$1/admin k3s.yaml=$vault_admin_config_base64 | grep "create_time"
