;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 10:52:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v20.el
;;; Version: 20 - FIXED navigation and wgrep format

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

;; VERSION 20: FIXED navigation and wgrep format
;; V19 Issues: ❌ Navigation NG "No grep hit here", ❌ Missing column in format
;; V20 Fix: 
;; - Correct filename:line:column:content format for both navigation and wgrep
;; - Fixed compilation-error-regexp-alist to match the actual format
;; - Proper wgrep buffer setup

;; Based on V19 but with corrected output format that matches standard grep

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
    (apply 'message (concat "V20: " format-string) args)))

;; 2. Core Functions
;; ----------------------------------------

(defun my/rg-search (query)
  "V20: Fixed navigation and wgrep format."
  (interactive "sV20 Search: ")
  (my/rg-debug-message "=== V20 SEARCH STARTING ===")
  (my/rg-debug-message "Query: %s" query)
  (my/rg-debug-message "Current directory: %s" default-directory)

  ;; Use V19's working directory detection
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
          (my/rg-debug-message "=== USING V20 REMOTE SEARCH ===")
          (my/rg-search-remote-v20 query))
      (let ((default-directory search-directory))
        (my/rg-debug-message "=== USING STANDARD RG FOR LOCAL ===")
        (rg-project query "*")))))

(defun my/rg-search-remote-v20 (query)
  "V20: Remote search with FIXED navigation and wgrep format."
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
         (buffer-name "*rg-v20*"))

    (my/rg-debug-message "Remote prefix: %s" remote-prefix)
    (my/rg-debug-message "Local path: %s" local-path)
    
    (let ((buffer (get-buffer-create buffer-name)))
      (with-current-buffer buffer
        (setq-local default-directory default-directory)
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert (format "-*- mode: grep; default-directory: \"%s\" -*-\n" default-directory))
          (insert (format "V20 Remote Search - %s\n\n" (current-time-string)))
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
            (insert "\n=== V20 REMOTE RESULTS ===\n")
            (insert result)
            (insert "\n=== END RESULTS ===\n")
            
            ;; FIXED: Format results with correct filename:line:column:content format
            (my/rg-format-for-wgrep-v20 remote-prefix local-path)
            
            ;; FIXED: Set up compilation-mode for navigation with correct regexp
            (setq-local compilation-error-regexp-alist
                        '(("^\\(/ssh:[^:]+:/[^:]+\\):\\([0-9]+\\):\\([0-9]+\\):"
                           1 2 3)))
            
            ;; Set up wgrep properly
            (setq buffer-read-only t)  ; Start read-only like standard grep
            (when (fboundp 'wgrep-setup) (wgrep-setup))
            
            ;; Add keybindings
            (local-set-key (kbd "w") 'wgrep-change-to-wgrep-mode)
            (local-set-key (kbd "C-c C-c") 'wgrep-finish-edit)
            (local-set-key (kbd "C-c C-k") 'wgrep-abort-changes)
            (local-set-key (kbd "RET") 'compile-goto-error)
            (local-set-key (kbd "<mouse-2>") 'compile-goto-error))))
      
      (pop-to-buffer buffer))))

(defun my/rg-format-for-wgrep-v20 (remote-prefix local-path)
  "V20: FIXED format - includes column number for both navigation and wgrep."
  (my/rg-debug-message "Formatting results for wgrep...")
  
  (let ((inhibit-read-only t))
    (goto-char (point-min))
    (when (re-search-forward "=== V20 REMOTE RESULTS ===\n" nil t)
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
                       ;; FIXED: Standard grep format with column: filename:line:column:content
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

(message "=== V20 LOADED - FIXED navigation and wgrep format ===")
(message "V20: Based on V19 with corrected filename:line:column:content format")
(message "V20: FIXED navigation (RET) and wgrep editing (w, C-c C-c)")
(message "V20: Uses proper grep-mode buffer format")

;; SUMMARY:
;; V19: ✅ Remote search, ❌ Navigation NG, ❌ Format issues
;; V20: ✅ Remote search, ✅ Navigation (RET), ✅ wgrep editing (w, C-c C-c)

(provide '02-base-230-wgrep-ripgrep-v20)

(when (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v20.el loaded - FIXED navigation and format"))