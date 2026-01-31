;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-04-05 15:10:26>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-buffer-jumpers.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

(defun my/buffer-jump (buffername)
  "Switch to a buffer if it is open in any window, otherwise open it in the current window."
  (interactive "sEnter buffer name: ")
  (let ((buffer (get-buffer buffername)))
    (if buffer
        (let ((window (get-buffer-window buffer t)))
          (if window
              (select-window window)
            (switch-to-buffer buffer)))
      (message "No buffer named %s exists" buffername))))

(defun my/buffer-named (buffer-name)
  "Open a buffer with the specified BUFFER-NAME. If the buffer does not exist, create it."
  (interactive "sEnter buffer name: ")
  (let ((buffer (get-buffer-create buffer-name)))
    (switch-to-buffer buffer)))

(defun my/buffer-jump-to-messages ()
  (interactive)
  (message "my/jump-to-messages")
  (switch-to-buffer '*Messages*))

(define-key global-map (kbd "C-x C-m") 'my/buffer-jump-to-messages)

(provide '03-ui-000-buffer-jumpers)

(when
    (not load-file-name)
  (message "03-ui-000-buffer-jumpers.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))