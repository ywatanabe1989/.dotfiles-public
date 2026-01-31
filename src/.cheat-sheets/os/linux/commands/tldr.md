<!-- ---
!-- title: ./.cheat-sheets/os/linux/commands/tldr.md
!-- author: ywatanabe
!-- date: 2024-11-14 16:38:52
!-- --- -->

# `tldr.md`

## Installation

```bash
# NPM method
npm install -g tldr

# Python method
pip install tldr

# Package manager
apt install tldr
```

## Basic Usage

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `tldr command` | Show command examples |
| [ ] | `tldr -u` | Update local cache |
| [ ] | `tldr -l` | List all commands |
| [ ] | `tldr -p linux` | Platform-specific pages |
| [ ] | `tldr --list` | List all pages |

## Advanced Usage

```bash
# Search for specific commands
tldr --search "find file"

# View offline
tldr --offline command

# Force cache update
tldr --clear-cache

# Different language
LANG=es tldr ssh
```

## Platform Options

| Checkbox | Platform | Flag |
|----------|----------|------|
| [ ] | Linux | `-p linux` |
| [ ] | macOS | `-p osx` |
| [ ] | Windows | `-p windows` |
| [ ] | SunOS | `-p sunos` |
| [ ] | Common | `-p common` |

## Configuration
```bash
# Config file location
~/.tldrrc
~/.config/tldr/config.json

# Example config
{
  "colors": {
    "description": "green",
    "command": "red",
    "examples": "blue"
  },
  "platform": "linux"
}
```

## Tips
- [ ] Use with `grep` for specific examples
- [ ] Update regularly for new commands
- [ ] Check platform-specific pages
- [ ] Combine with `man` for detailed info
