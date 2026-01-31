;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-11-29 20:51:20>
;;; File: /home/ywatanabe/.emacs.d/inits/01-core-001-buffer-rename.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

(defun my/rename-buffer ()
  "Rename buffer with current name pre-filled for easy suffix addition."
  (interactive)
  (let* ((current-name (buffer-name))
         (new-name (read-string "Rename buffer: " current-name)))
    (rename-buffer new-name t)))

(global-set-key
 (kbd "C-S-b")
 'my/rename-buffer)

(provide '01-core-001-buffer-rename)

(when
    (not load-file-name)
  (message "01-core-001-buffer-rename.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))
