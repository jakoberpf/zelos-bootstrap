#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

python -m venv $GIT_ROOT/.venv
source $GIT_ROOT/.venv/bin/activate
python -m pip install --upgrade pip
python -m pip install --upgrade ansible
ansible-galaxy install caddy_ansible.caddy_ansible.v3.1.0

# - verify docker install
# - verify vault install
# - verify cault install
# - setup terraform with tfenv
# - setup providers with `m1-terraform-provider-helper install <provider> -v <version>`
