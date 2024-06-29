#!/usr/bin/env bash
# Script created on: 2024-06-22 17:01:16
# Script path: /home/ywatanabe/.dotfiles/.bash.d/all/030-git-init.sh

-handle-existing-local-git() {
    local REPOSITORY_NAME=$(basename "$(pwd)")

    if [ ! -f README.md ]; then
        echo "# $REPOSITORY_NAME" > README.md
    fi

    if [ -d .git ]; then
        read -p "Do you want to remove the existing .git directory? (y/n): " answer
        if [ "$answer" = "y" ]; then
            rm -rf .git
            echo ".git directory removed."
        else
            echo "Operation cancelled."
            return 1
        fi
    fi
}

-handle-remote-repository() {
    local GITHUB_OWNER=ywatanabe1989
    local REPOSITORY_NAME=$(basename "$(pwd)")

    if gh repo view "$GITHUB_OWNER"/$REPOSITORY_NAME &> /dev/null; then
        read -p "Remote repository https://github.com/$GITHUB_OWNER/$REPOSITORY_NAME exists. Backup and create new (y), delete (d), or cancel (n)? " answer
        case "$answer" in
            y)
                local TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
                local NEW_NAME="${REPOSITORY_NAME}_backup_${TIMESTAMP}"
                gh repo rename $NEW_NAME --repo $GITHUB_OWNER/$REPOSITORY_NAME --yes
                echo "Existing repository renamed to $NEW_NAME"
                ;;
            d)
                gh repo delete "$GITHUB_OWNER/$REPOSITORY_NAME" --yes
                echo "Existing repository deleted"
                sleep 3
                ;;
            *)
                echo "Operation cancelled."
                return 1
                ;;
        esac
    fi
}

-create_new_repository() {
    local REPOSITORY_NAME=`basename $PWD`

    gh auth login --with-token < $HOME/.bash.d/secrets/access-tokens/github.txt
    for i in {1..3}; do
        if gh repo create "$REPOSITORY_NAME" --private; then
            echo "Repository created successfully."
            break
        else
            if [ $i -eq 3 ]; then
                echo "Failed to create repository after 3 attempts."
                return 1
            fi
            echo "Attempt $i failed. Retrying in 10 seconds..."
            sleep 10
        fi
    done
}

-init-local-git() {
    local GITHUB_OWNER=ywatanabe1989
    local REPOSITORY_NAME=`basename $PWD`

    git init
    git add README.md
    git commit -m "first commit"
    git branch -M main
    git remote add origin git@github.com:$GITHUB_OWNER/$REPOSITORY_NAME.git
    git push -u origin main || { echo "Failed to push to main branch"; return 1; }

    git checkout -b develop
    git add .
    git commit -m "second commit" || true
    git push -u origin develop || { echo "Failed to push to develop branch"; return 1; }
}

-handle-pull-request() {
    if [ $(git rev-list --count main..develop) -gt 0 ]; then
        local PR_URL=$(gh pr create --base main --head develop --title "Merge develop into main" --body "Automated pull request")
        if [ $? -eq 0 ]; then
            local PR_NUMBER=$(echo $PR_URL | awk -F'/' '{print $NF}')
            gh pr merge $PR_NUMBER --merge || echo "Failed to merge pull request"
        else
            echo "Failed to create pull request"
        fi
    else
        echo "No differences between main and develop, skipping pull request"
    fi
}

git-init() {
    -handle-existing-local-git
    -handle-remote-repository
    -create_new_repository
    -init-local-git
    -handle-pull-request
    git switch develop
}

# EOF
