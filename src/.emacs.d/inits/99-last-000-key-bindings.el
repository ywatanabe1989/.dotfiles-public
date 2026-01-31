;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-10-14 11:35:49>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/99-last-000-key-bindings.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; ;; Escape
;; (define-key key-translation-map (kbd "ESC") 'execute-extended-command)
;; (define-key key-translation-map (kbd "ESC") (kbd "ESC"))
;; (define-key key-translation-map (kbd "C-x C-m") ' openbuffer *Message*)
;; (define-key key-translation-map (kbd "C-x C-m") 'open-buffer)
;; Backspace

;; (define-key key-translation-map (kbd "M-RET") 'whisper-live-run)

(define-key key-translation-map
            (kbd "C-h")
            (kbd "<DEL>"))

(define-key global-map
            (kbd "C-S-h")
            #'help)

(define-key global-map
            (kbd "C-x C-m")
            (lambda
              ()
              (interactive)
              (switch-to-buffer "*Messages*")))

(define-key global-map
            (kbd "C-x C-m")
            #'(lambda
                ()
                (interactive)
                (switch-to-buffer "*Messages*")))

;; Next line

(define-key global-map
            (kbd "C-n")
            #'next-line)

;; New line and indent

(define-key global-map
            (kbd "C-m")
            #'newline-and-indent)

;; Frame

(define-key global-map
            (kbd "C-x f")
            #'make-frame)

;; Navigation

(bind-key* "C-t" #'other-window)

(bind-key* "C-S-t" #'my/other-window-backward)

;; Magit

(global-set-key
 (kbd "C-x g")
 'magit-status)

(global-set-key
 (kbd "C-c d")
 'magit-diff-buffer-file)

(define-key global-map
            (kbd "C-M-d")
            'my/delete-trailing-whitespace)

;; (define-key global-map
;;             (kbd "C-c C-f")
;;             'my/find-file-in-term-directory)

(define-key pdf-view-mode-map
            (kbd "M-h")
            'pdf-annot-add-highlight-markup-annotation)

;; call-or-test-this-function

(global-set-key
 (kbd "C-c C-c")
 'my/call-or-test-this-function)


(provide '99-last-000-key-bindings)

(when
    (not load-file-name)
  (message "99-last-000-key-bindings.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))