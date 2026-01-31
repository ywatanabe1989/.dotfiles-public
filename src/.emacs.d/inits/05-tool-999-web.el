;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-11-13 01:03:40>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/05-tool-999-web.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(setq web-mode-content-types-alist
      '(("jsx" . "\\.tsx\\'")))

;; Format on save with Prettier
;; cd /path/to/scitex
;; npm install --save-dev prettier eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin

(use-package prettier-js
  :hook
  ((typescript-mode js-mode web-mode) . prettier-js-mode))


(provide '05-tool-999-web)

(when
    (not load-file-name)
  (message "05-tool-999-web.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))