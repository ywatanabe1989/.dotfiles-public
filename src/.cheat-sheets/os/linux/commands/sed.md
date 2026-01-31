<!-- ---
!-- title: ./.cheat-sheets/os/linux/general/sed.md
!-- author: ywatanabe
!-- date: 2024-11-14 16:23:51
!-- --- -->


# `sed.md`

## Basic Operations

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `sed 's/old/new/'` | Replace first occurrence |
| [ ] | `sed 's/old/new/g'` | Replace all occurrences |
| [ ] | `sed -i` | Edit file in-place |
| [ ] | `sed -n '1p'` | Print specific line (1st line) |
| [ ] | `sed '1d'` | Delete specific line |

## Advanced Pattern Matching

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `sed '/pattern/d'` | Delete lines matching pattern |
| [ ] | `sed '/^$/d'` | Remove empty lines |
| [ ] | `sed 's/^/prefix/'` | Add prefix to lines |
| [ ] | `sed 's/$/suffix/'` | Add suffix to lines |
| [ ] | `sed -n '/pattern/p'` | Print lines matching pattern |

## Tips and Tricks
- [ ] Use `-E` for extended regex support
- [ ] Use `\1`, `\2` for capture groups

## Resources
- [ ] [GNU sed manual](https://www.gnu.org/software/sed/manual/sed.html)

