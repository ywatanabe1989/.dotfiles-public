;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:45>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-001-delete-selection-mode.el

;; 1. Mode Configuration
;; ----------------------------------------

(delete-selection-mode t)

;; 2. Key Bindings and Protection
;; ----------------------------------------

(global-unset-key
 (kbd "C-c C-t"))
(put 'delete-selection-mode 'disabled t)

;; ;; Prevent accidental toggling of delete-selection-mode
;; (global-unset-key (kbd "C-c C-t"))
;; (put 'delete-selection-mode 'disabled t)

;; ;; Ensure it's always on at startup
;; (add-hook 'after-init-hook (lambda ()
;;                              (delete-selection-mode 1)))

;; (delete-selection-mode t)

(when
    (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-001-delete-selection-mode)

(when
    (not load-file-name)
  (message "02-base-001-delete-selection-mode.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))