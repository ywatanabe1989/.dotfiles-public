#!/bin/bash
# -*- coding: utf-8 -*-
# Timestamp: "2025-04-05 18:07:25 (ywatanabe)"
# File: /home/ywatanabe/.bin/install_win32yank.sh

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_PATH="$0.log"
touch "$LOG_PATH"


# Download win32yank.exe directly (place in ~/.local/bin)
BIN_DIR=~/.bin
mkdir -p "$BIN_DIR"
curl -L https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip -o /tmp/win32yank.zip
unzip -p /tmp/win32yank.zip win32yank.exe > "$BIN_DIR"/win32yank.exe
chmod +x "$BIN_DIR"/win32yank.exe

# # Add to PATH
# echo 'export PATH="$BIN_DIR:$PATH"' >> ~/.bashrc
# source ~/.bashrc

# # Verify installation
# win32yank.exe --version

# EOF