;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-10-29 06:27:55>
;;; File: /home/ywatanabe/.emacs.d/inits/03-ui-000-dired-shell.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun my/dired-shell-execute-command ()
  "Execute shell command in current dired directory without file args."
  (interactive)
  (let ((default-directory (dired-current-directory)))
    (call-interactively 'shell-command)))


(provide '03-ui-000-dired-shell)

(when
    (not load-file-name)
  (message "03-ui-000-dired-shell.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))