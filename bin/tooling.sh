#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

python3 -m venv .venv/ansible

source .venv/ansible/bin/activate
python -m pip3 install -r requirements.txt
