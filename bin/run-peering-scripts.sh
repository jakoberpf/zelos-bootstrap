#!/bin/bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

find $GIT_ROOT/terraform/$1/generated -name peering-\* -exec {} \;
