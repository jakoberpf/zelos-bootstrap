#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Run terragrunt plan
cd $GIT_ROOT/terraform/$1
terragrunt plan
