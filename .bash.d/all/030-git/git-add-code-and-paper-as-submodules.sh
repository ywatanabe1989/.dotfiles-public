#!/usr/bin/env bash
# Script created on: 2024-06-25 00:02:22
# Script path: /home/ywatanabe/.dotfiles/.bash.d/all/030-git/git-add-code-and-paper-as-submodules.sh

git-add-code-and-paper-as-submodules() {
    # Get the main repo URL
    MAIN_REPO=$(git remote get-url origin)

    # Replace .git with -code.git and -paper.git
    CODE_REPO=${MAIN_REPO/.git/-code.git}
    PAPER_REPO=${MAIN_REPO/.git/-paper.git}

    # Add submodules
    git submodule add "$CODE_REPO" code
    git submodule add "$PAPER_REPO" paper

    # Commit changes
    git add .
    git commit -m "Add code and paper submodules"
}

# EOF
