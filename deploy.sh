#!/bin/bash
# Script created on: 2024-06-15 18:42:12
# Script path: /home/ywatanabe/.dotfiles/deploy.sh

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
DOTFILES_DIR=~/.dotfiles/
HOME_DIR="$HOME"/
cd $DOTFILES_DIR && ls -al | grep ^.

skip_files=(
    ".git"
    ".gitignore"
    ".git-crypt"
    ".gitattributes"
    ".gittemplates"
    ".ssh"
)

dry_run () {
    local DRY_RUN=$1
    shift
    local command="$@"

    if [ "$DRY_RUN" = true ]; then
       echo -e "\n (Dry Run) $command"
    else
       echo -e "\n$command"
       eval "$command"
    fi
}

main () {
    NOW=`date +%Y-%m-%d-%H:%m`
    for f in .??*; do

        if [[ " ${skip_files[@]} " =~ " ${f} " ]]; then
            dry_run $DRY_RUN "skipping $f..."
            continue
        fi

        # Backup dotfiles in $HOME_DIR
        backup_command="mv -v "$HOME_DIR""$f" "$HOME_DIR""$f"_back_"$NOW""

        # Softlink from $DOTFILES_DIR to $HOME_DIR
        softlink_command="ln -snfv "$DOTFILES_DIR""$f" "$HOME_DIR""$f""

        # Runs the commands
        dry_run $DRY_RUN $backup_command
        dry_run $DRY_RUN $softlink_command

    done
}

main

dry_run $DRY_RUN chown -R ${USER}:$(id -gn) $DOTFILES_DIR
dry_run $DRY_RUN chmod -R 774 $DOTFILES_DIR

## EOF
