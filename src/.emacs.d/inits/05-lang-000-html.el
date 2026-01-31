;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:10:40>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/05-lang-000-html.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-07 15:16:43>
;;; File: ./.dotfiles/.emacs.d/inits/400-html.el

(add-to-list 'auto-mode-alist '("\\.html?\\'" . html-mode))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '05-lang-000-html)

(when
    (not load-file-name)
  (message "05-lang-000-html.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))