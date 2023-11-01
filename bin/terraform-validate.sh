#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Run terragrunt validate
cd terraform/$1
terragrunt validate
