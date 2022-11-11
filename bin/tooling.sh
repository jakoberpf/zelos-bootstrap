#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

python -m venv .venv/terraform
source .venv/terraform/bin/activate
python -m pip install --upgrade pip
python -m pip install --upgrade checkov
python -m pip install --upgrade ansible==6.5.0
ansible-galaxy install caddy_ansible.caddy_ansible,v3.1.0 --force

python -m venv .venv/kubespray
source .venv/kubespray/bin/activate
python -m pip install --upgrade pip
python -m pip install --upgrade netaddr
python -m pip install --upgrade ansible==2.10.7