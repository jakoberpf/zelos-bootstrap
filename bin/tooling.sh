#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

python3 -m venv .venv/terraform
python3 -m venv .venv/ansible
python3 -m venv .venv/kubespray

source .venv/terraform/bin/activate
python -m pip install --upgrade pip
python -m pip install --upgrade checkov

source .venv/ansible/bin/activate
python -m pip install --upgrade pip
python -m pip install --upgrade ansible

source .venv/kubespray/bin/activate
python -m pip install --upgrade pip
python -m pip install --upgrade netaddr==0.7.19
python -m pip install --upgrade jmespath==0.9.5
python -m pip install --upgrade ansible==5.7.1
python -m pip install --upgrade ansible-core==2.12.5
