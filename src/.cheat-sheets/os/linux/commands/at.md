<!-- ---
!-- title: ./.cheat-sheets/os/linux/commands/at.md
!-- author: ywatanabe
!-- date: 2024-11-14 16:38:15
!-- --- -->

# `at.md`

## Basic Operations

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `at now + 5 minutes` | Execute in 5 minutes |
| [ ] | `at 2:30 PM` | Execute at specific time |
| [ ] | `at 2:30 PM tomorrow` | Execute tomorrow |
| [ ] | `atq` | List pending jobs |
| [ ] | `atrm [job_number]` | Remove job |

## Usage Examples
```bash
# Schedule a job
at 23:00 << EOF
backup.sh
EOF

# Using specific date
at 9:00 AM 12/25/2023

# Check queue
atq
```

## Job Management
```bash
# Remove specific job
atrm 1

# List jobs for specific user
at -l

# Read queued commands
at -c [job_number]
```

## Tips
- [ ] Use `CTRL+D` to end input
- [ ] Redirect output to file/email
- [ ] Combine with shell scripts
- [ ] Check system logs for execution

## Note
Requires atd service:
```bash
sudo systemctl status atd
sudo systemctl enable atd
sudo systemctl start atd
```
