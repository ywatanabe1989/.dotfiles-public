<!-- ---
!-- Timestamp: 2025-12-04 21:27:42
!-- Author: ywatanabe
!-- File: /home/ywatanabe/.dotfiles/.bash.d/all/010_claude/README.md
!-- --- -->

# Claude Code Session Management

Bash utilities for managing Claude Code sessions, worktrees, and configurations.

## Architecture

```
Entry Points:
  cld  -> _cld_start_session    Start Claude Code session
  cc   -> claude -c             Quick continue session
  cldw -> _cld_worktree_session Start session in git worktree

Session Startup Flow:
┌─────────────────────────────────────────────────────────────────────────┐
│  cld (alias) -> _cld_start_session                                      │
│       │                                                                 │
│       ├── cld_forget (clear old sessions)                               │
│       │                                                                 │
│       ├── _cld_rsync_file: settings.local.json                          │
│       │                                                                 │
│       ├── _cld_rsync_to_cld_dir: ~/.claude/to_claude/* -> docs/to_claude│
│       │                                                                 │
│       ├── _cld_sync_agents_dir   ✓ MERGES into .claude/agents/          │
│       │       └── Creates model variants (-HAIKU, -SONNET, -OPUS)       │
│       │                                                                 │
│       ├── _cld_sync_commands_dir ✓ MERGES into .claude/commands/        │
│       │                                                                 │
│       ├── _cld_sync_skills_dir   ✓ MERGES into .claude/skills/          │
│       │                                                                 │
│       └── Launches: claude --model $model $@                            │
└─────────────────────────────────────────────────────────────────────────┘

Directory Sync Flow:
┌─────────────────────────────────────────────────────────────────────────┐
│  ~/.claude/to_claude/                                                   │
│       ├── guidelines/  ──rsync──>  ./docs/to_claude/guidelines/         │
│       ├── bin/         ──rsync──>  ./docs/to_claude/bin/                │
│       ├── examples/    ──rsync──>  ./docs/to_claude/examples/           │
│       ├── agents/      ──rsync──>  ./docs/to_claude/agents/             │
│       ├── commands/    ──rsync──>  ./docs/to_claude/commands/           │
│       └── skills/      ──rsync──>  ./docs/to_claude/skills/             │
│                                                                         │
│  Then MERGES into project .claude/ (preserves project-specific files):  │
│       ~/.claude/to_claude/agents/   -> .claude/agents/   (merge)        │
│       ~/.claude/to_claude/commands/ -> .claude/commands/ (merge)        │
│       ~/.claude/to_claude/skills/   -> .claude/skills/   (merge)        │
│                                                                         │
│  ✓ Project-specific files are PRESERVED (rsync --ignore-existing)       │
│    Central files are marked READ-ONLY (444) to prevent accidental edits │
└─────────────────────────────────────────────────────────────────────────┘
```

## File Structure

| File | Description |
|------|-------------|
| `010_claude_session.src` | Main entry point, session management |
| `010_claude_logout.src` | Credential management (`cld_logout`, `cld_forget`) |
| `010_claude_permissions.src` | File permission utilities |
| `010_claude_rsync.src` | File/directory sync utilities |
| `010_claude_symlinks.src` | Config merge with project preservation |
| `010_claude_worktree.src` | Git worktree support (`cldw`, `cldw-ls`, `cldw-rm`) |
| `010_claude_skills.src` | Skills CLI utilities (`clds-ls`, `clds-create`, etc.) |
| `010_claude_switch.src` | Multi-account switcher (`cld-switch`, `cld-switch-to`, etc.) |
| `010_claude_usage.src` | Usage/cost tracking (`cld-usage`, `cld-usage-today`, etc.) |

## Commands

### Session Management

| Command         | Description                                    |
|-----------------|------------------------------------------------|
| `cld`           | Start Claude Code session in current directory |
| `cld -m sonnet` | Start with specific model (haiku/sonnet/opus)  |
| `cld -f 3`      | Forget last 3 sessions before starting         |
| `cc`            | Quick continue last session                    |
| `cc -m haiku`   | Continue with specific model                   |

### Worktree Management

