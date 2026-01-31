;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-02 09:01:32>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/05-tool-999-sqlite.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(use-package esqlite)

(defun my/sqlite-open-file-hook ()
    (sqlite-mode-open-file (buffer-file-name)))

(add-to-list 'auto-mode-alist '("\\.db\\'" . my/sqlite-open-file-hook))
(add-to-list 'auto-mode-alist '("\\.sqlite3\\'" . my/sqlite-open-file-hook))
(add-to-list 'auto-mode-alist '("\\.sqlite\\'" . my/sqlite-open-file-hook))


(provide '05-tool-999-sqlite)

(when
    (not load-file-name)
  (message "05-tool-999-sqlite.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))