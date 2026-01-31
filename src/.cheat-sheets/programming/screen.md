# Screen Cheat Sheet

## Session Management

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | screen | Start a new session |
| [ ] | screen -S name | Start a new named session |
| [ ] | Ctrl-a d | Detach from session |
| [ ] | screen -ls | List sessions |
| [ ] | screen -r [name] | Reattach to a session |
| [ ] | screen -X -S [name] quit | Kill a session |

## Window Management

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | Ctrl-a c | Create a new window |
| [ ] | Ctrl-a A | Rename current window |
| [ ] | Ctrl-a n | Switch to next window |
| [ ] | Ctrl-a p | Switch to previous window |
| [ ] | Ctrl-a [number] | Switch to window by number |

## Region Management

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | Ctrl-a S | Split screen horizontally |
| [ ] | Ctrl-a | | Split screen vertically |
| [ ] | Ctrl-a tab | Switch between regions |
| [ ] | Ctrl-a X | Close current region |

## Tips and Tricks
- [ ] Use Ctrl-a ? to view all keybindings
- [ ] Customize your .screenrc file for personal preferences

## Additional Resources
- [ ] [GNU Screen Manual](https://www.gnu.org/software/screen/manual/screen.html)
- [ ] [Screen User's Manual](https://www.gnu.org/software/screen/manual/screen.html)


## Yusuke's Configurations

```
alias sb='screen -dmS'
alias sc='screen'
alias sd='screen -D'
alias sl='screen -list'
alias sr='screen -r'
alias ss='screen -S'
alias swipe='screen -wipe && screen -list'

sk () {
    screen -ls | grep $1 | cut -d. -f1 | awk '{print $1}' | xargs kill
    clear
    screen -list
}


to_screen() {
    # for pid in `pgrep rsync`; do to_screen $pid; done
    local PID="$1"
    local CMD=$(ps -p $PID -o cmd=)
    local SESSION_NAME="proc_$PID"
    screen -dmS "$SESSION_NAME"
    screen -S "$SESSION_NAME" -X stuff "reptyr -T $PID^M"
    echo $PID was moved to the screen session "$SESSION_NAME"
}
```

