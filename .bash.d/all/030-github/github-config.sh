#!/usr/bin/env bash
# Script created on: 2024-06-25 11:15:13
# Script path: /home/ywatanabe/.dotfiles/.bash.d/all/030-github/github-config.sh

# sudo apt install -y gitsome
if type gh > /dev/null 2>&1; then
    gh config set pager more > /dev/null
fi

# EOF
