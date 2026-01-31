;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-31 06:41:52>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-110-org-00-org-agenda.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; Agenda
;; (setq my/org-agenda-dir "~/proj/org/")
(setq my/org-agenda-dir "~/.dotfiles/.org/")
(setq org-agenda-files (list my/org-agenda-dir))
(setq org-agenda-weekend-days 'nil)

;; Custom Functions

(defun my/org-agenda ()
  (interactive)
  (org-agenda nil "n")
  ;; (org-agenda-maybe-redo)
  (when (equal (buffer-name) "*Org Agenda*") (other-window 1)))

(defun my/org-agenda-to-right ()
  (interactive)
  ;; Check if there is a window to the right
  (unless (window-in-direction 'right)
    ;; If no window to the right, split the current window to the right
    (split-window-right))
  ;; Move focus to the right window
  (other-window 1)
  ;; Open or refresh Org Agenda in the current window
  (my/org-agenda))

;; Bindings

;; (global-set-key (kbd "C-c C-a") nil)
;; (global-set-key (kbd "C-c C-a") 'my/org-agenda)

;; (global-set-key (kbd "C-c C-c") 'org-capture)


(provide '02-base-110-org-00-org-agenda)

(when
    (not load-file-name)
  (message "02-base-110-org-00-org-agenda.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))