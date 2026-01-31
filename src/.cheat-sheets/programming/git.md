# Git Cheat Sheet

## Basic Commands

| Command | Description |
|---------|-------------|
| `git init` | Initialize a new Git repository |
| `git clone <url>` | Clone a repository |
| `git add <file>` | Add file to staging area |
| `git commit -m "message"` | Commit changes |
| `git status` | Check repository status |
| `git log` | View commit history |
| `git diff` | Show changes between commits |

## Branching and Merging

| Command | Description |
|---------|-------------|
| `git branch` | List branches |
| `git branch <name>` | Create a new branch |
| `git checkout <branch>` | Switch to a branch |
| `git merge <branch>` | Merge a branch into current branch |
| `git branch -d <branch>` | Delete a branch |

## Remote Repositories

| Command | Description |
|---------|-------------|
| `git remote add <name> <url>` | Add a remote repository |
| `git push <remote> <branch>` | Push changes to remote |
| `git pull <remote> <branch>` | Pull changes from remote |
| `git fetch <remote>` | Fetch changes from remote |

## Undoing Changes

| Command | Description |
|---------|-------------|
| `git reset <file>` | Unstage a file |
| `git checkout -- <file>` | Discard changes in working directory |
| `git revert <commit>` | Revert a commit |
| `git reset --hard <commit>` | Reset to a specific commit |

## Stashing

| Command | Description |
|---------|-------------|
| `git stash` | Stash changes |
| `git stash list` | List stashes |
| `git stash apply` | Apply stashed changes |
| `git stash drop` | Remove a stash |

## Configuration

| Command | Description |
|---------|-------------|
| `git config --global user.name "Name"` | Set username |
| `git config --global user.email "email"` | Set email |
| `git config --list` | List all settings |

## Tips
- Use meaningful commit messages
- Commit often, push regularly
- Use branches for new features or bug fixes
- Always pull before pushing to avoid conflicts

## Additional Resources
- [Official Git Documentation](https://git-scm.com/doc)
- [Git Book](https://git-scm.com/book/en/v2)
