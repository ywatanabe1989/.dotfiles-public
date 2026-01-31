# Windows Subsystem for Linux (WSL)

## Overview
WSL allows running Linux distributions on Windows.

## Installation
1. Enable WSL feature
2. Install Linux distribution

## Basic Usage
- `wsl`: Enter Linux environment
- `wsl --list`: List installed distributions
- `wsl --shutdown`: Stop all WSL instances

## File System
- Windows: `/mnt/c/`
- Linux: `\\wsl$\<DistroName>\`

## Networking
- Access Windows localhost: `localhost`
- Access WSL from Windows: `localhost:<port>`

## GUI Applications
1. Install X server on Windows
2. Set DISPLAY variable in WSL

## Tips
- Use VSCode Remote-WSL extension
- Configure Windows Terminal for WSL

## Troubleshooting
- Run `wsl --update` for updates
- Check WSL version: `wsl --status`

## Resources
- [Microsoft WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [WSL GitHub repository](https://github.com/microsoft/WSL)
