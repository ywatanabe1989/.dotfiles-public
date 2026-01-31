;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-10 21:37:08>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-001-IME-English.el

(defun my/to-en ()
  (interactive)
  ;; Always use English input method
  (setq default-input-method nil)
  (deactivate-input-method))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-001-IME-English)

(when
    (not load-file-name)
  (message "02-base-001-IME-English.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))