| Command              | Description                              |
|----------------------|------------------------------------------|
| `cldw <name> [base]` | Create worktree and start Claude session |
| `cldw-ls`            | List all worktrees                       |
| `cldw-rm <name>`     | Remove a worktree                        |

Example:
```bash
cldw feature-auth main    # Creates .claude-worktree/myproject-feature-auth/
cldw bugfix develop       # Creates .claude-worktree/myproject-bugfix/
```

### Skills Management

| Command                  | Description                           |
|--------------------------|---------------------------------------|
| `clds-ls`                | List installed skills                 |
| `clds-create <name>`     | Create new skill template             |
| `clds-from <dir> <name>` | Create skill from guideline directory |
| `clds-info <name>`       | Show skill details                    |

### Account Switching

| Command               | Description                              |
|-----------------------|------------------------------------------|
| `cld-switch`          | Switch to next account in sequence       |
| `cld-switch-to <n>`   | Switch to specific account (num or email)|
| `cld-switch-add`      | Add current account to managed list      |
| `cld-switch-rm <n>`   | Remove account from managed list         |
| `cld-switch-ls`       | List all managed accounts                |
| `cld-switch-help`     | Show help                                |

Example:
```bash
cld-switch-add              # Add current logged-in account
cld-switch-ls               # List: 1: user1@example.com (active), 2: user2@example.com
cld-switch                  # Cycle to next account
cld-switch-to 2             # Switch to account 2
cld-switch-to user@example.com
```

### Usage Tracking

| Command            | Description                                          |
|--------------------|------------------------------------------------------|
| `cld-usage`        | Show total usage (all time) from local JSONL files   |
| `cld-usage-today`  | Show today's usage                                   |
| `cld-usage-week`   | Show last 7 days usage                               |
| `cld-usage-month`  | Show last 30 days usage                              |
| `cld-usage-all`    | Show usage report for all accounts                   |
| `cld-usage-web`    | Fetch subscription limits from claude.ai (see below) |
| `cld-usage-live`   | Info for live monitoring (ccusage)                   |
| `cld-usage-quick`  | Quick tips for checking usage                        |

Example output (local JSONL):
```
Model                               Input       Output       Cost
----------------------------------- ------------ ------------ ----------
claude-sonnet-4-5-20250929              1.2M        450K      $10.35
claude-opus-4-5-20251101                500K        200K      $22.50

TOTAL                                   1.7M        650K      $32.85
```

#### Web-based Usage (`cld-usage-web`)

Fetches real-time subscription limits from claude.ai/settings/usage:

```
Claude Usage Summary
========================================
Plan Usage:     [####----------------] 11%
                Resets: 3 hr 26 min

Weekly Limits:
----------------------------------------
All Models:     [########------------] 44%
                Resets: Mon 12:00 AM
Sonnet Only:    [#-------------------] 4%
                Resets: Mon 3:00 AM
```

**Requirements:**
- Chrome with active claude.ai session (login in browser first)
- playwright: `pip install playwright && playwright install chromium`

Note: Local JSONL data shows token counts; web data shows subscription limits.

## Configuration Merge Strategy

When starting a session, central configs are merged with project-specific configs.
Applies to: `skills/`, `agents/`, `commands/`

| Scenario                                        | Result                            |
|-------------------------------------------------|-----------------------------------|
| Central has `item-A`, project has `item-B`      | Both exist                        |
| Central has `item-A`, project also has `item-A` | **Central overrides** (read-only) |
| Central has new `item-C`                        | Added to project (read-only)      |

This allows easy central updates - edit `~/.claude/to_claude/` and all projects get updated.

### File Permissions

| Source                                | Permission | Editable?      |
|---------------------------------------|------------|----------------|
| From central (`~/.claude/to_claude/`) | `444`      | No - read-only |
| Project-specific                      | `644`      | Yes - writable |

This prevents accidental edits to centrally-managed files.

## Environment Variables

| Variable                    | Description                           |
|-----------------------------|---------------------------------------|
| `CLAUDE_CODE_DEFAULT_MODEL` | Default model (opus/sonnet/haiku)     |
| `CLAUDE_ID`                 | Unique session identifier             |
| `CLAUDE_DIR`                | Project directory for current session |
| `CLAUDE_START_TIME`         | Session start timestamp               |

<!-- EOF -->