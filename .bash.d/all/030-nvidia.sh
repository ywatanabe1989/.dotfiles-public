#!/bin/bash

alias ns='watch -d -n 0.5 nvidia-smi'

function cudav () {
    export CUDA_VISIBLE_DEVICES=$@
    export SINGULARITYENV_CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES
}
export CUDA_VISIBLE_DEVICES=0

## EOF
