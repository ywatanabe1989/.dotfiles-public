# Tmux Cheat Sheet

## Session Management

| Checkbox | Shortcut/Command | Description |
|----------|------------------|-------------|
| [ ]      | tmux             | Start a new session |
| [ ]      | tmux new -s name | Start a new named session |
| [ ]      | Prefix + d       | Detach from session |
| [ ]      | tmux ls          | List sessions |
| [ ]      | tmux attach -t name | Attach to a named session |
| [ ]      | tmux kill-session -t name | Kill a named session |

## Window Management

| Checkbox | Shortcut/Command | Description |
|----------|------------------|-------------|
| [ ]      | Prefix + c       | Create a new window |
| [ ]      | Prefix + ,       | Rename current window |
| [ ]      | Prefix + n       | Move to next window |
| [ ]      | Prefix + p       | Move to previous window |
| [ ]      | Prefix + number  | Switch to window by number |

## Pane Management

| Checkbox | Shortcut/Command | Description |
|----------|------------------|-------------|
| [ ]      | Prefix + %       | Split pane vertically |
| [ ]      | Prefix + "       | Split pane horizontally |
| [ ]      | Prefix + arrow keys | Switch between panes |
| [ ]      | Prefix + z       | Toggle pane zoom |
| [ ]      | Prefix + x       | Close current pane |

## Tips and Tricks
- [ ] Tip 1: Use Prefix + ? to view all keybindings
- [ ] Tip 2: Customize your .tmux.conf file for personal preferences

## Additional Resources
- [ ] [Tmux Official Documentation](https://github.com/tmux/tmux/wiki)
- [ ] [The Tao of Tmux](https://leanpub.com/the-tao-of-tmux/read)

## Yusuke's Configurations

```
alias tb='tmux new-session -d -s'
alias tc='tmux'
alias td='tmux detach'
alias tl='tmux list-sessions'
alias tr='tmux attach -t'
alias ts='tmux new-session -s'
alias twipe='tmux kill-session -a && tmux list-sessions'

tk () {
    tmux kill-session -t $1
    clear
    tmux list-sessions
}

to_tmux() {
    local PID="$1"
    local CMD=$(ps -p $PID -o cmd=)
    local SESSION_NAME="proc_$PID"
    tmux new-session -d -s "$SESSION_NAME"
    tmux send-keys -t "$SESSION_NAME" "reptyr -T $PID" C-m
    echo $PID was moved to the tmux session "$SESSION_NAME"
}
```
