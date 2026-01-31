#!/bin/bash
# -*- coding: utf-8 -*-
# Timestamp: "2026-01-31 (ywatanabe)"
# File: scripts/upload-public.d/lib.sh
# Description: Library functions for upload-public.sh

# =============================================================================
# Logging functions
# =============================================================================
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

echo_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
echo_success() { echo -e "${GREEN}[OK]${NC} $1"; }
echo_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
echo_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }
echo_danger() { echo -e "${RED}[DANGER]${NC} $1" >&2; }

# =============================================================================
# Security: Validate and load config
# =============================================================================
load_config() {
    local config_dir="$1"
    local config_file="${config_dir}/config"

    # Check config file exists
    if [[ ! -f "$config_file" ]]; then
        echo_error "Config file not found: $config_file"
        echo_info "Creating default config..."
        mkdir -p "$config_dir"
        cat >"$config_file" <<'EOF'
# Config for upload-public.sh
GITHUB_OWNER="ywatanabe1989"
PUBLIC_REPO="dotfiles-public"
DOTFILES_DIR=""
KEEP_STAGING_ON_DRY_RUN="true"
EOF
        chmod 600 "$config_file"
    fi

    # Check config file permissions (must be 600 or 400)
    local perms
    perms=$(stat -c %a "$config_file" 2>/dev/null || stat -f %Lp "$config_file" 2>/dev/null)
    if [[ "$perms" != "600" && "$perms" != "400" ]]; then
        echo_warning "Config file has insecure permissions: $perms"
        echo_info "Fixing permissions to 600..."
        chmod 600 "$config_file"
    fi

    # Source config in a subshell first to validate
    if ! bash -n "$config_file" 2>/dev/null; then
        echo_error "Config file has syntax errors: $config_file"
        return 1
    fi

    # shellcheck source=/dev/null
    source "$config_file"

    # Validate required variables
    if [[ -z "${GITHUB_OWNER:-}" ]]; then
        echo_error "GITHUB_OWNER not set in config"
        return 1
    fi
    if [[ -z "${PUBLIC_REPO:-}" ]]; then
        echo_error "PUBLIC_REPO not set in config"
        return 1
    fi
}

# =============================================================================
# Security: Create secure temporary directory
# =============================================================================
create_secure_tmp() {
    # Create temp dir with mktemp (secure, unpredictable name)
    TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-public.XXXXXXXXXX") || {
        echo_error "Failed to create secure temporary directory"
        return 1
    }

    # Create secure log file
    LOG_FILE=$(mktemp "${TMPDIR:-/tmp}/upload-public-log.XXXXXXXXXX") || {
        echo_error "Failed to create secure log file"
        return 1
    }

    # Ensure proper permissions
    chmod 700 "$TMP_DIR"
    chmod 600 "$LOG_FILE"

    echo_info "Secure temp directory: $TMP_DIR"
    echo_info "Log file: $LOG_FILE"
}

