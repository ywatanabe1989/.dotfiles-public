<!-- ---
!-- Timestamp: 2025-05-19 22:32:48
!-- Author: ywatanabe
!-- File: /home/ywatanabe/.dotfiles/.bash.d/all/010_git/TO_BIN.md
!-- --- -->

I am considering migrate /home/ywatanabe/.dotfiles/.bash.d/all/010_git/*.src files to ~/.bin/git/

# Detailed Git Utilities Reorganization Plan

## Current Issues
1. Too many separate source files with overlapping functionality
2. Inconsistent error handling and conflict detection
3. Duplicate code across files (e.g., parsing logic, directory checks)
4. Mixed responsibility (core functions + UI/aliases in same files)

## Proposed Structure

```
.dotfiles/bin/git-tools/
├── lib/             # Core library functions
│   ├── common.sh         # Common utilities (colors, args parsing)
│   ├── conflict.sh       # Conflict detection/resolution
│   ├── files.sh          # File operations (track/untrack)
│   └── repo.sh           # Repository operations
├── utils/           # Smaller utility scripts
│   ├── git-encrypt       # Encryption tools
│   ├── git-size          # Size formatting
│   ├── git-download-dir  # Directory downloading
│   └── git-remote        # Remote management
└── commands/        # User-facing commands
    ├── git-ac            # Add and commit
    ├── git-acp           # Add, commit, push
    ├── git-init          # Initialize repository
    ├── git-st            # Status with sizes
    └── git-tree          # Tree view
```

## Implementation Steps

1. Create the directory structure
2. Extract common functionality first
   - Argument parsing
   - Conflict detection
   - Error handling
3. Create standalone command scripts
4. Update bash aliases to point to new commands
5. Implement proper documentation
6. Add unit tests for core functions

## Key Improvements

1. **Conflict Detection**: Centralize in `lib/conflict.sh`
   - Consistent API: `is_repo_clean`, `list_conflicts`, `list_unmerged`
   - Clear distinction between unmerged files and actual conflicts

2. **Argument Handling**: Consistent in `lib/common.sh`
   - Standard help text generation
   - Uniform option parsing
   - Better error messaging

3. **Command Structure**: Each command script follows pattern:
   ```bash
   #!/bin/bash
   source "$(dirname "$0")/../lib/common.sh"
   
   show_help() {
     # Command-specific help
   }
   
   # Command logic
   
   # Execute if run directly (not sourced)
   [ "${BASH_SOURCE[0]}" = "$0" ] && main "$@"
   ```

4. **Configuration**: Move to dedicated config files

<!-- EOF -->