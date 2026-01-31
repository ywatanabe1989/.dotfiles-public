<!-- ---
!-- title: ./.cheat-sheets/os/linux/general/find.md
!-- author: ywatanabe
!-- date: 2024-11-14 16:25:51
!-- --- -->

# `find.md`

## Basic Search

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `find . -name "pattern"` | Find by exact name |
| [ ] | `find . -iname "pattern"` | Find case-insensitive |
| [ ] | `find . -type f` | Find files only |
| [ ] | `find . -type d` | Find directories only |
| [ ] | `find . -empty` | Find empty files/directories |

## Time-based Search

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `find . -mtime +7` | Modified more than 7 days ago |
| [ ] | `find . -mtime -7` | Modified less than 7 days ago |
| [ ] | `find . -ctime n` | Status changed exactly n days ago |
| [ ] | `find . -atime n` | Accessed exactly n days ago |
| [ ] | `find . -newer file.txt` | Modified more recently than file.txt |

## Size-based Search

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `find . -size +10M` | Larger than 10MB |
| [ ] | `find . -size -10M` | Smaller than 10MB |
| [ ] | `find . -size 10k` | Exactly 10KB |
| [ ] | `find . -size +1G` | Larger than 1GB |

## Execute Actions

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `find . -exec command {} \;` | Execute command on each result |
| [ ] | `find . -delete` | Delete matching files |
| [ ] | `find . -ls` | Detailed listing of matches |
| [ ] | `find . -print0` | NULL-terminated output |

## Permission/Ownership Search

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `find . -perm 644` | Find with exact permissions |
| [ ] | `find . -user username` | Find by owner |
| [ ] | `find . -group groupname` | Find by group |

## Tips and Tricks
- [ ] Use `-maxdepth` to limit search depth
- [ ] Combine with `xargs` for batch processing
- [ ] Use `-not` or `!` to negate conditions

## Resources
- [ ] [GNU find manual](https://www.gnu.org/software/findutils/manual/html_mono/find.html)
