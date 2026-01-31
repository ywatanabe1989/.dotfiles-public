;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:31>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-002-buffer-revert.el

(defun --my/revert-buffer-no-confirm
    ()
  "Revert buffer without confirmation."
  (interactive)
  (message "Reloaded.")
  (revert-buffer nil t))

(bind-key* "<f5>" '--my/revert-buffer-no-confirm)

;; After Python Blacken-buffer
(advice-add 'python-black-buffer :after
            (lambda
              (&rest _)
              (revert-buffer nil t)))

(provide '01-core-002-buffer-revert)

(when
    (not load-file-name)
  (message "01-core-002-buffer-revert.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))