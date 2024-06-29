#!/bin/bash

parse_args() {
    local OPTIND
    TARGET_DIR="."
    while getopts ":t:" opt; do
        case $opt in
            t) TARGET_DIR="$OPTARG"
               ;;
            \?) echo "Invalid option -$OPTARG" >&2
               return 1
               ;;
        esac
    done
    shift $((OPTIND-1))
    ARGS=("$@")
}

gh-delete() {
    parse_args "$@"
    (
        cd "$TARGET_DIR" || exit
        gh repo delete
    )
}

gh-login() {
    gh auth login
}

gh-login-token() {
    gh auth login --with-token < $HOME/.bash.d/secrets/access-tokens/github.txt
}

gh-logout() {
    gh auth logout
}

gh-view() {
    parse_args "$@"
    (
        cd "$TARGET_DIR" || exit
        gh repo view | sed 's/\x1b\[[0-9;]*[mGKH]//g'
    )
}

# gh-add-remote() {
#     # Example: gh-add-remote origin ripple-wm-code
#     local remote_name="$1"
#     local repo_name="$2"

#     if [ -z "$remote_name" ] || [ -z "$repo_name" ]; then
#         echo "Usage: gh-add-remote <remote_name> <repo_name>"
#         echo "Example: gh-add-remote origin user/repo"
#         return 1
#     fi

#     # Get the authenticated user
#     local user=$(gh api user -q .login)
#     if [ -z "$user" ]; then
#         echo "Error: Not authenticated. Please run gh-login first."
#         return 1
#     fi

#     # If the repo_name doesn't include a '/', prepend the authenticated user
#     if [[ "$repo_name" != *"/"* ]]; then
#         repo_name="${user}/${repo_name}"
#     fi

#     # Add the remote
#     git remote add "$remote_name" "git@github.com:${repo_name}.git"

#     if [ $? -eq 0 ]; then
#         echo "Remote '$remote_name' added successfully for repository '$repo_name'."
#     else
#         echo "Failed to add remote '$remote_name' for repository '$repo_name'."
#         return 1
#     fi

#     git remote -v
# }

gh-add-remote() {
    # Example: gh-add-remote origin ripple-wm-code
    local remote_name="$1"
    local repo_name="$2"

    if [ -z "$remote_name" ] || [ -z "$repo_name" ]; then
        echo "Usage: gh-add-remote <remote_name> <repo_name>"
        echo "Example: gh-add-remote origin user/repo"
        return 1
    fi

    # Get the authenticated user
    local user=$(gh api user -q .login)
    if [ -z "$user" ]; then
        echo "Error: Not authenticated. Please run gh-login first."
        return 1
    fi

    # If the repo_name doesn't include a '/', prepend the authenticated user
    if [[ "$repo_name" != *"/"* ]]; then
        repo_name="${user}/${repo_name}"
    fi

    # Check if the remote already exists
    if git remote get-url "$remote_name" &>/dev/null; then
        local existing_url=$(git remote get-url "$remote_name")
        read -p "Remote '$remote_name' already exists ($existing_url). Do you want to override it? (y/N): " confirm
        if [[ $confirm != [yY] ]]; then
            echo "Operation cancelled."
            return 1
        fi
        git remote remove "$remote_name"
    fi

    # Add the remote
    git remote add "$remote_name" "git@github.com:${repo_name}.git"

    if [ $? -eq 0 ]; then
        echo "Remote '$remote_name' added successfully for repository '$repo_name'."
    else
        echo "Failed to add remote '$remote_name' for repository '$repo_name'."
        return 1
    fi

    git remote -v
}

gh-create() {
    parse_args "$@"
    (
        cd "$TARGET_DIR" || exit
        gh repo create
    )
}

gh-rename() {
    parse_args "$@"
    (
        cd "$TARGET_DIR" || exit
        gh repo rename
    )
}

gh-clone() {
    parse_args "$@"
    REPOSITORY_NAME=${POSITIONAL_ARGS[0]}
    if [ -z "$REPOSITORY_NAME" ]; then
        echo "Error: Repository name is required."
        return 1
    fi
    (
        cd "$TARGET_DIR" || exit
        gh repo clone "$GITHUB_URL/$REPOSITORY_NAME.git"
    )
}

# gh-upgrade() {
#     -gh-upgrade-ubuntu() {
#         sudo apt update
#         sudo apt install gh
#     }

#     if-os "ubuntu" -gh-upgrade-ubuntu
# }


# alias gh-delete='gh repo delete'
# alias gh-login='gh auth login'
# alias gh-logout='gh auth logout'

# gh-view() {
#   gh repo view "$@" | sed 's/\x1b\[[0-9;]*[mGKH]//g'
# }

# alias gh-create='gh repo create'
# alias gh-rename='gh repo rename'

# gh-clone() {
#     REPOSITORY_NAME=$1
#     gh repo clone "$GITHUB_URL"/"$REPOSITORY_NAME".git
#     }




# # to switch GitHub CLI to use the personal access token
# switchToPersonalGitHub() {
#     # Log out from the current GitHub CLI session
#     gh auth logout && \
    #         # Decrypt the personal GitHub token and write it to a temporary file
#         decript -t github_token_p > /tmp/_.txt && \
    #             # Log in to GitHub CLI using the personal access token from the temporary file
#         gh auth login --with-token < /tmp/_.txt && \
    #             # Remove the temporary file containing the token for security
#         rm -rf /tmp/_.txt
# }

# # to switch GitHub CLI to use the work access token
# switchToWorkGitHub() {
#     # Log out from the current GitHub CLI session
#     gh auth logout && \
    #         # Decrypt the work GitHub token and write it to a temporary file
#         decript -t github_token_w > /tmp/_.txt && \
    #             # Log in to GitHub CLI using the work access token from the temporary file
#         gh auth login --with-token < /tmp/_.txt && \
    #             # Remove the temporary file containing the token for security
#         rm -rf /tmp/_.txt
# }


# EOF
