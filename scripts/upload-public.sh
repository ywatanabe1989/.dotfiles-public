#!/bin/bash
# -*- coding: utf-8 -*-
# Timestamp: "2026-01-31 (ywatanabe)"
# File: scripts/upload-public.sh
# Description: Safely upload sanitized dotfiles to public repository

set -euo pipefail

# =============================================================================
# Security: Set restrictive umask for all created files
# =============================================================================
umask 077

# =============================================================================
# Readonly constants
# =============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
readonly CONFIG_DIR="${SCRIPT_DIR}/upload-public.d"
readonly LIB_FILE="${CONFIG_DIR}/lib.sh"

# =============================================================================
# Source library
# =============================================================================
if [[ ! -f "$LIB_FILE" ]]; then
    echo "ERROR: Library file not found: $LIB_FILE" >&2
    exit 1
fi
# shellcheck source=upload-public.d/lib.sh
source "$LIB_FILE"

# =============================================================================
# Cleanup function
# =============================================================================
cleanup() {
    local exit_code=$?

    if [[ "${DRY_RUN:-true}" == "false" ]] || [[ "${KEEP_STAGING_ON_DRY_RUN:-false}" != "true" ]]; then
        if [[ -n "${TMP_DIR:-}" && -d "$TMP_DIR" ]]; then
            echo_info "Cleaning up temporary directory..."
            rm -rf "$TMP_DIR"
        fi
    else
        if [[ -n "${TMP_DIR:-}" && -d "$TMP_DIR" ]]; then
            echo_info "Staging directory preserved for inspection: $TMP_DIR"
        fi
    fi

    if [[ $exit_code -eq 0 && -n "${LOG_FILE:-}" && -f "$LOG_FILE" ]]; then
        rm -f "$LOG_FILE"
    elif [[ -n "${LOG_FILE:-}" && -f "$LOG_FILE" ]]; then
        echo_info "Log file preserved for debugging: $LOG_FILE"
    fi

    exit $exit_code
}
trap cleanup EXIT

# =============================================================================
# Usage
# =============================================================================
usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Safely upload sanitized dotfiles to public repository.

WORKFLOW:
    ~/.dotfiles (PRIVATE)                    GitHub: dotfiles-public (PUBLIC)
    ┌─────────────────────────┐              ┌─────────────────────────┐
    │ Your full dotfiles      │              │ Sanitized version       │
    │ - configs               │   script     │ - configs               │
    │ - secrets ✓             │ ─────────▶   │ - NO secrets            │
    │ - SSH keys ✓            │  (filters)   │ - NO keys               │
    │ - API tokens ✓          │              │ - NO tokens             │
    │ - work stuff ✓          │              │ - NO work stuff         │
    └─────────────────────────┘              └─────────────────────────┘
         │                                          │
         │ git push (private)                       │ git push (public)
         ▼                                          ▼
     Your private remote                     github.com/ywatanabe1989/
     (for syncing machines)                  dotfiles-public

TYPICAL USAGE:
    # Daily: sync private dotfiles across your machines
    cd ~/.dotfiles && git pull / git push   # to PRIVATE remote

    # Occasionally: share sanitized version publicly
    $0                 # dry-run (preview what will be uploaded)
    $0 --run           # actually push to public repository

OPTIONS:
    -r, --run       Actually perform the upload (default: dry-run)
    -f, --force     Skip confirmation prompts
    -s, --scan-only Only scan for dangerous content, don't copy
    -c, --config    Show config file location and contents
    -h, --help      Show this help

CONFIGURATION:
    Config directory: $CONFIG_DIR
    - config                  Main configuration (GitHub owner, repo)
    - exclude-patterns.conf   File/directory patterns to exclude
    - dangerous-patterns.conf Content patterns to scan for

SECURITY LAYERS:
    1. File exclusion     - rsync --exclude (96 patterns)
    2. Regex scan         - grep for secrets (22 patterns)
    3. Deep scan          - gitleaks integration (if installed)
    4. Manual review      - Lists files before upload
    5. Confirmation       - Interactive prompt required
    6. Dry-run default    - Must explicitly use --run

EOF
    exit 0
}

# =============================================================================
# Main
# =============================================================================
DRY_RUN=true
FORCE=false
SCAN_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
    -r | --run)
        DRY_RUN=false
        shift
        ;;
    -f | --force)
        FORCE=true
        shift
        ;;
    -s | --scan-only)
        SCAN_ONLY=true
        shift
        ;;
    -c | --config)
        show_config "$CONFIG_DIR"
        exit 0
        ;;
    -h | --help)
        usage
        ;;
    *)
        echo_error "Unknown option: $1"
        usage
        ;;
    esac
