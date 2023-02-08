#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

python3 -m venv .venv/terraform
python3 -m venv .venv/ansible
python3 -m venv .venv/kubespray

source .venv/terraform/bin/activate
python -m pip install --upgrade pip
python -m pip install --upgrade checkov
python -m pip install --upgrade ansible==6.5.0
ansible-galaxy install caddy_ansible.caddy_ansible,v3.1.0 --force

source .venv/ansible/bin/activate
python -m pip install --upgrade pip
python -m pip install --upgrade ansible==6.5.0

source .venv/kubespray/bin/activate
python -m pip install --upgrade pip
python -m pip install --upgrade netaddr
python -m pip install --upgrade ansible==2.10.7