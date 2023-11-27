#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Run terragrunt init
cd $GIT_ROOT/terraform/$1
terragrunt init -upgrade
