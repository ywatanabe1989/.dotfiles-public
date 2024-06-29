#!/bin/bash

SRC_FPATH='../src/dconf.txt'
dconf load / < $SRC_FPATH
echo "Loaded from $SRC_FPATH"

## EOF
