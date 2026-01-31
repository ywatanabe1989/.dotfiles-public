;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:47>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-001-message-login-user.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-28 06:49:57 (ywatanabe)>
;;; File: ./.dotfiles/.emacs.d/inits/001-basic/001-message-login-user.el

(setq-default mode-line-format
              (cons '(:eval (propertize (user-login-name)
                                        'face 'font-lock-keyword-face))
                    mode-line-format))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-001-message-login-user)

(when
    (not load-file-name)
  (message "02-base-001-message-login-user.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))