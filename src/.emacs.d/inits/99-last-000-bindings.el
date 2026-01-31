;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-06 13:23:14>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/99-last-000-bindings.el

(use-package bind-key
  :ensure
  t)

(bind-key* (kbd "<f5>") 'revert-buffer)

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '99-last-000-bindings)

(when
    (not load-file-name)
  (message "99-last-000-bindings.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))