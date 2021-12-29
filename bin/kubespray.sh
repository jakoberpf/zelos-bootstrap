#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# https://serverfault.com/questions/532559/bash-script-count-down-5-minutes-display-on-single-line
# secs=$((2 * 60))
# while [ $secs -gt 0 ]; do
#    echo -ne "$secs\033[0K\r"
#    sleep 1
#    : $((secs--))
# done

# Run kubespray deployment
docker run --rm -it \
  --mount type=bind,source="$GIT_ROOT"/kubespray/inventory/zelos,dst=/inventory \
  --mount type=bind,source="$GIT_ROOT"/.ssh/automation,dst=/root/.ssh/id_rsa \
  quay.io/kubespray/kubespray:v2.17.1 bash -c "ansible-playbook -i /inventory/inventory.ini -b --private-key /root/.ssh/id_rsa cluster.yml"

# Push kubernetes admin config to vault
domain_name="api.zelos.k8s.infra.erpf.de"
domain_url="https:\/\/$domain_name:6443"
sed -i "" "/^\([[:space:]]*server: \).*/s//\1$domain_url/" kubespray/inventory/zelos/artifacts/admin.conf
admin_conf="$(cat kubespray/inventory/zelos/artifacts/admin.conf | base64)"
vault kv put CICD/repo/zelos-bootstrap/live/kube-secret admin_conf=$admin_conf