;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:11:11>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/99-last-000-hooks-ext.el

(defun my/mu4e-compose-mode-hook
    ()
  "Hook"
  (flyspell-mode))

(add-hook 'mu4e-compose-mode-hook #'my/mu4e-compose-mode-hook)

(provide '99-last-000-hooks-ext)

(when
    (not load-file-name)
  (message "99-last-000-hooks-ext.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))