;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:47>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-001-mini-buffer-navigation.el

;; Toggle C-p and C-n for minibuffer history navigation

(define-key minibuffer-local-map
            (kbd "C-p")
            'previous-history-element)

(define-key minibuffer-local-map
            (kbd "C-n")
            'next-history-element)

(define-key minibuffer-local-ns-map
            (kbd "C-p")
            'previous-history-element)

(define-key minibuffer-local-ns-map
            (kbd "C-n")
            'next-history-element)

(define-key minibuffer-local-completion-map
            (kbd "C-p")
            'previous-history-element)

(define-key minibuffer-local-completion-map
            (kbd "C-n")
            'next-history-element)

(with-current-buffer "*Messages*"
  (setq buffer-read-only nil))

(provide '02-base-001-mini-buffer-navigation)

(when
    (not load-file-name)
  (message "02-base-001-mini-buffer-navigation.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))