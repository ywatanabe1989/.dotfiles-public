# mu4e - Email Client for Emacs

## Overview
mu4e is a powerful email client for Emacs, based on the mu email indexer and searcher.

## Installation
1. Install mu: `sudo apt-get install mu` (Debian/Ubuntu)
2. Add to Emacs init file: `(require 'mu4e)`

## Configuration
```elisp
(setq mu4e-maildir "~/Maildir"
      mu4e-sent-folder "/Sent"
      mu4e-drafts-folder "/Drafts"
      mu4e-trash-folder "/Trash"
      mu4e-refile-folder "/Archive")
```

## Usage
### Reading Emails
- `j`: Jump to maildir
- `s`: Search emails
- `RET`: Open email
- `q`: Quit current view

### Composing Emails
- `C`: Compose new email
- `R`: Reply to email
- `F`: Forward email

### Searching
- `s`: Enter search query
- `b`: Bookmarked searches

### Attachments
- `a`: List attachments
- `e`: Save attachment

## Advanced Features
- Multiple accounts support
- HTML email rendering
- Org-mode integration

## Troubleshooting
- Run `mu index` to rebuild index
- Check ~/.mu4e-errors file for logs

## Resources
- [Official documentation](https://www.djcbsoftware.nl/code/mu/mu4e/)
- [Emacs Wiki](https://www.emacswiki.org/emacs/mu4e)
- [GitHub repository](https://github.com/djcb/mu)