# =============================================================================
# Load patterns from external files
# =============================================================================
load_patterns() {
    local config_dir="$1"
    local exclude_file="${config_dir}/exclude-patterns.conf"
    local dangerous_file="${config_dir}/dangerous-patterns.conf"

    EXCLUDE_PATTERNS=()
    DANGEROUS_CONTENT_PATTERNS=()

    # Load exclude patterns
    if [[ -f "$exclude_file" ]]; then
        while IFS= read -r line || [[ -n "$line" ]]; do
            [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
            EXCLUDE_PATTERNS+=("$line")
        done <"$exclude_file"
        echo_info "Loaded ${#EXCLUDE_PATTERNS[@]} exclude patterns"
    else
        echo_warning "Exclude patterns file not found: $exclude_file"
        EXCLUDE_PATTERNS=(".git" "*secret*" "*private*" "*.key" "*.pem")
    fi

    # Load dangerous content patterns
    if [[ -f "$dangerous_file" ]]; then
        while IFS= read -r line || [[ -n "$line" ]]; do
            [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
            DANGEROUS_CONTENT_PATTERNS+=("$line")
        done <"$dangerous_file"
        echo_info "Loaded ${#DANGEROUS_CONTENT_PATTERNS[@]} dangerous content patterns"
    else
        echo_warning "Dangerous patterns file not found: $dangerous_file"
        DANGEROUS_CONTENT_PATTERNS=(
            "BEGIN RSA PRIVATE KEY"
            "BEGIN PRIVATE KEY"
            "PASSWORD="
            "AKIA[0-9A-Z]{16}"
        )
    fi
}

# =============================================================================
# Build rsync exclude arguments
# =============================================================================
build_rsync_excludes() {
    local excludes=""
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        excludes="$excludes --exclude='$pattern'"
    done
    echo "$excludes"
}

# =============================================================================
# Scan for secrets using regex patterns
# =============================================================================
scan_for_secrets() {
    local dir="$1"
    local found_secrets=false

    echo_info "Scanning for dangerous content patterns..."

    for pattern in "${DANGEROUS_CONTENT_PATTERNS[@]}"; do
        local matches
        matches=$(grep -rliE "$pattern" "$dir" 2>/dev/null || true)
        if [[ -n "$matches" ]]; then
            found_secrets=true
            echo_danger "Pattern '$pattern' found in:"
            echo "$matches" | while read -r file; do
                echo "    - ${file#"$dir"/}"
            done
        fi
    done

    if $found_secrets; then
        return 1
    else
        echo_success "No dangerous content patterns detected"
        return 0
    fi
}

# =============================================================================
# Scan with gitleaks (if available)
# =============================================================================
scan_with_gitleaks() {
    local dir="$1"

    # Check if gitleaks is available
    if ! command -v gitleaks &>/dev/null; then
        echo_warning "gitleaks not installed (optional but recommended)"
        echo_info "Install: https://github.com/gitleaks/gitleaks#installing"
        return 0 # Not a failure, just skip
    fi

    echo_info "Running gitleaks scan (deep secret detection)..."

    local gitleaks_report
    gitleaks_report=$(mktemp "${TMPDIR:-/tmp}/gitleaks-report.XXXXXXXXXX.json")
    chmod 600 "$gitleaks_report"

    # Run gitleaks on the directory (not git history, just files)
    if gitleaks detect --source "$dir" --no-git --report-path "$gitleaks_report" 2>/dev/null; then
        echo_success "gitleaks: No secrets detected"
        rm -f "$gitleaks_report"
        return 0
    else
        echo_danger "gitleaks found potential secrets!"
        echo
        # Parse and display findings
        if command -v jq &>/dev/null && [[ -s "$gitleaks_report" ]]; then
            jq -r '.[] | "  \(.File):\(.StartLine) - \(.Description) [\(.RuleID)]"' "$gitleaks_report" 2>/dev/null | head -20
        else
            echo "  (install jq to see detailed findings, or check: $gitleaks_report)"
        fi
        echo
        rm -f "$gitleaks_report"
        return 1
    fi
}

# =============================================================================
# List staged files
# =============================================================================
list_staged_files() {
    local dir="$1"
    echo_info "Files staged for upload:"
    # Use a temp file to avoid SIGPIPE with head in pipefail mode
    local all_files
    all_files=$(find "$dir" -type f | sed "s|$dir/||" | sort)
    echo "$all_files" | head -100 || true

    local total
    total=$(echo "$all_files" | wc -l)
    if [[ $total -gt 100 ]]; then
        echo "... and $((total - 100)) more files"
    fi
    echo_info "Total: $total files"
}

# =============================================================================
# Ensure GitHub repo exists
# =============================================================================
ensure_repo_exists() {
    local owner="$1"
    local repo="$2"
    local force="${3:-false}"

    if ! gh repo view "$owner/$repo" &>/dev/null; then
        echo_warning "Repository $owner/$repo does not exist"
        if [[ "$force" == "true" ]]; then
            echo_info "Creating repository (--force mode)..."
            gh repo create "$repo" --public --description "Public dotfiles (sanitized)"
            echo_success "Repository created: https://github.com/$owner/$repo"
        else
            read -rp "Create it as a PUBLIC repository? (yes/no): " answer
            if [[ "$answer" == "yes" ]]; then
                gh repo create "$repo" --public --description "Public dotfiles (sanitized)"
                echo_success "Repository created"
            else
                echo_error "Cannot proceed without repository"
                return 1
            fi
        fi
    fi
}

# =============================================================================
# Show configuration
# =============================================================================
show_config() {
    local config_dir="$1"
    local config_file="${config_dir}/config"
    local exclude_file="${config_dir}/exclude-patterns.conf"
    local dangerous_file="${config_dir}/dangerous-patterns.conf"

    echo "Configuration directory: $config_dir"
    echo
    echo "=== Config file ($config_file) ==="
    if [[ -f "$config_file" ]]; then
        cat "$config_file"
    else
        echo "(not found)"
    fi
    echo
    echo "=== Exclude patterns ($exclude_file) ==="
    if [[ -f "$exclude_file" ]]; then
        grep -v '^#' "$exclude_file" | grep -v '^$' | head -20
        local total
        total=$(grep -cvE '^#|^$|^[[:space:]]*$' "$exclude_file")
        [[ $total -gt 20 ]] && echo "... and $((total - 20)) more"
    else
        echo "(not found)"
    fi
    echo
    echo "=== Dangerous content patterns ($dangerous_file) ==="
    if [[ -f "$dangerous_file" ]]; then
        grep -v '^#' "$dangerous_file" | grep -v '^$'
    else
        echo "(not found)"
    fi
}
