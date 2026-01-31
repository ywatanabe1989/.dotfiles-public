#!/bin/bash
# -*- coding: utf-8 -*-
# Timestamp: "2026-01-24 11:13:00 (ywatanabe)"
# File: tests/run_tests.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASSED=0
FAILED=0
SKIPPED=0

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    PASSED=$((PASSED + 1))
}
log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    FAILED=$((FAILED + 1))
}
log_skip() {
    echo -e "${YELLOW}[SKIP]${NC} $1"
    SKIPPED=$((SKIPPED + 1))
}
log_info() { echo -e "[INFO] $1"; }

# Test: Bash syntax validation for all .sh files
test_bash_syntax() {
    log_info "Testing bash syntax..."
    local errors=0

    while IFS= read -r -d '' file; do
        if ! bash -n "$file" 2>/dev/null; then
            log_fail "Syntax error in: $file"
            errors=$((errors + 1))
        fi
    done < <(find "$DOTFILES_DIR/scripts" -name "*.sh" -print0 2>/dev/null)

    if [[ $errors -eq 0 ]]; then
        log_pass "All bash scripts have valid syntax"
    fi
}

# Test: Bash completion scripts syntax
test_completion_syntax() {
    log_info "Testing bash completion scripts..."
    local completion_dir="$DOTFILES_DIR/src/.bash_completion.d"
    local errors=0

    if [[ -d "$completion_dir" ]]; then
        for file in "$completion_dir"/*.bash; do
            [[ -f "$file" ]] || continue
            if ! bash -n "$file" 2>/dev/null; then
                log_fail "Syntax error in: $file"
                errors=$((errors + 1))
            fi
        done

        if [[ $errors -eq 0 ]]; then
            log_pass "All completion scripts have valid syntax"
        fi
    else
        log_skip "No completion directory found"
    fi
}

# Test: Deploy script dry-run
test_deploy_dry_run() {
    log_info "Testing deploy.sh dry-run..."
    local deploy_script="$DOTFILES_DIR/scripts/deploy.sh"

    if [[ -x "$deploy_script" ]]; then
        local output
        output=$("$deploy_script" 2>&1 || true)
        if echo "$output" | grep -q "Dry Run"; then
            log_pass "deploy.sh dry-run works"
        else
            log_fail "deploy.sh dry-run failed"
        fi
    else
        log_skip "deploy.sh not found or not executable"
    fi
}

# Test: Required source files exist
test_required_files() {
    log_info "Testing required files exist..."
    local required_files=(
        "src/.bash_profile"
        "src/.bash.d/all/000_bash_reload_bashd.src"
        "scripts/deploy.sh"
    )
    local missing=0

    for file in "${required_files[@]}"; do
        if [[ ! -f "$DOTFILES_DIR/$file" ]]; then
            log_fail "Missing: $file"
            missing=$((missing + 1))
        fi
    done

    if [[ $missing -eq 0 ]]; then
        log_pass "All required files exist"
    fi
}

# Test: Symlinks in HOME point to src/
test_symlinks() {
    log_info "Testing symlinks point to src/..."
    local errors=0
    local checked=0

    for dotfile in ~/.bash_profile ~/.bash.d; do
        if [[ -L "$dotfile" ]]; then
            local target
            target=$(readlink -f "$dotfile")
            if [[ "$target" == *"/src/"* ]]; then
                checked=$((checked + 1))
            else
                log_fail "Symlink $dotfile does not point to src/: $target"
                errors=$((errors + 1))
            fi
        fi
    done

    if [[ $errors -eq 0 && $checked -gt 0 ]]; then
        log_pass "Symlinks correctly point to src/ ($checked checked)"
    elif [[ $checked -eq 0 ]]; then
        log_skip "No symlinks found to check"
    fi
}

# Test: No secrets in tracked files
test_no_secrets() {
    log_info "Testing for exposed secrets..."
    local patterns=("password=" "api_key=" "secret=" "token=")
    local found=0

    for pattern in "${patterns[@]}"; do
        if git -C "$DOTFILES_DIR" grep -l "$pattern" -- ':(exclude)*.md' ':(exclude)tests/*' ':(exclude)*secrets*' 2>/dev/null | head -1 | grep -q .; then
            log_fail "Potential secret pattern found: $pattern"
            found=$((found + 1))
        fi
    done

    if [[ $found -eq 0 ]]; then
        log_pass "No obvious secrets in tracked files"
    fi
}

# Main
main() {
    echo "========================================"
    echo "Dotfiles Test Suite"
    echo "========================================"
    echo ""

    test_required_files
    test_bash_syntax
    test_completion_syntax
    test_deploy_dry_run
    test_symlinks
    test_no_secrets

    echo ""
    echo "========================================"
    echo -e "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}, ${YELLOW}$SKIPPED skipped${NC}"
    echo "========================================"

    [[ $FAILED -eq 0 ]] && exit 0 || exit 1
}

main "$@"
