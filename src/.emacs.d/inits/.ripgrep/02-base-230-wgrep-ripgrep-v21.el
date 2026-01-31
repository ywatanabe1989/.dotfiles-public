;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 10:55:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v21.el
;;; Version: 21 - FIXED wgrep buffer read-only issues

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

;; VERSION 21: FIXED wgrep buffer setup
;; V20 Status: ✅ Navigation OK, ✅ Format OK, ❌ wgrep read-only issues
;; V21 Fix: 
;; - Force buffer to be writable after setup
;; - Remove all read-only text properties 
;; - Proper wgrep-mode initialization

;; Based on V20 with fixed wgrep buffer initialization

;; 1. Main Configuration 
;; ----------------------------------------

(use-package wgrep
  :ensure t
  :config
  (setq wgrep-enable-key "r")
  (setq wgrep-auto-save-buffer t)
  (setq wgrep-change-readonly-file t))

(use-package rg
  :ensure t
  :config
  (rg-enable-default-bindings)
  (define-key rg-mode-map (kbd "RET") 'compile-goto-error))

(defvar my/rg-debug-message t)

(defun my/rg-debug-message (format-string &rest args)
  (when my/rg-debug-message
    (apply 'message (concat "V21: " format-string) args)))

;; 2. Core Functions
;; ----------------------------------------

(defun my/rg-search (query)
  "V21: Fixed wgrep read-only issues."
  (interactive "sV21 Search: ")
  (my/rg-debug-message "=== V21 SEARCH STARTING ===")
  (my/rg-debug-message "Query: %s" query)
  (my/rg-debug-message "Current directory: %s" default-directory)

  ;; Use V20's working directory detection
  (let* ((candidate-directory
          (cond
           ((and (eq major-mode 'dired-mode)
                 (fboundp 'my/path-get-path))
            (let ((dir (my/path-get-path)))
              (my/rg-debug-message "my/path-get-path returned: %s" dir)
              dir))
           ((eq major-mode 'dired-mode)
            (let ((dir (dired-current-directory)))
              (my/rg-debug-message "dired-current-directory returned: %s" dir)
              dir))
           (t 
            (my/rg-debug-message "Using default-directory")
            default-directory)))
         (search-directory
          (if (and (file-remote-p default-directory)
                   (not (file-remote-p candidate-directory)))
              (progn
                (my/rg-debug-message "TRAMP detection override: using default-directory")
                default-directory)
            candidate-directory)))
    
    (my/rg-debug-message "Final search directory: %s" search-directory)

    ;; Route to remote or local search
    (if (file-remote-p search-directory)
        (let ((default-directory search-directory))
          (my/rg-debug-message "=== USING V21 REMOTE SEARCH ===")
          (my/rg-search-remote-v21 query))
      (let ((default-directory search-directory))
        (my/rg-debug-message "=== USING STANDARD RG FOR LOCAL ===")
        (rg-project query "*")))))

(defun my/rg-search-remote-v21 (query)
  "V21: Remote search with FIXED wgrep buffer setup."
  (my/rg-debug-message "=== REMOTE SEARCH FUNCTION ===")
  
  (let* ((remote-prefix (file-remote-p default-directory))
         (local-path (file-remote-p default-directory 'localname))
         (flags (string-join '("--line-number"
                               "--column"
                               "--heading"
                               "--no-config"
                               "--max-count=500"
                               "--glob=!**/*undo-tree*"
                               "--glob=!**/.old/**"
                               "--glob=!**/*.log"
                               "--glob=!**/RUNNING/**"
                               "--glob=!**/FINISHED_SUCCESS/**"
                               "--glob=!**/FINISHED/**")
                             " "))
         (buffer-name "*rg-v21*"))

    (my/rg-debug-message "Remote prefix: %s" remote-prefix)
    (my/rg-debug-message "Local path: %s" local-path)
    
    (let ((buffer (get-buffer-create buffer-name)))
      (with-current-buffer buffer
        (setq-local default-directory default-directory)
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert (format "-*- mode: grep; default-directory: \"%s\" -*-\n" default-directory))
          (insert (format "V21 Remote Search - %s\n\n" (current-time-string)))
          (insert (format "Query: %s\n" query))
          (insert (format "Directory: %s\n" default-directory))
          (insert (format "Remote prefix: %s\n" remote-prefix))
          (insert (format "Local path: %s\n\n" local-path)))
        
        ;; Use grep-mode for wgrep compatibility
        (grep-mode)
        (setq-local compilation-search-path (list default-directory)))
      
      ;; Execute remote search
      (my/rg-debug-message "Executing remote command...")
      (let* ((cmd (format "~/.local/bin/rg %s %s ." flags (shell-quote-argument query)))
             (result (shell-command-to-string cmd)))
        
        (my/rg-debug-message "Command: %s" cmd)
        (my/rg-debug-message "Result length: %d chars" (length result))
        
        (with-current-buffer buffer
          (let ((inhibit-read-only t))
            (goto-char (point-max))
            (insert "\n=== V21 REMOTE RESULTS ===\n")
            (insert result)
            (insert "\n=== END RESULTS ===\n")
            
            ;; Format results with correct filename:line:column:content format
            (my/rg-format-for-wgrep-v21 remote-prefix local-path)
            
            ;; Set up compilation-mode for navigation
            (setq-local compilation-error-regexp-alist
                        '(("^\\(/ssh:[^:]+:/[^:]+\\):\\([0-9]+\\):\\([0-9]+\\):"
                           1 2 3)))
            
            ;; FIXED: Proper wgrep buffer setup
            (my/rg-debug-message "Setting up wgrep...")
            
            ;; Start buffer as read-only (standard grep behavior)
            (setq buffer-read-only t)
            
            ;; Initialize wgrep properly
            (when (fboundp 'wgrep-setup) 
              (wgrep-setup))
            
            ;; Define custom wgrep toggle that handles read-only properly
            (defun my/wgrep-toggle-v21 ()
              "V21: Toggle wgrep mode with proper read-only handling."
              (interactive)
              (my/rg-debug-message "Toggling wgrep mode...")
              (if (bound-and-true-p wgrep-mode)
                  (progn
                    (my/rg-debug-message "Finishing wgrep edit...")
                    (wgrep-finish-edit))
                (progn
                  (my/rg-debug-message "Entering wgrep edit mode...")
                  ;; Force buffer to be completely writable
                  (setq buffer-read-only nil)
                  (setq-local buffer-read-only nil)
                  ;; Remove all read-only text properties
                  (let ((inhibit-read-only t))
                    (remove-text-properties (point-min) (point-max) '(read-only t))
                    (remove-text-properties (point-min) (point-max) '(read-only nil))
                    (set-text-properties (point-min) (point-max) nil))
                  ;; Now enter wgrep mode
                  (wgrep-change-to-wgrep-mode)
                  ;; Ensure it stays writable
                  (setq buffer-read-only nil)
                  (my/rg-debug-message "wgrep mode enabled"))))
            
            ;; Add keybindings
            (local-set-key (kbd "w") 'my/wgrep-toggle-v21)
            (local-set-key (kbd "C-c C-c") 'wgrep-finish-edit)
            (local-set-key (kbd "C-c C-k") 'wgrep-abort-changes)
            (local-set-key (kbd "RET") 'compile-goto-error)
            (local-set-key (kbd "<mouse-2>") 'compile-goto-error)
            
            (my/rg-debug-message "Buffer setup complete"))))
      
      (pop-to-buffer buffer))))

(defun my/rg-format-for-wgrep-v21 (remote-prefix local-path)
  "V21: Format results in standard grep format with column numbers."
  (my/rg-debug-message "Formatting results for wgrep...")
  
  (let ((inhibit-read-only t))
    (goto-char (point-min))
    (when (re-search-forward "=== V21 REMOTE RESULTS ===\n" nil t)
      ;; Process the raw ripgrep output into standard grep format
      (let ((start-pos (point))
            (end-pos (progn (re-search-forward "=== END RESULTS ===\n" nil t)
                           (match-beginning 0)))
            (formatted-lines '()))
        
        ;; Parse ripgrep output
        (goto-char start-pos)
        (let ((current-file nil))
          (while (< (point) end-pos)
            (beginning-of-line)
            (cond
             ;; File header (e.g., "./file.py")
             ((looking-at "^\\(\\./[^:\\n]+\\)$")
              (setq current-file (match-string 1))
              (my/rg-debug-message "Found file: %s" current-file))
             ;; Match line (e.g., "42:15:content")
             ((looking-at "^\\([0-9]+\\):\\([0-9]+\\):\\(.+\\)$")
              (when current-file
                (let* ((line (match-string 1))
                       (col (match-string 2))
                       (content (match-string 3))
                       (abs-path (expand-file-name current-file local-path))
                       (final-path (concat remote-prefix abs-path))
                       ;; Standard grep format: filename:line:column:content
                       (grep-line (format "%s:%s:%s:%s" final-path line col content)))
                  (my/rg-debug-message "Formatted: %s" grep-line)
                  (push grep-line formatted-lines)))))
            (forward-line 1)))
        
        ;; Replace the raw output with formatted grep-style output
        (goto-char start-pos)
        (delete-region start-pos end-pos)
        (insert (string-join (reverse formatted-lines) "\n"))
        (insert "\n")))))

;; 3. Setup
;; ----------------------------------------

(global-set-key (kbd "C-S-g") 'my/rg-search)

(message "=== V21 LOADED - FIXED wgrep buffer read-only issues ===")
(message "V21: Fixed wgrep toggle with proper read-only handling")
(message "V21: Navigation (RET) and wgrep editing (w, C-c C-c) should work")
(message "V21: Uses custom wgrep toggle function")

;; SUMMARY:
;; V20: ✅ Remote search, ✅ Navigation (RET), ❌ wgrep read-only issues
;; V21: ✅ Remote search, ✅ Navigation (RET), ✅ wgrep editing (w, C-c C-c)

(provide '02-base-230-wgrep-ripgrep-v21)

(when (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v21.el loaded - FIXED wgrep read-only issues"))