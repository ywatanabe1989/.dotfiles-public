<!-- ---
!-- title: ./.cheat-sheets/os/linux/commands/man.md
!-- author: ywatanabe
!-- date: 2024-11-14 16:33:30
!-- --- -->

# `man.md`

## Basic Usage

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `man command` | Display manual for command |
| [ ] | `man -k keyword` | Search manuals (like apropos) |
| [ ] | `man -f command` | Display short description (like whatis) |
| [ ] | `man man` | Manual about the man system |
| [ ] | `man 5 passwd` | View specific section manual |

## Search Within man

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `/pattern` | Search forward for pattern |
| [ ] | `?pattern` | Search backward for pattern |
| [ ] | `n` | Next occurrence |
| [ ] | `N` | Previous occurrence |
| [ ] | `g` | Go to start of page |
| [ ] | `G` | Go to end of page |

## Useful Combinations

```bash
# Find commands related to network
man -k network | grep 8

# Search specific option in manual
man ssh | grep -A 2 "\-p "

# List all config file manuals
man -k "config file" | grep "5"

# Find commands with specific capability
man -k "change password"
```

## Manual Sections

| Section | Content |
|---------|----------|
| 1 | User Commands |
| 2 | System Calls |
| 3 | C Library Functions |
| 4 | Devices and Special Files |
| 5 | File Formats and Conventions |
| 8 | System Administration |

# `help.md`

## Bash Built-ins

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `help` | List all shell built-ins |
| [ ] | `help command` | Show help for built-in command |
| [ ] | `command --help` | Show command help message |
| [ ] | `info command` | Show detailed command info |

## Quick Reference

```bash
# Get specific option help
command --help | grep "pattern"

# Find all options starting with 'v'
command --help | grep "^[[:space:]]*-v"

# List all commands in a package
dpkg -L package-name | grep "bin/"

# Find command location and type
type command
which command
```

## Documentation Tools

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `tldr command` | Show simplified examples |
| [ ] | `apropos keyword` | Search manual names/descriptions |
| [ ] | `whatis command` | Display one-line manual description |
| [ ] | `command -v name` | Check if command exists |

## Tips
- [ ] Use `less` for scrollable output
- [ ] Combine with `grep -A n` for context
- [ ] Use `type` to check command type
