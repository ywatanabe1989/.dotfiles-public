;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-03 17:51:06>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-720-diff-hl.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(use-package diff-hl
  :after
  dired
  :config
  (global-diff-hl-mode t)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))


(provide '02-base-720-diff-hl)

(when
    (not load-file-name)
  (message "02-base-720-diff-hl.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))