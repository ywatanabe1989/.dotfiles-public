;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-11-03 14:45:16>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-basic.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; Startup
(setq inhibit-startup-message t)
                                        ; Disable startup message
(setq inhibit-startup-screen t)
                                        ; Disable startup screen
;; Feedback
(setq use-dialog-box nil)
                                        ; Disable dialog boxes
;; Display
(size-indication-mode t)
                                        ; Show buffer size
;; Scrolling
(pixel-scroll-precision-mode)
                                        ; Enable precise scrolling
(setq scroll-conservatively 1)
                                        ; Smooth scrolling
(setq scroll-step 1)
                                        ; Scroll one line at a time


(provide '03-ui-000-basic)

(when
    (not load-file-name)
  (message "03-ui-000-basic.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))