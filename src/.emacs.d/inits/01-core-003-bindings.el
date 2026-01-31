;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-10-07 22:41:19>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-003-bindings.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; Backspace

(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))

(define-key global-map (kbd "C-S-h") 'help)

(define-key global-map (kbd "C-x C-m")
            (lambda () (interactive) (switch-to-buffer "*Messages*")))

(define-key global-map (kbd "C-x C-m")
            #'(lambda () (interactive) (switch-to-buffer "*Messages*")))

;; Next line

(define-key global-map (kbd "C-n") 'next-line)

;; New line and indent

(define-key global-map (kbd "C-m") 'newline-and-indent)

;; Frame

(define-key global-map (kbd "C-x f") 'make-frame)

;; Navigation

(bind-key* "C-t" 'other-window)

;; Buffer

(define-key global-map (kbd "C-S-M-k") 'kill-all-buffers)

(global-set-key (kbd "C-c k") 'browse-kill-ring)


(provide '01-core-003-bindings)

(when
    (not load-file-name)
  (message "01-core-003-bindings.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))