done

echo "=============================================="
echo "  Dotfiles Public Upload (Secure)"
echo "  Mode: $(if $DRY_RUN; then echo 'DRY-RUN'; else echo 'LIVE'; fi)"
echo "=============================================="
echo

# Load configuration and patterns
echo_info "Loading configuration..."
load_config "$CONFIG_DIR" || exit 1
load_patterns "$CONFIG_DIR"

# Set DOTFILES_DIR if not specified in config
if [[ -z "${DOTFILES_DIR:-}" ]]; then
    DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
fi
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo_error "DOTFILES_DIR does not exist: $DOTFILES_DIR"
    exit 1
fi

# Create secure temporary directory
echo_info "Creating secure temporary directory..."
create_secure_tmp || exit 1

# Stage 1: Copy with exclusions
echo
echo_info "Stage 1: Copying files (excluding dangerous patterns)..."

excludes=$(build_rsync_excludes)
eval "rsync -av --links --safe-links $excludes '$DOTFILES_DIR/' '$TMP_DIR/'" >"$LOG_FILE" 2>&1

echo_success "Copied to staging directory"

# Stage 2: Scan for secrets
echo
echo_info "Stage 2a: Scanning with regex patterns..."
SECRETS_FOUND=false
if ! scan_for_secrets "$TMP_DIR"; then
    SECRETS_FOUND=true
fi

echo
echo_info "Stage 2b: Scanning with gitleaks..."
if ! scan_with_gitleaks "$TMP_DIR"; then
    SECRETS_FOUND=true
fi

if $SECRETS_FOUND; then
    echo
    echo_error "DANGER: Secrets detected in staged files!"
    echo_error "Review and remove sensitive files before proceeding."
    echo_info "Staged files are in: $TMP_DIR"

    if ! $FORCE; then
        read -rp "Continue anyway? (type 'I UNDERSTAND THE RISK'): " answer
        if [[ "$answer" != "I UNDERSTAND THE RISK" ]]; then
            echo_info "Aborted."
            exit 1
        fi
    fi
fi

if $SCAN_ONLY; then
    echo_info "Scan complete. Staged files in: $TMP_DIR"
    exit 0
fi

# Stage 3: Review files
echo
echo_info "Stage 3: Review staged files..."
list_staged_files "$TMP_DIR"

if $DRY_RUN; then
    echo
    echo_warning "DRY-RUN MODE - No changes made"
    echo_info "To actually upload, run: $0 --run"
    echo_info "Staged files preserved in: $TMP_DIR"
    exit 0
fi

# Stage 4: Confirm and upload
echo
if ! $FORCE; then
    read -rp "Proceed with upload to PUBLIC repository? (yes/no): " answer
    if [[ "$answer" != "yes" ]]; then
        echo_info "Aborted."
        exit 1
    fi
fi

echo_info "Stage 4: Uploading to GitHub..."
ensure_repo_exists "$GITHUB_OWNER" "$PUBLIC_REPO" "$FORCE" || exit 1

cd "$TMP_DIR"

# Initialize git if needed
if [[ ! -d .git ]]; then
    git init
    git remote add origin "git@github.com:$GITHUB_OWNER/$PUBLIC_REPO.git"
fi

# Create README if missing
if [[ ! -f README.md ]]; then
    cat >README.md <<'READMEEOF'
# Public Dotfiles

Sanitized version of my personal dotfiles.

**Warning**: This is auto-generated. Do not edit directly.

## Contents

- `.bash.d/` - Bash configurations
- `.emacs.d/` - Emacs configurations
- `.tmux.conf` - Tmux configuration
- And more...

## Usage

```bash
git clone https://github.com/ywatanabe1989/dotfiles-public.git ~/.dotfiles
cd ~/.dotfiles
make deploy-dry  # Preview
make deploy      # Install
```
READMEEOF
fi

git add -A
git commit -m "Update public dotfiles $(date +%Y-%m-%d)" --no-verify || echo_info "No changes to commit"
git branch -M main
# Use --no-verify to skip hooks in staging directory (hooks may be incomplete from templates)
git push -u origin main --force --no-verify

echo
echo_success "Upload complete!"
echo_info "Repository: https://github.com/$GITHUB_OWNER/$PUBLIC_REPO"

# EOF
