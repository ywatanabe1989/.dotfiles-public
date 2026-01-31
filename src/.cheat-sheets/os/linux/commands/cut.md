<!-- ---
!-- title: ./.cheat-sheets/os/linux/commands/cut.md
!-- author: ywatanabe
!-- date: 2024-11-14 16:38:01
!-- --- -->


# `cut.md`

## Basic Operations

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `cut -c1-3` | Extract characters 1-3 |
| [ ] | `cut -d: -f1` | Cut by delimiter, field 1 |
| [ ] | `cut -b1-2` | Extract bytes 1-2 |
| [ ] | `cut --complement` | Select inverse fields |
| [ ] | `cut -d' ' -f1,3` | Multiple fields |

## Common Usage
```bash
# Extract usernames from /etc/passwd
cut -d: -f1 /etc/passwd

# Get first 10 characters of each line
cut -c1-10 file.txt

# Extract second column with custom delimiter
cut -d',' -f2 data.csv
```

