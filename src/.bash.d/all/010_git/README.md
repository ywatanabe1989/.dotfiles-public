<!-- ---
!-- Timestamp: 2025-05-19 21:08:22
!-- Author: ywatanabe
!-- File: /ssh:sp:/home/ywatanabe/.bash.d/all/010_git/README.md
!-- --- -->

#!/bin/bash
# Git command completion enhancements

# 1. Create Git aliases for your commonly used commands
git config --global alias.st 'status -s'
git config --global alias.br 'branch'
git config --global alias.co 'checkout'
git config --global alias.sw 'switch'
git config --global alias.cf 'config'
git config --global alias.cm 'commit -m'
git config --global alias.ac '!git add . && git commit -m'
git config --global alias.lg 'log --graph --date=human --decorate=short --pretty=format:"%Cgreen%h %Creset%cd %Cblue%cn %Cred%d %Creset%s"'
git config --global alias.unstage 'restore --staged'
git config --global alias.last 'log -1 HEAD'

# 2. Create Bash aliases that use Git's built-in completion
alias g='git'
alias gst='git st'
alias gbr='git br'
alias gco='git co'
alias gsw='git sw'
alias gcf='git cf'
alias gcm='git cm'
alias gac='git ac'
alias glg='git lg'
alias gdf='git diff'
alias gun='git unstage'

# 3. Set up proper Bash completion for these aliases
if [ -f /usr/share/bash-completion/completions/git ]; then
  # This makes the aliases inherit git's completion
  __git_complete g __git_main
  __git_complete gst _git_status
  __git_complete gbr _git_branch
  __git_complete gco _git_checkout
  __git_complete gsw _git_switch
  __git_complete gcf _git_config
  __git_complete gcm _git_commit
  __git_complete gac _git_commit
  __git_complete glg _git_log
  __git_complete gdf _git_diff
  __git_complete gun _git_restore
fi

# 4. Add custom completion for your defined functions
_git_custom_function_completion() {
  local commands="$(git --list-cmds=alias,main)"
  COMPREPLY=( $(compgen -W "$commands" -- ${COMP_WORDS[COMP_CWORD]}) )
}

complete -F _git_custom_function_completion git_merge_and_delete
complete -F _git_custom_function_completion git_untrack
complete -F _git_custom_function_completion git_track

<!-- EOF -->