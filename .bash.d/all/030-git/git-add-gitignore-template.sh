#!/usr/bin/env bash
# Script created on: 2024-06-24 16:48:14
# Script path: /home/ywatanabe/.dotfiles/.bash.d/all/030-git-add-gitignore-template.sh

git-add-gitignore-template() {
    local GITIGNORE_DEST="$PWD/.gitignore"
    local GITIGNORE_SRC_FILES=(
        "$HOME/.git-templates/.gitignore-templates/Custom/Specific.gitignore"
        "$HOME/.git-templates/.gitignore-templates/Custom/Secrets.gitignore"
        "$HOME/.git-templates/.gitignore-templates/Custom/LargeFiles.gitignore"
        "$HOME/.git-templates/.gitignore-templates/Custom/Development.gitignore"
        "$HOME/.git-templates/.gitignore-templates/Python.gitignore"
        "$HOME/.git-templates/.gitignore-templates/Custom/Singularity.gitignore"
        "$HOME/.git-templates/.gitignore-templates/TeX.gitignore"
        "$HOME/.git-templates/.gitignore-templates/Global/Emacs.gitignore"
    )

    # Ensure .gitignore exists
    if [[ ! -f "$GITIGNORE_DEST" ]]; then
        touch "$GITIGNORE_DEST"
        echo -e "\n.gitignore file was created at $GITIGNORE_DEST."
    else
        echo -e "\n.gitignore file already exists at $GITIGNORE_DEST."
    fi

    # Add the templates
    for GITIGNORE_SRC in "${GITIGNORE_SRC_FILES[@]}"; do
        local TAG="### Source: $GITIGNORE_SRC ###"

        # Check if the tag already exists in the .gitignore
        if ! grep -qF "$TAG" "$GITIGNORE_DEST"; then
            echo -e "\n$TAG\n$(cat "$GITIGNORE_SRC")" >> "$GITIGNORE_DEST"
            echo -e "\n$GITIGNORE_SRC has been added."
        else
            echo -e "\n$GITIGNORE_SRC is already included. Skipped."
        fi
    done

    # Create a .gitignore.strip file with whitespace removed
    sed 's/^[ \t]*//;s/[ \t]*$//' "$GITIGNORE_DEST" > "$GITIGNORE_DEST"_tmp
    # echo "Whitespace-stripped version created at $GITIGNORE_DEST"
    mv "$GITIGNORE_DEST"_tmp "$GITIGNORE_DEST"
}

# EOF
