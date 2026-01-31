<!-- ---
!-- Timestamp: 2025-08-31 06:12:31
!-- Author: ywatanabe
!-- File: /home/ywatanabe/.dotfiles/.claude/CLAUDE_CODE_SETTING_LOCATIONS.md
!-- --- -->

## Allowed Commands

- Local project settings ()
  `.claude/settings.local.json`
- Shared project settings
  `.claude/settings.json`
- User settings
  `~/.claude/settings.json`

## Memory and Context Files

`CLAUDE.md`

## Subagent
- User-level subagents available across all projects
  `~/.claude/agents/*.md`
- Project-specific subagents
  `.claude/agents/*.md`

## MCP (Model Context Protocol) Configuration
- Project-level MCP server configurations
  `.mcp.json`
- Dinaymic
  `/home/ywatanabe/.claude/mcp-configs-dynamic/mcp-config.json`

## I am not sure about...
`~/.claude.json`

## Credentials
`/home/ywatanabe/.claude/.credentials.json`

<!-- EOF -->