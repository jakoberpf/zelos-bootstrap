#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

mv $GIT_ROOT/terraform/generated.providers.tf $GIT_ROOT/terraform/generated.providers.tf.bak
find $GIT_ROOT/terraform -maxdepth 1 -name "*.tf" -exec checkov -f {} \;
mv $GIT_ROOT/terraform/generated.providers.tf.bak $GIT_ROOT/terraform/generated.providers.tf
