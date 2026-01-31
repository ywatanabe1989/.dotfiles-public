#!/bin/bash
# -*- coding: utf-8 -*-
# Timestamp: "2025-05-06 03:44:44 (ywatanabe)"
# File: ./.win-bin/w.sh

THIS_DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"
LOG_PATH="$THIS_DIR/.$(basename $0).log"
touch "$LOG_PATH" >/dev/null 2>&1


# set -ex

usage() {
    echo "Usage: $0 [file(s)]"
    echo "Options:"
    echo " file(s)  Path to file(s) to open (supports wildcards)"
    echo " -h, --help    Display this help message"
    exit 1
}
open_jnb_file() {
    # echo "DEBUG: Opening JNB file: $1"
    local input_file="$(readlink -f "$1")"
    # echo "DEBUG: Absolute path: $input_file"
    local filename=$(basename "$input_file")
    local temp_file="$TEMP_DIR/${filename%.*}_$(date +%Y%m%d_%H%M%S).jnb"
    # echo "DEBUG: Temp file: $temp_file"
    cp -v "$input_file" "$temp_file"
    echo "Opening in 3 seconds..."
    sleep 3
    local win_path=$(wslpath -w "$temp_file")
    # echo "DEBUG: Windows path: $win_path"
    explorer.exe "$win_path"
    read -p "Press Enter when finished..."
    cp "$temp_file" "$input_file"
    rm "$temp_file"
}
main() {
    # echo "DEBUG: Arguments received: $@"
    mkdir -p "$TEMP_DIR"
    [[ "$1" == "-h" || "$1" == "--help" ]] && usage
    [[ $# -eq 0 ]] && { explorer.exe .; exit 0; }
    for file in "$@"; do
        # echo "DEBUG: Processing file: $file"
        file="$(readlink -f "$file")"
        # echo "DEBUG: Absolute path: $file"
        if [[ "${file,,}" == *.jnb ]]; then
            open_jnb_file "$file"
        else
            win_path=$(wslpath -w "$file")
            # echo "DEBUG: Windows path: $win_path"
            explorer.exe "$win_path"
        fi
    done
}
main "$@" 2>&1 | tee "$LOG_FILE"

# EOF