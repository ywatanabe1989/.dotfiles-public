;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:49>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-001-who-am-i.el

;;; -*- lexical-binding: t -*-
;;; Author: 2024-12-03 21:02:33
;;; Time-stamp: <2024-12-03 21:02:33 (ywatanabe)>
;;; File: ./.dotfiles/.emacs.d/inits/001-basic/001-who-am-i.el

(defun my/whoami ()
  (interactive)
  (message (format "%s" (user-login-name))))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-001-who-am-i)

(when
    (not load-file-name)
  (message "02-base-001-who-am-i.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))