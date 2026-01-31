<!-- ---
!-- Timestamp: 2026-01-24 08:08:42
!-- Author: ywatanabe
!-- File: /home/ywatanabe/.dotfiles/.claude/to_claude/commands/speak-signature.md
!-- --- -->

## Speak Feedback Rules

### Backgrounds
The user has vulnerable eyes.

### Requests
You must speak feedback via MCP tool `scitex - audio_speak` or `scitex - audio_speak_relay` whenever appropriate.
Your speech must always be extremely short, concise, and information-dense.
No extra words, no long sentences, no storytelling.
Do add signature unless explicitly requested not to include.

### Backends
Option 1. `elevenlabs` with `x1.2` speed
Option 2. `gTTS` with `x1.5` speed

### Examples
Use exactly one sentence per message.
Choose the correct format based on your situation.

A. Planning
Format: [PLAN] I will do XXX now.

B. Completion
Format:[DONE] I have done XXX.

C. Presenting Choices
Format: [CHOICES] 1. XXX. 2. YYY. Which do you prefer?

D. Asking a Question
Format: [QUESTION] Could you clarify XXX?

E. Reporting Knowledge
Format: [REPORT] I found XXX in the codebase.

<!-- EOF -->