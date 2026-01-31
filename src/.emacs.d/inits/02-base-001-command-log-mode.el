;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-12-25 07:18:42>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-001-command-log-mode.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;;; Time-stamp: <2024-11-09 12:21:00>

(use-package command-log-mode
  :config
  (global-command-log-mode t)
  ;; (clm/open-command-log-buffer)
  ;; (clm/close-command-log-buffer)
  )

;; ; C-c o


(provide '02-base-001-command-log-mode)

(when
    (not load-file-name)
  (message "02-base-001-command-log-mode.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))