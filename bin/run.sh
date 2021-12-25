#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Setup secrets
# ./vault.sh

# Run terraform apply
cd $GIT_ROOT/terraform
terraform apply -var-file="variables.tfvars"
cd $GIT_ROOT

# Run kubespray deployment
docker run --rm -it \
  --mount type=bind,source="$GIT_ROOT"/kubespray/inventory/zelos,dst=/inventory \
  --mount type=bind,source="$GIT_ROOT"/.ssh/automation.openssh.pem,dst=/root/.ssh/id_rsa \
  quay.io/kubespray/kubespray:v2.17.1 bash -c "ansible-playbook -i /inventory/inventory.ini -b --private-key /root/.ssh/id_rsa cluster.yml"

# Push kubernetes admin config to vault
admin_conf="$(cat kubespray/inventory/zelos/artifacts/admin.conf | base64)"
# vault kv put CICD/repo/zelos-bootstrap/live/kube-secret admin_conf=$admin_conf