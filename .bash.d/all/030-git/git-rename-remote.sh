#!/usr/bin/env bash
# Script created on: 2024-06-25 11:16:28
# Script path: /home/ywatanabe/.dotfiles/.bash.d/all/030-git/git-rename-remote.sh

git-rename-remote() {
    local old_name="$1"
    local new_name="$2"

    if [ -z "$old_name" ] || [ -z "$new_name" ]; then
        echo "Usage: git-rename-remote <old_name> <new_name>"
        return 1
    fi

    git remote rename "$old_name" "$new_name" # [REVISED]
}


git-rename-origin() {
    NEW_REPO_NAME="$1"
    git remote set-url origin $GITHUB_URL/$NEW_REPO_NAME.git
    git remote -v
    }

# EOF
