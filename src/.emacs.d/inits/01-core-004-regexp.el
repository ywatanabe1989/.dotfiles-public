;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:40>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-004-regexp.el

(require 'visual-regexp-steroids)
                                        ; Load visual regexp
(setq vr/engine 'python)
                                        ; Set regexp engine to Python

(provide '01-core-004-regexp)

(when
    (not load-file-name)
  (message "01-core-004-regexp.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))