;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:49>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-001-which-key.el

(use-package which-key
  :ensure
  t
  :config
  (which-key-mode)
  ;; Ignore mouse events - don't show "no keys to show" for mouse clicks
  (setq which-key-inhibit-regexps '("mouse" "wheel" "drag" "menu")))

(provide '02-base-001-which-key)

(when
    (not load-file-name)
  (message "02-base-001-which-key.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))