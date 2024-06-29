#!/bin/bash
# Script created on: 2024-06-22 11:53:47
# Script path: /home/ywatanabe/.dotfiles/.bash.d/all/030-dry-run.sh

dry-run () {
    local DRY-RUN=$1
    shift
    local command="$@"

    if [ "$DRY-RUN" = true ]; then
       echo -e "\n (Dry Run) $command"
    else
       echo -e "\n$command"
       eval "$command"
    fi
}

# EOF
