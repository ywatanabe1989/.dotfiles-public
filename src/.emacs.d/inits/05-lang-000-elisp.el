;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-27 14:22:55>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/05-lang-000-elisp.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(require 'elinter)

;; Key Binding and Hook
;; ----------------------------------------

(define-key emacs-lisp-mode-map
            (kbd "C-c C-l")
            'elinter-lint-buffer)

;; Before saving

(defun my/emacs-lisp-mode-hook ()
  (flycheck-mode t)
  (add-hook 'before-save-hook 'ehf-update-header-and-footer nil t)
  (add-hook 'before-save-hook 'elinter-lint-buffer nil t)
)


(provide '05-lang-000-elisp)

(when
    (not load-file-name)
  (message "05-lang-000-elisp.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))
