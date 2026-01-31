;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-08-31 06:16:25>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-buffer-navigation.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun _my/go-to-messages ()
  "Switch to the *Messages* buffer."
  (interactive)
  (switch-to-buffer "*Messages*"))

(defvar --my/jump-start-window nil
  "Store the window from which we jumped to terminal.")

(defun --my/try-jump-to-terminal ()
  "Try to jump to terminal once. Return t if found."
  (interactive)
  (let ((initial-window (selected-window))
        (current-window (selected-window))
        (found nil))
    (while (and (not found)
                (not (eq (setq current-window
                               (next-window current-window))
                         initial-window)))
      (select-window current-window)
      (when (eq major-mode 'term-mode)
        (setq found t)))
    (unless found
      (select-window initial-window))
    found))

(defun my/jump-to-closest-terminal ()
  "Go to the closest terminal buffer window."
  (interactive)
  (setq --my/jump-start-window (selected-window))
  (unless (--my/try-jump-to-terminal)
    (when (and (get-buffer "*GenAI*")
               (get-buffer-window "*GenAI*")
               (string= (buffer-name) "*GenAI*"))
      (quit-window)
      (--my/try-jump-to-terminal))))

(defun my/back-jump-from-terminal ()
  "Go back to the previous window from terminal."
  (interactive)
  (when --my/jump-start-window
    (select-window --my/jump-start-window)))

(global-set-key (kbd "C-c m") '_my/go-to-messages)
;; (global-set-key (kbd "C-c C-n") 'next-buffer)
;; (global-set-key (kbd "C-c C-p") 'previous-buffer)


(provide '03-ui-000-buffer-navigation)

(when
    (not load-file-name)
  (message "03-ui-000-buffer-navigation.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))