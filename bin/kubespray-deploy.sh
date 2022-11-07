#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Run kubespray deployment
rm -rf .kubespray/inventory/*
mkdir -p .kubespray/inventory/zelos
cp -r kubespray/* .kubespray/inventory/zelos

# Source python tooling
source $GIT_ROOT/.venv/bin/activate

cd .kubespray && ansible-playbook --become --become-user=root \
  -i $GIT_ROOT/.kubespray/inventory/zelos/inventory.ini -b \
  --private-key $GIT_ROOT/.ssh/automation cluster.yml

# docker run --rm \
#   --mount type=bind,source="$GIT_ROOT"/kubespray,dst=/inventory \
#   --mount type=bind,source="$GIT_ROOT"/.ssh/automation,dst=/root/.ssh/id_rsa \
#   quay.io/kubespray/kubespray:v2.18.1 bash -c "ansible-playbook --become --become-user=root -i /inventory/inventory.ini -b --private-key /root/.ssh/id_rsa cluster.yml"
