#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Source python tooling
# source $GIT_ROOT/.venv/ansible/bin/activate

# Copy generated inventory
cp terraform/$1/generated/inventory.ini ansible/inventory/$1/inventory.ini

# Run ansible playbook
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ansible/playbook.yml -i ansible/inventory/$1/inventory.ini
