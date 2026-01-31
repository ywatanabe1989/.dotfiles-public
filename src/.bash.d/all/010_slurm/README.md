<!-- ---
!-- Timestamp: 2025-04-05 14:41:53
!-- Author: ywatanabe
!-- File: /ssh:sp:/home/ywatanabe/.dotfiles/.bash.d/all/030-slurm/README.md
!-- --- -->


# SLURM Helper Scripts

A collection of Bash utilities to simplify working with SLURM job scheduler.

## Overview

These scripts provide convenient shortcuts and enhancements for common SLURM operations including:

- Interactive sessions
- Job management 
- Queue monitoring
- Log viewing
- Remote access to compute nodes

## Key Commands

| Command | Description |
|---------|-------------|
| `sint` | Start interactive sessions (`-s` short, `-l` long) |
| `scan` | Cancel jobs by index |
| `sjump` | SSH to the node running a specific job |
| `scat` | View job output files |
| `stail` | Monitor job output in real-time |
| `shead` | View beginning of job output files |
| `slush` | Submit bash scripts as jobs |
| `sprio_check` | Check queue position and priority |
| `s` | List running jobs with indices |
| `scheat` | Display SLURM command cheatsheet |

## Usage Examples

### Interactive Sessions

```bash
# Start short interactive session (1 GPU, 4h, 32GB)
sint -s

# Start long interactive session (4 GPUs, 7 days, 256GB)
sint -l

# Custom interactive session
sint -g 2 -t 12:00:00 -m 64 -p gpu-a100
```

### Job Management

```bash
# List all jobs with indices
s

# Cancel job by index
scan 3

# Cancel multiple jobs
scan 1 2 3

# Cancel all jobs
scan -a
```

### Log Viewing

```bash
# View job output
scat 1

# View job error
scat 1 err

# Monitor job output in real-time
stail 1

# View first 10 lines of job output
shead 1
```

### Remote Access

```bash
# SSH to node running job #2
sjump 2
```

## Environment Settings

Edit the `.bash.d/all/030-slurm/envs.sh.src` file to customize default settings.
```

<!-- EOF -->