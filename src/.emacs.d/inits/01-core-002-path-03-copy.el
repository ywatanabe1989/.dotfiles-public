;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:32>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-002-path-03-copy.el

;; 1. Primary Path Copy Functions
;; ----------------------------------------

(defun my/path-copy-current-path ()
  "Copy the current buffer's file path to the clipboard without resolving symlinks."
  (interactive)
  (let* ((file-path (or buffer-file-name default-directory))
         (path-to-copy (--my/ssh-path-remove-ssh-prefix file-path)))
    (kill-new path-to-copy)
    (message "Copied path: %s" path-to-copy)))

;; 2. Specialized Path Copy Functions
;; ----------------------------------------

(defun my/path-copy-current-script-path ()
  "Copy current script path relative to /scripts/ directory to kill ring."
  (interactive)
  (let ((script-path (my/path-get-path-from "/scripts/")))
    (when script-path
      (kill-new script-path)
      (message "Copied path: %s" script-path))))

(defun my/path-copy-current-path-from-git-root ()
  "Copy current file path from git root to kill ring."
  (interactive)
  (when-let ((git-path (my/path-get-path-from-git-root)))
    (kill-new git-path)
    (message "Copied path: %s" git-path)))

;; 3. Keybindings
;; ----------------------------------------

(bind-key* (kbd "C-c C-f") 'my/path-copy-current-script-path)

;; (defun my/path-copy-current-path ()
;;   "Copy the current buffer's file path to the clipboard without resolving symlinks."
;;   (interactive)
;;   (let* ((file-path (or buffer-file-name default-directory))
;;          (path-to-copy (--my/ssh-path-remove-ssh-prefix file-path)))
;;     (kill-new path-to-copy)
;;     (message "Copied path: %s" path-to-copy)))

;; (defun my/path-copy-current-script-path ()
;;   "Copy current script path relative to /scripts/ directory to kill ring."
;;   (interactive)
;;   (let ((script-path (my/path-get-path-from "/scripts/")))
;;     (when script-path
;;       (kill-new script-path)
;;       (message "Copied path: %s" script-path))))

;; (defun my/path-copy-current-path-from-git-root ()
;;   "Copy current file path from git root to kill ring."
;;   (interactive)
;;   (when-let ((git-path (my/path-get-path-from-git-root)))
;;     (kill-new git-path)
;;     (message "Copied path: %s" git-path)))

;; (bind-key* (kbd "C-c C-f") 'my/path-copy-current-script-path)

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '01-core-002-path-03-copy)

(when
    (not load-file-name)
  (message "01-core-002-path-03-copy.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))