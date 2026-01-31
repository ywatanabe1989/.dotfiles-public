;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-12-18 04:05:09>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-vterm-00-init.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; Basic terminal settings
(setq read-process-output-max (* 1024 1024))

(use-package vterm
  :ensure
  t
  :preface
  ;; Check if libtool is installed
  (defun --vterm-check-dependencies ()
    (unless (executable-find "libtool")
      (warn
       "libtool not found. Please install with: sudo apt-get install libtool-bin")
      (setq vterm-install nil)))

  :init
  (--vterm-check-dependencies)

  :config
  ;; Basic configuration
  (setq vterm-max-scrollback 10000)
  (setq vterm-buffer-name-string "%s")
  (setq vterm-shell "/bin/bash")
  (setq vterm-shell-shell-options '("--login"))

  ;; Add to the vterm-mode-hook lambda function, before the closing parenthesis
  (add-hook 'vterm-mode-hook
            (lambda ()
              (setq vterm-copy-exclude-prompt t)
              ;; Exclude prompt when copying
              (setq-local truncate-lines nil)  ; Wrap long lines
              (setq-local word-wrap nil)         ; Wrap at word boundaries
              (setq-local line-move-visual t)  ; Move by visual lines
              (company-mode -1)
              (hl-line-mode 1)
              ;; Force hl-line to update on every command (fixes stale highlight)
              (add-hook 'post-command-hook #'hl-line-highlight nil t)
              (setq-local kill-buffer-query-functions
                          (remq 'process-kill-buffer-query-function
                                kill-buffer-query-functions))
              (--my/vterm-bind-keys)
              ;; Set directory colors to softer cyan
              ;; (vterm-send-string
              ;;  "LS_COLORS='di=00;36:ln=01;36:ex=01;32' && export LS_COLORS\n")
              ))

  ;; Add terminal environment variables for proper color support
  (setq vterm-environment '("TERM=xterm-256color")))

;; Config
;; Improve performance for long lines
(setq-default bidi-display-reordering nil)
(setq-default bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)

;; Remove process query on kill
(setq kill-buffer-query-functions
      (remq 'process-kill-buffer-query-function
            kill-buffer-query-functions))


(provide '03-ui-000-vterm-00-init)

(when
    (not load-file-name)
  (message "03-ui-000-vterm-00-init.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))