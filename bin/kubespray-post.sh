#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Push kubernetes admin config to vault
config_file="kubespray/artifacts/admin.conf"
yq -i '.clusters[0].cluster.server = "https://api.zelos.k8s.erpf.de:6443"' $config_file
yq -i '.clusters[0].name = "erpf-zelos-live"' $config_file
yq -i '.contexts[0].context.cluster = "erpf-zelos-live"' $config_file
yq -i '.contexts[0].context.user = "admin"' $config_file
yq -i '.contexts[0].name = "erpf-zelos-live"' $config_file
yq -i '.current-context = "erpf-zelos-live"' $config_file
yq -i '.users[0].name = "admin"' $config_file
admin_conf="$(cat $config_file | base64)"
vault kv put CICD/repo/zelos-bootstrap/live/kube-secret admin_conf=$admin_conf
