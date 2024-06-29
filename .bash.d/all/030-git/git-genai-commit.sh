#!/usr/bin/env bash
# Script created on: 2024-06-25 20:51:21
# Script path: /home/ywatanabe/.dotfiles/.bash.d/all/030-git/git-genai-commit.sh

genai-commit() {
    change_status=$(git diff --unified=0)

    prompt="Please generate a commit message without any other lines as I will use your output as a commit message directly. The shorter, the better.

$change_status"

    # Escape the prompt for use in Python
    prompt=$(echo "$prompt" | sed 's/#/\\\#/g')
    escaped_prompt="$(printf '%q' "$prompt")"

    # genai_out=$(genai $escaped_prompt)
    # genai_out=$(gpt-3-5-turbo $escaped_prompt)
    genai_out=$(claude $escaped_prompt)

    clean_commit_message=$(echo $genai_out | sed 's/-/ /g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    git commit -m "$clean_commit_message"
}

alias gcm="genai-commit"

# EOF
