#!/bin/bash

TARGET_FPATH='../src/dconf.txt'
dconf dump / > $TARGET_FPATH
echo "Dumped to $TARGET_FPATH"

## EOF
