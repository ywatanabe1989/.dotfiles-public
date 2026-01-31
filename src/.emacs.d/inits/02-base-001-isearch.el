;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:46>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-001-isearch.el

(global-set-key
 (kbd "C-s")
 'isearch-forward)

(global-set-key
 (kbd "C-r")
 'isearch-backward)

(global-set-key
 (kbd "C-M-s")
 'isearch-forward-regexp)

(global-set-key
 (kbd "C-M-r")
 'isearch-backward-regexp)

(provide '02-base-001-isearch)

(when
    (not load-file-name)
  (message "02-base-001-isearch.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))