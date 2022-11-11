#!/bin/bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

find $GIT_ROOT/bin/generated -name peering-\* -exec {} \;
