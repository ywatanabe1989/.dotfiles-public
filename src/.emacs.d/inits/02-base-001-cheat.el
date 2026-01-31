;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:44>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-001-cheat.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-07 15:16:19>
;;; File: ./.dotfiles/.emacs.d/inits/000-cheat.el

(defun my/ct ()
  (interactive)
  (message "/ssh:user@host|sudo:host:/path/to/file")
  (insert "/ssh:user@host|sudo:host:/path/to/file"))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-001-cheat)

(when
    (not load-file-name)
  (message "02-base-001-cheat.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))