#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Source python tooling
source $GIT_ROOT/.venv/ansible/bin/activate

# Run ansible playbook
cd ansible
ansible-playbook -T 300 playbook.yml
