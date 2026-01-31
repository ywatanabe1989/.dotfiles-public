;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-09 21:50:30>
;;; File: /home/ywatanabe/.emacs.d/inits/03-ui-000-vterm-10-fix-buffer-name.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

(defvar vterm-fixed-buffer-names t
  "When non-nil, prevent vterm buffer names from being changed by shell prompts.")

(defun my/vterm-prevent-buffer-name-changes (orig-fun &rest args)
  "Advice to prevent vterm buffer names from being changed by the shell prompt."
  (unless vterm-fixed-buffer-names
    (apply orig-fun args)))

(advice-add 'vterm--set-title :around
            #'my/vterm-prevent-buffer-name-changes)

(defun my/vterm-toggle-fixed-buffer-names ()
  "Toggle whether vterm buffer names can be changed by the shell."
  (interactive)
  (setq vterm-fixed-buffer-names (not vterm-fixed-buffer-names))
  (message "Vterm fixed buffer names: %s"
           (if vterm-fixed-buffer-names "enabled" "disabled")))


(provide '03-ui-000-vterm-10-fix-buffer-name)

(when
    (not load-file-name)
  (message "03-ui-000-vterm-10-fix-buffer-name.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))