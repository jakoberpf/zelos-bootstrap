#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Refine kubernetes admin config
config_file="kubespray/artifacts/admin.conf"
yq -i '.clusters[0].cluster.server = "https://api.zelos.k8s.erpf.de:6443"' $config_file
yq -i '.clusters[0].name = "erpf-zelos-live"' $config_file
yq -i '.contexts[0].context.cluster = "erpf-zelos-live"' $config_file
yq -i '.contexts[0].context.user = "admin"' $config_file
yq -i '.contexts[0].name = "erpf-zelos-live"' $config_file
yq -i '.current-context = "erpf-zelos-live"' $config_file
yq -i '.users[0].name = "admin"' $config_file

# Upload config to vault
vault_admin_config_base64="$(cat $config_file | base64)"
vault_last_modified=$(vault kv put CICD/repo/zelos-bootstrap/live/kube-secret admin_conf=$vault_admin_config_base64 | grep "create_time")
echo "vault: $vault_last_modified"

# Upload config to bucket
oci_credentials=$(yq e -o=j -I=0 ".oci" kubespray/kubespray.yaml)
oci_compartment_ocid=$(echo "${oci_credentials}" | yq '.compartment_ocid')
oci_namespace=$(oci os ns get --profile=KUBESPRAY | jq '.data' | xargs)
oci_bucket=$(oci os bucket list --profile=KUBESPRAY --compartment-id="$oci_compartment_ocid" | jq '.data[] | select(.name=="zelos")')
oci_last_modified=$(oci os object put --profile=KUBESPRAY -ns "$oci_namespace" -bn zelos --name kubespray/admin.live.conf --file $config_file --force)
echo "oci: $oci_last_modified"
