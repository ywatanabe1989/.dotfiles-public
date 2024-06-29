#!/usr/bin/env bash
# Script created on: 2024-06-24 19:07:33
# Script path: /home/ywatanabe/.dotfiles/.bash.d/all/030-git/git-advanced.sh

git-unstage() {
    # Check if any arguments were provided
    if [ $# -eq 0 ]; then
        echo "Usage: git-unstage <file1> <file2> ..."
        echo "Error: No file specified to unstage."
        return 1
    fi

    # Unstage files specified in the arguments
    git restore --staged "$@"
}

git-untrack() {
    # Check if any arguments were provided
    if [ $# -eq 0 ]; then
        echo "Usage: git-untrack <file1> <directory1> ..."
        echo "Error: No file or directory specified to untrack."
        return 1
    fi

    # Untrack the files or directories specified in the arguments
    git rm --cached -r "$@"
    echo "Files and directories have been untracked but kept locally."

    # Optionally, automatically add these paths to .gitignore
    for path in "$@"; do
        echo "$path" >> .gitignore
    done
    echo "Untracked paths have been added to .gitignore."

    git add .gitignore
    git commit -m "Updated .gitignore with untracked paths"
}

git-find-large-files() {
    # Set the threshold size for large files
    local size_threshold=${1:-100M}

    # Find large files in the entire history of the repo
    git rev-list --objects --all |
        git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
        sed -n 's/^blob //p' |
        sort --numeric-sort --key=2 |
        cut -c 1-12,41- |
        $(command -v gnumfmt || echo numfmt) --to=iec-i --suffix=B --padding=7 --field=2 |
        awk -v threshold="$size_threshold" '$2+0 >= threshold+0 {print $2 "\t" $1}' |
        sort --human-numeric-sort --key=1
}

git-rm-eternal() {
    local fpath=$1
    read -p "Are you sure you want to remove $fpath from Git? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        # Temporarily stash other changes to ensure we don't commit them
        git stash push --keep-index

        # Remove the file from the current index (staging area)
        git rm -r --cached $fpath
        git commit -m "Stop tracking $fpath"

        # Remove the file from the entire history
        git filter-branch --force --index-filter \
            "git rm -r --cached --ignore-unmatch $fpath" \
            --prune-empty --tag-name-filter cat -- --all

        # Check if there are any stashed changes before popping
        if git stash list | grep -q 'stash@{0}'; then
            # Pop the stashed changes back
            git stash pop
        fi
    fi
}



# EOF
