;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 10:29:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v11.el
;;; Version: 11 - Robust cleanup with error handling

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

;; Version 11: Robust cleanup - handles all edge cases
;; - Safely removes old functions and bindings
;; - Handles any lingering references
;; - Immediate function definition before cleanup
;; - FIXED double TRAMP prefix issue

;; FIRST: Define the new function IMMEDIATELY
;; ----------------------------------------

(defun my/rg-search-v11 (query)
  "V11: WORKING search function defined first."
  (interactive "sV11 Search: ")
  (message "V11: Starting search for '%s'" query)
  (message "V11: Directory: %s" default-directory)
  
  ;; Get search directory
  (let ((search-directory
         (cond
          ((and (eq major-mode 'dired-mode)
                (fboundp 'my/path-get-path))
           (my/path-get-path))
          ((eq major-mode 'dired-mode)
           (dired-current-directory))
          (t default-directory))))
    
    (message "V11: Search directory: %s" search-directory)
    
    ;; Remote vs local
    (if (file-remote-p search-directory)
        (let ((default-directory search-directory))
          (message "V11: Using remote search")
          (my/rg-remote-v11 query))
      (let ((default-directory search-directory))
        (message "V11: Using local rg-project")
        (rg-project query "*")))))

(defun my/rg-remote-v11 (query)
  "V11: Remote search with FIXED paths."
  (message "V11: Remote search function called")
  
  (let* ((remote-prefix (file-remote-p default-directory))
         (local-path (file-remote-p default-directory 'localname))
         (buffer-name "*rg-v11*"))
    
    (message "V11: Remote prefix: %s" remote-prefix)
    (message "V11: Local path: %s" local-path)
    
    (let ((buffer (get-buffer-create buffer-name)))
      (with-current-buffer buffer
        (setq-local default-directory default-directory)
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert "V11 Remote Search Results\n")
          (insert "========================\n\n")
          (insert (format "Directory: %s\n" default-directory))
          (insert (format "Query: %s\n" query))
          (insert (format "Remote prefix: %s\n" remote-prefix))
          (insert (format "Local path: %s\n\n" local-path)))
        
        ;; Use compilation-mode
        (compilation-mode)
        (setq-local compilation-search-path (list default-directory)))
      
      ;; Execute search
      (let* ((flags "--line-number --column --heading --no-config --max-count=100")
             (cmd (format "~/.local/bin/rg %s %s ." flags (shell-quote-argument query)))
             (result (shell-command-to-string cmd)))
        
        (message "V11: Command: %s" cmd)
        (message "V11: Result length: %d" (length result))
        
        (with-current-buffer buffer
          (let ((inhibit-read-only t))
            (goto-char (point-max))
            (insert "\nRAW OUTPUT:\n")
            (insert result)
            (insert "\n\nFORMATTED OUTPUT:\n")
            
            ;; Simple formatting - just fix the paths
            (let ((lines (split-string result "\n" t)))
              (dolist (line lines)
                (cond
                 ;; File header lines (start with ./)
                 ((string-match "^\\(\\./[^:]+\\)$" line)
                  (let* ((file-path (match-string 1 line))
                         ;; FIXED: Build correct TRAMP path
                         (abs-path (expand-file-name file-path local-path))
                         (tramp-path (concat remote-prefix abs-path)))
                    (message "V11: File %s -> %s -> %s" file-path abs-path tramp-path)
                    (insert (format "\n%s:\n" tramp-path))))
                 ;; Content lines (line:col:content)
                 ((string-match "^\\([0-9]+\\):\\([0-9]+\\):\\(.+\\)$" line)
                  (insert (format "  %s\n" line)))
                 ;; Other lines
                 (t (insert (format "%s\n" line))))))
            
            ;; Make writable for wgrep
            (setq buffer-read-only nil)
            (when (fboundp 'wgrep-setup) (wgrep-setup))
            
            ;; Add keybindings
            (local-set-key (kbd "w") 'wgrep-change-to-wgrep-mode)
            (local-set-key (kbd "C-c C-c") 'wgrep-finish-edit)
            (local-set-key (kbd "RET") 'compile-goto-error))))
      
      (pop-to-buffer buffer)
      (message "V11: Search completed, buffer: %s" buffer-name))))

;; SECOND: Robust cleanup AFTER defining new functions
;; ----------------------------------------

(message "V11: Starting cleanup...")

;; Safe cleanup with error handling
(condition-case err
    (progn
      (when (fboundp 'my/rg-search)
        (fmakunbound 'my/rg-search)
        (message "V11: Removed my/rg-search"))
      (when (fboundp 'my/rg-search-remote-fast)
        (fmakunbound 'my/rg-search-remote-fast)
        (message "V11: Removed my/rg-search-remote-fast"))
      ;; Clear any existing keybinding
      (global-unset-key (kbd "C-S-g"))
      (message "V11: Cleared C-S-g"))
  (error (message "V11: Cleanup error: %s" err)))

;; THIRD: Set new keybinding
;; ----------------------------------------

(global-set-key (kbd "C-S-g") 'my/rg-search-v11)
(message "V11: Set C-S-g to my/rg-search-v11")

;; Verify binding
(let ((binding (key-binding (kbd "C-S-g"))))
  (message "V11: C-S-g binding verified: %s" binding)
  (message "V11: Function exists: %s" (fboundp 'my/rg-search-v11))
  (message "V11: Is command: %s" (commandp 'my/rg-search-v11)))

;; FOURTH: Package setup
;; ----------------------------------------

(use-package wgrep
  :ensure t
  :config
  (setq wgrep-enable-key "w") 
  (setq wgrep-auto-save-buffer t)
  (setq wgrep-change-readonly-file t))

(use-package rg
  :ensure t
  :config
  (rg-enable-default-bindings)
  (define-key rg-mode-map (kbd "RET") 'compile-goto-error))

;; Final message
(message "=== V11 LOADED SUCCESSFULLY ===")
(message "V11: Try C-S-g now - should work without errors")

(provide '02-base-230-wgrep-ripgrep-v11)

(when (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v11.el loaded - ROBUST CLEANUP"))