;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-04-17 09:06:45>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-dired-hide.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

;; (defun --my/dired-show-details ()
;;   "Show dired details and disable omit mode."
;;   (interactive)
;;   (dired-hide-details-mode t)
;;   (dired-omit-mode t))

;; (defun --my/dired-hide-details ()
;;   "Hide dired details, subdirectories, and omit files."
;;   (interactive)
;;   (dired-hide-details-mode nil)
;;   (dired-omit-mode nil)
;;   (dired-hide-subdir))

(defvar --my/dired-details-mode nil)

(defun --my/dired-show-details ()
  "Show dired details and disable omit mode."
  (interactive)
  (setq --my/dired-details-mode nil)
  (dired-hide-details-mode -1)
  (dired-omit-mode -1))

;; -1 to disable omit mode

(defun --my/dired-hide-details ()
  "Hide dired details, subdirectories, and omit files."
  (interactive)
  (setq --my/dired-details-mode t)
  (dired-hide-details-mode 1)
  (dired-omit-mode))

(defun my/dired-toggle-details ()
  "Toggle dired details visibility."
  (interactive)
  (if --my/dired-details-mode
      (--my/dired-show-details)
    (--my/dired-hide-details)))

(provide '03-ui-000-dired-hide)

(when
    (not load-file-name)
  (message "03-ui-000-dired-hide.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))
