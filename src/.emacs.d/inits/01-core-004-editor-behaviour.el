;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:34>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-004-editor-behaviour.el

;; File Handling
(save-place-mode t)
                                        ; Remember cursor position
(setq vc-follow-symlinks t)
                                        ; Follow symlinks
(setq auto-insert-alist nil)
                                        ; Disable auto-insert
(setq delete-auto-save-files t)
                                        ; Delete auto-save files
;; Text Manipulation
(cua-selection-mode t)
                                        ; Enable CUA selection mode
(put 'upcase-region 'disabled nil)
                                        ; Enable upcase region
(put 'downcase-region 'disabled nil)
                                        ; Enable downcase region
(setq comment-style 'multi-line)
                                        ; Use multi-line comment style
(setq mouse-drag-copy-region t)
                                        ; Enable mouse drag to copy
;; Input/Completion
(fset 'yes-or-no-p 'y-or-n-p)

(setopt use-short-answers t)
                                        ; Use y/n instead of yes/no
(setq read-file-name-completion-ignore-case t)
                                        ; Case-insensitive file completion
;; History
(setq history-length 25)
                                        ; Set history length
(savehist-mode t)
                                        ; Save minibuffer history

(provide '01-core-004-editor-behaviour)

(when
    (not load-file-name)
  (message "01-core-004-editor-behaviour.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))