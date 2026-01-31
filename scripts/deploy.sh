#!/bin/bash
# -*- coding: utf-8 -*-
# Timestamp: "2025-05-07 20:37:11 (ywatanabe)"
# File: scripts/deploy.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
SRC_DIR="$DOTFILES_DIR/src"
LOG_PATH="$DOTFILES_DIR/logs/deploy.log"
mkdir -p "$(dirname "$LOG_PATH")"
touch "$LOG_PATH" >/dev/null 2>&1

DRY_RUN=true

usage() {
    echo "Usage: $0 [-r]"
    echo "  -r    Run mode. Otherwise, commands will be dry-run."
    exit 1
}

while getopts ":r" opt; do
    case $opt in
    r)
        DRY_RUN=false
        ;;
    \?)
        usage
        ;;
    esac
done

# Parameters
HOME_DIR="$HOME"

skip_files=(
    ".git"
    ".gitignore"
    ".git-crypt"
    ".gitattributes"
    ".gittemplates"
    ".ssh"
)

is_skipped() {
    local file="$1"
    for skip in "${skip_files[@]}"; do
        [[ "$file" == "$skip" ]] && return 0
    done
    return 1
}

dry_run() {
    local dry="$1"
    shift
    local cmd="$*"

    if [ "$dry" = true ]; then
        echo -e "\n (Dry Run) $cmd"
    else
        echo -e "\n$cmd"
        eval "$cmd"
    fi
}

main() {
    NOW=$(date +%Y-%m-%d-%H:%M)
    cd "$SRC_DIR" || exit 1

    for f in .??*; do
        if is_skipped "$f"; then
            dry_run "$DRY_RUN" "skipping $f..."
            continue
        fi

        # Backup dotfiles in HOME_DIR
        backup_command="mv -v '${HOME_DIR}/${f}' '${HOME_DIR}/${f}_back_${NOW}'"

        # Softlink from SRC_DIR to HOME_DIR
        softlink_command="ln -snfv '${SRC_DIR}/${f}' '${HOME_DIR}/${f}'"

        # Runs the commands
        dry_run "$DRY_RUN" "$backup_command"
        dry_run "$DRY_RUN" "$softlink_command"
    done
}

main

dry_run "$DRY_RUN" "ln -snfv '${DOTFILES_DIR}/.claude-settings.json' '${HOME_DIR}/.claude/settings.json'"
dry_run "$DRY_RUN" "chown -R '${USER}:$(id -gn)' '$DOTFILES_DIR'"
dry_run "$DRY_RUN" "chmod -R 774 '$DOTFILES_DIR'"

# EOF
