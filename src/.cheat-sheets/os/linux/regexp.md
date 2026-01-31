<!-- ---
!-- title: ./.cheat-sheets/os/linux/regexp.md
!-- author: ywatanabe
!-- date: 2024-11-14 16:46:02
!-- --- -->


# `regexp.md`

## Basic Patterns

| Pattern | Description | Example |
|---------|-------------|---------|
| `.` | Any single character | `c.t` matches "cat", "cut" |
| `*` | Zero or more | `ab*c` matches "ac", "abc", "abbc" |
| `+` | One or more | `ab+c` matches "abc", "abbc" |
| `?` | Zero or one | `ab?c` matches "ac", "abc" |
| `^` | Start of line | `^hello` matches "hello world" |
| `$` | End of line | `world$` matches "hello world" |
| `[]` | Character class | `[aeiou]` matches any vowel |
| `[^]` | Negated class | `[^0-9]` matches non-digits |
| `\` | Escape character | `\.` matches literal dot |

## Quantifiers

| Pattern | Description |
|---------|-------------|
| `{n}` | Exactly n times |
| `{n,}` | n or more times |
| `{n,m}` | Between n and m times |
| `*` | Same as `{0,}` |
| `+` | Same as `{1,}` |
| `?` | Same as `{0,1}` |

## Character Classes

| Pattern | Description |
|---------|-------------|
| `\d` | Digit `[0-9]` |
| `\D` | Non-digit `[^0-9]` |
| `\w` | Word `[A-Za-z0-9_]` |
| `\W` | Non-word `[^A-Za-z0-9_]` |
| `\s` | Whitespace `[ \t\n\r\f]` |
| `\S` | Non-whitespace |
| `\b` | Word boundary |
| `\B` | Non-word boundary |

## Common Examples

```bash
# Email validation
^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$

# URL matching
https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)

# IP address
^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$

# Phone number (simple)
^\+?[\d\s-]{10,}$
```

## Groups and References

| Pattern | Description |
|---------|-------------|
| `(...)` | Capturing group |
| `(?:...)` | Non-capturing group |
| `\1` | Back reference to group 1 |
| `(?=...)` | Positive lookahead |
| `(?!...)` | Negative lookahead |

## Command Line Usage

```bash
# grep with regex
grep -E "pattern" file

# sed with regex
sed -E 's/pattern/replacement/' file

# awk with regex
awk '/pattern/ {print}' file

# find with regex
find . -regex ".*\.txt$"
```

## Tips
- [ ] Test regex on online tools first
- [ ] Use non-capturing groups when reference not needed
- [ ] Escape special characters in literal strings
- [ ] Consider using extended regex (`-E` flag)
- [ ] Be specific to avoid performance issues


## Emacs Regex

| Pattern | Description | Emacs Difference |
|---------|-------------|------------------|
| `\s-` | Whitespace | Emacs-specific syntax |
| `\sw` | Word constituent | Different from standard `\w` |
| `\_<` | Word boundary | Emacs syntax for `\b` |
| `\`` | Buffer beginning | Emacs-specific |
| `\'` | Buffer end | Emacs-specific |

## Emacs Commands
```elisp
;; Search forward
C-M-s

;; Search backward
C-M-r

;; Query replace regexp
M-x query-replace-regexp
C-M-%

;; Builder
M-x regexp-builder
C-c C-w   ;; Copy as string

;; List matching lines
M-x occur

;; Highlight regexp
M-x highlight-regexp
```

## Emacs-specific Tips
- [ ] Use `M-x re-builder` to test regexps
- [ ] `C-M-x` evaluates regex in re-builder
- [ ] `\(?:...\)` for non-capturing groups
- [ ] Use `rx` macro for readable patterns
- [ ] Double backslashes in Lisp strings
