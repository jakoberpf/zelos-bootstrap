#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Run terragrunt init
cd terraform
terragrunt init -upgrade
