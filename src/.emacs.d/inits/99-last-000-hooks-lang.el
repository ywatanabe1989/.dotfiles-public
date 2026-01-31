;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-10-25 09:11:22>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/99-last-000-hooks-lang.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun my/web-mode-hook ()
  (when (or
         (string-equal "tsx"
                       (file-name-extension
                        buffer-file-name))
         (string-equal "ts"
                       (file-name-extension
                        buffer-file-name)))
    (setq flycheck-checker 'javascript-eslint)))

(defun my/html-mode-hook ()
  (highlight-indent-guides-mode 1))

(defun my/js-mode-hook ()
  ""
  (setq indent-tabs-mode nil)
  (setq tab-width 4)
  (highlight-indent-guides-mode t)
  (flycheck-mode t)
  (flycheck-pos-tip-mode nil)
  (flycheck-posframe-mode t)
  (add-hook 'before-save-hook 'delete-trailing-whitespace
            nil t))

(add-hook 'html-mode-hook #'my/html-mode-hook)
(add-hook 'csv-mode-hook #'my/csv-mode-hook)
(add-hook 'js-mode-hook #'my/js-mode-hook)
(add-hook 'json-mode-hook #'my/json-mode-hook)
(add-hook 'web-mode-hook #'my/web-mode-hook)

;; Flycheck
(add-hook 'flycheck-after-syntax-check-hook
          'my/flycheck-error-detected)

;; Emacs
(add-hook 'emacs-lisp-mode-hook 'my/emacs-lisp-mode-hook)

;; Python

(defun my/python-mode-hook
    ()
  (highlight-indent-guides-mode -1)
  (epc-flycheck-setup))

(add-hook 'python-mode-hook 'my/python-mode-hook t)


(provide '99-last-000-hooks-lang)

(when
    (not load-file-name)
  (message "99-last-000-hooks-lang.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))