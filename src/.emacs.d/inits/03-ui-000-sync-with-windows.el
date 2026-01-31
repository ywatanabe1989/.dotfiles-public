;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-04-05 20:54:19>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-sync-with-windows.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

(defvar my/win-sync-file "/mnt/c/Users/wyusu/Documents/wsl-sync.txt"
  "Path to the synchronization file for Windows transfer.")

(defun my/win-sync-send-region (start end)
  "Send the region between START and END to the Windows sync file."
  (interactive "r")
  (let ((content (buffer-substring-no-properties start end)))
    (with-temp-file my/win-sync-file
      (insert content))))

(defun my/win-sync-send-buffer ()
  "Send the entire buffer to the Windows sync file."
  (interactive)
  (my/win-sync-send-region (point-min) (point-max)))

(defun my/win-sync-send-defun ()
  "Send the current function definition to the Windows sync file."
  (interactive)
  (save-excursion
    (mark-defun)
    (my/win-sync-send-region (region-beginning) (region-end))))

(defun my/win-sync-send-line ()
  "Send the current line to the Windows sync file."
  (interactive)
  (my/win-sync-send-region (line-beginning-position)
                           (line-end-position)))

(defun my/win-sync-send-paragraph ()
  "Send the current paragraph to the Windows sync file."
  (interactive)
  (save-excursion
    (mark-paragraph)
    (my/win-sync-send-region (region-beginning) (region-end))))

(defun my/win-sync-open-sync-file ()
  "Open the Windows sync file for direct editing."
  (interactive)
  (find-file my/win-sync-file))

(defun my/win-sync-append-region (start end)
  "Append the region between START and END to the Windows sync file."
  (interactive "r")
  (let ((content (buffer-substring-no-properties start end)))
    (with-temp-buffer
      (when (file-exists-p my/win-sync-file)
        (insert-file-contents my/win-sync-file))
      (goto-char (point-max))
      (insert "\n" content)
      (write-region (point-min) (point-max) my/win-sync-file))))

(provide '03-ui-000-sync-with-windows)

(when
    (not load-file-name)
  (message "03-ui-000-sync-with-windows.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))