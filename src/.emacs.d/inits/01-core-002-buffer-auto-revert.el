;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-27 17:03:31>
;;; File: /home/ywatanabe/.emacs.d/inits/01-core-002-buffer-auto-revert.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(use-package autorevert
  :defer
  1
  :init
  ;; ;; Revert Dired and other buffers
  ;; (setq global-auto-revert-non-file-buffers t)
  ;; Don't ask for confirmation
  (setq revert-without-query
        '(".*"))
  :config
  ;; Revert buffers when the underlying file has changed
  (global-auto-revert-mode 1)
  ;; automatically update dired buffers on revisiting their directory
  (customize-set-variable 'dired-auto-revert-buffer t))


(provide '01-core-002-buffer-auto-revert)

(when
    (not load-file-name)
  (message "01-core-002-buffer-auto-revert.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))