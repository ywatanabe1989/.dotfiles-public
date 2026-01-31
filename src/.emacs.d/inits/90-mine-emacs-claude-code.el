;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-17 18:28:33>
;;; File: /home/ywatanabe/.emacs.d/inits/90-mine-emacs-claude-code.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; (define-key global-map (kbd "C-S-l") 'ecc-buffer-create)

;; (define-key global-map (kbd "C-c a") 'ecc-auto-toggle)

;; Error running timer ‘ecc-vterm--detect-state’: (void-function ecc-vterm--detect-state) [9 times]
;; Error running timer: (wrong-number-of-arguments (1 . 2) 0)


(provide '90-mine-emacs-claude-code)

(when
    (not load-file-name)
  (message "90-mine-emacs-claude-code.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))