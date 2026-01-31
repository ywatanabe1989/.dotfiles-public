;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:50>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-balanced-windows.el

(use-package balanced-windows)
(balanced-windows-mode t)

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '03-ui-000-balanced-windows)

(when
    (not load-file-name)
  (message "03-ui-000-balanced-windows.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))