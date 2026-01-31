;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:10:46>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/05-tool-999-google.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-07 15:16:35>
;;; File: ./.dotfiles/.emacs.d/inits/131-google.el

(defalias 'g 'helm-google-suggest)

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '05-tool-999-google)

(when
    (not load-file-name)
  (message "05-tool-999-google.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))