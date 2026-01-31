;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-11-03 14:45:17>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-bell.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

;; Feedback
(setq ring-bell-function 'ignore)  ; Disable bell (use 'ignore instead of nil to avoid funcall nil error)
(setq visible-bell nil)            ; Disable visible bell to use audible bell

(provide '03-ui-000-bell)

(when
    (not load-file-name)
  (message "03-ui-000-bell.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))
