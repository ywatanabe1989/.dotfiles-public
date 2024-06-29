#!/usr/bin/env bash
# Script created on: 2024-06-24 19:08:06
# Script path: /home/ywatanabe/.dotfiles/.bash.d/all/030-git/git-download-dir.sh

git-download-dir() {
    # Example
    # $ git-download-dir https://github.com/ywatanabe1989/singularity_template/tree/main/factory/modules

    ORIG_DIR=$PWD

    if [ $# -ne 1 ]; then
        echo "Usage: git-download-dir <repository-url-with-path>"
        return 1
    fi

    full_url=$1

    # Extract repository URL and directory path
    repo_url=$(echo $full_url | cut -d'/' -f1-5)
    dir_path=$(echo $full_url | cut -d'/' -f6- | sed 's/tree\/[^\/]*\///')

    temp_dir=$(mktemp -d)
    cd "$temp_dir"

    git init
    git remote add origin "$repo_url"
    git config core.sparseCheckout true
    echo "$dir_path/*" > .git/info/sparse-checkout

    # Determine the branch name from the URL
    branch=$(echo $full_url | sed -n 's/.*tree\/\([^\/]*\)\/.*/\1/p')
    if [ -z "$branch" ]; then
        branch="main"  # Default to 'main' if branch is not specified
    fi

    git pull origin "$branch"

    if [ -d "$dir_path" ]; then
        mv "$dir_path" "$ORIG_DIR/"
        cd "$ORIG_DIR"
        rm -rf "$temp_dir"
        echo "Directory '$dir_path' has been downloaded successfully to $ORIG_DIR."
    else
        cd "$ORIG_DIR"
        rm -rf "$temp_dir"
        echo "Directory '$dir_path' not found in the repository."
        return 1
    fi
}

# EOF
