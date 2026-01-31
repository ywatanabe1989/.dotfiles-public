;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-11-24 06:18:46>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-001-other-window.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun my/other-window-forward
    ()
  (interactive)
  (other-window 1))

(defun my/other-window-backward
    ()
  (interactive)
  (other-window -1))

(global-set-key
 (kbd "C-t")
 'my/other-window-forward)

(global-set-key
 (kbd "C-4")
 'my/other-window-backward)

(global-set-key
 (kbd "C-5")
 'my/other-window-backward)

(global-set-key
 (kbd "C-6")
 'my/other-window-backward)

(global-set-key
 (kbd "C-S-t")
 'my/other-window-backward)


(provide '02-base-001-other-window)

(when
    (not load-file-name)
  (message "02-base-001-other-window.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))