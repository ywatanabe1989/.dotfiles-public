#!/bin/bash
# -*- coding: utf-8 -*-
# Timestamp: "2025-05-26 06:37:48 (ywatanabe)"
# File: /home/ywatanabe/.dotfiles/.bash_profile

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# ---------------------------------------

if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

DIR_STACK=() # for cd tracing

# Source Rust's cargo environment if it exists
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

source $HOME/.dotfiles/src/.bash.d/all/000_bash_reload_bashd.src
reload_bashd

### scd start ###
if [ -z $NO_SCD ]; then
    if [ -d /home/ywatanabe/proj/mngs_repo ]; then
        cd /home/ywatanabe/proj/mngs_repo
    fi
fi

if [ -f env/bin/activate ]; then
    source env/bin/activate
fi
### scd end ###

# EOF