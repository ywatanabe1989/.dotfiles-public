;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:33>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-002-path-05-update-default-directory.el

(defun update-default-directory ()
  (when buffer-file-name
    (setq default-directory
          (file-name-directory buffer-file-name))))

(add-hook 'find-file-hook #'update-default-directory)
(add-hook 'buffer-list-update-hook #'update-default-directory)

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '01-core-002-path-05-update-default-directory)

(when
    (not load-file-name)
  (message "01-core-002-path-05-update-default-directory.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))