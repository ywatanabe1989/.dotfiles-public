;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-04-05 15:09:40>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-buffer-key-bindings.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

(defun my/ibuffer-bind-keys ()
  (define-key ibuffer-mode-map (kbd "M-s") nil)
  (define-key ibuffer-mode-map (kbd "s") nil)
  (define-key ibuffer-mode-map (kbd "s") 'my/buffer-ibuffer-sort))

(provide '03-ui-000-buffer-key-bindings)

(when
    (not load-file-name)
  (message "03-ui-000-buffer-key-bindings.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))