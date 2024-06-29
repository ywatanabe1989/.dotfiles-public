#!/usr/bin/env bash
# Script created on: 2024-06-25 11:14:11
# Script path: /home/ywatanabe/.dotfiles/.bash.d/all/030-github/github-pull-request.sh

gh-pr-from-dev-to-main() {
    gh auth login --with-token < $HOME/.bash.d/secrets/access-tokens/github.txt
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

# EOF
