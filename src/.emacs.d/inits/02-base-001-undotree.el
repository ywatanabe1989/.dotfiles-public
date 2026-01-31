;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-02 06:25:43>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-001-undotree.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(use-package undo-tree
  :ensure
  t
  :init
  (global-undo-tree-mode)
  :config
  (setq undo-tree-history-directory-alist
        '(("." . "~/.emacs.d/undo-tree-history")))
  (unless (file-exists-p "~/.emacs.d/undo-tree-history")
    (make-directory "~/.emacs.d/undo-tree-history"))
  :custom
  (undo-tree-auto-save-history t)
  :bind
  (("C-/" . undo-tree-undo)
   ("C-;" . undo-tree-redo)
   ;; ("M-_" . undo-tree-redo)  ; Add alternative binding
   ("C-x u" . undo-tree-visualize)))

(global-set-key (kbd "C-/") 'undo-tree-undo)

(global-set-key (kbd "C-.") 'undo-tree-redo)


(provide '02-base-001-undotree)

(when
    (not load-file-name)
  (message "02-base-001-undotree.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))