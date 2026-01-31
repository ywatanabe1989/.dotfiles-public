<!-- ---
!-- title: ./.cheat-sheets/os/linux/commands/tr.md
!-- author: ywatanabe
!-- date: 2024-11-14 16:39:57
!-- --- -->


# `tr.md` - translate or delete characters

## Basic Operations

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `tr 'a-z' 'A-Z'` | Convert to uppercase |
| [ ] | `tr -d '\n'` | Delete newlines |
| [ ] | `tr -s ' '` | Squeeze repeats |
| [ ] | `tr -c 'a-zA-Z'` | Complement set |
| [ ] | `tr '[:lower:]' '[:upper:]'` | Using character classes |

## Examples
```bash
# Remove all digits
echo "hello123" | tr -d '0-9'

# Replace spaces with newlines
echo "one two three" | tr ' ' '\n'

# Remove all non-printable characters
tr -cd '[:print:]' < file.txt
```

