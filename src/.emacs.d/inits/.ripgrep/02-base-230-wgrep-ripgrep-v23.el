;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 11:10:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v23.el
;;; Version: 23 - Simplified wgrep format with header line

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

;; VERSION 23: Simplified format matching standard grep output exactly
;; V22 Issues: ❌ Still "Text is read-only" - possibly due to format issues
;; V23 Fix: 
;; - Simpler format without debug sections
;; - Add proper grep header line
;; - Ensure output matches standard grep format exactly
;; - Sort output by file for better structure

;; Based on V22 with simplified output format

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

(defvar my/rg-debug-message nil)  ;; Disable debug messages for cleaner output

(defun my/rg-debug-message (format-string &rest args)
  (when my/rg-debug-message
    (apply 'message (concat "V23: " format-string) args)))

;; 2. Core Functions
;; ----------------------------------------

(defun my/rg-search (query)
  "V23: Simplified format for wgrep compatibility."
  (interactive "sV23 Search: ")
  (my/rg-debug-message "=== V23 SEARCH STARTING ===")
  (my/rg-debug-message "Query: %s" query)
  (my/rg-debug-message "Current directory: %s" default-directory)

  ;; Use working directory detection
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
          (my/rg-debug-message "=== USING V23 REMOTE SEARCH ===")
          (my/rg-search-remote-v23 query))
      (let ((default-directory search-directory))
        (my/rg-debug-message "=== USING STANDARD RG FOR LOCAL ===")
        (rg-project query "*")))))

(defun my/rg-search-remote-v23 (query)
  "V23: Remote search with simplified grep-compatible format."
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
         (buffer-name "*rg-v23*"))

    (my/rg-debug-message "Remote prefix: %s" remote-prefix)
    (my/rg-debug-message "Local path: %s" local-path)
    
    ;; Execute remote search FIRST to get results
    (my/rg-debug-message "Executing remote command...")
    (let* ((cmd (format "~/.local/bin/rg %s %s ." flags (shell-quote-argument query)))
           (result (shell-command-to-string cmd)))
      
      (my/rg-debug-message "Command: %s" cmd)
      (my/rg-debug-message "Result length: %d chars" (length result))
      
      ;; Create and setup buffer
      (let ((buffer (get-buffer-create buffer-name)))
        (with-current-buffer buffer
          (setq-local default-directory default-directory)
          (let ((inhibit-read-only t))
            (erase-buffer)
            
            ;; SIMPLIFIED: Just the standard grep header
            (insert (format "-*- mode: grep; default-directory: \"%s\" -*-\n\n" default-directory))
            (insert (format "rg --line-number --column %s\n\n" (shell-quote-argument query)))
            
            ;; Format and insert results DIRECTLY (no debug sections)
            (my/rg-insert-formatted-results-v23 result remote-prefix local-path)
            
            ;; Set up grep-mode AFTER inserting content
            (grep-mode)
            (setq-local compilation-search-path (list default-directory))
            
            ;; Set up compilation-mode for navigation
            (setq-local compilation-error-regexp-alist
                        '(("^\\(/ssh:[^:]+:[^:]+\\):\\([0-9]+\\):\\([0-9]+\\):"
                           1 2 3)))
            
            ;; Set buffer read-only initially
            (setq buffer-read-only t)
            
            ;; Initialize wgrep 
            (when (fboundp 'wgrep-setup)
              (wgrep-setup))
            
            ;; Add keybindings
            (local-set-key (kbd "w") 'wgrep-change-to-wgrep-mode)
            (local-set-key (kbd "C-c C-p") 'wgrep-change-to-wgrep-mode)
            (local-set-key (kbd "C-c C-c") 'wgrep-finish-edit)
            (local-set-key (kbd "C-c C-k") 'wgrep-abort-changes)
            (local-set-key (kbd "RET") 'compile-goto-error)
            (local-set-key (kbd "<mouse-2>") 'compile-goto-error)))
        
        (pop-to-buffer buffer)))))

(defun my/rg-insert-formatted-results-v23 (result remote-prefix local-path)
  "V23: Insert formatted results with proper wgrep text properties.
Simpler approach - format results and set properties in one pass."
  (my/rg-debug-message "Formatting and inserting results...")
  
  (let ((inhibit-read-only t)
        (lines-by-file '()))
    
    ;; Parse ripgrep output and group by file
    (with-temp-buffer
      (insert result)
      (goto-char (point-min))
      (let ((current-file nil))
        (while (not (eobp))
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
                     (entry (list final-path line col content)))
                ;; Group by file
                (let ((file-group (assoc final-path lines-by-file)))
                  (if file-group
                      (setcdr file-group (append (cdr file-group) (list entry)))
                    (push (list final-path entry) lines-by-file)))))))
          (forward-line 1))))
    
    ;; Insert sorted results with proper properties
    (dolist (file-group (reverse lines-by-file))
      (let ((file-path (car file-group)))
        (dolist (entry (cdr file-group))
          (when (listp entry)
            (let* ((path (nth 0 entry))
                   (line (nth 1 entry))
                   (col (nth 2 entry))
                   (content (nth 3 entry))
                   (header (format "%s:%s:%s:" path line col))
                   (start (point)))
              
              ;; Insert the header with wgrep-line-filename property
              (insert header)
              (let ((header-end (point)))
                ;; CRITICAL: Set wgrep-line-filename property on header only
                (add-text-properties start header-end
                                   (list 'wgrep-line-filename path
                                         'front-sticky t))
                
                ;; Insert the editable content (no properties)
                (insert content)
                (insert "\n")
                
                (my/rg-debug-message "Added line: %s" 
                                    (buffer-substring-no-properties start header-end))))))))))

;; 3. Setup
;; ----------------------------------------

(global-set-key (kbd "C-S-g") 'my/rg-search)

(message "=== V23 LOADED - Simplified wgrep format ===")
(message "V23: Cleaner output format matching standard grep")
(message "V23: Navigation (RET) and wgrep editing (w, C-c C-c)")
(message "V23: Debug messages disabled by default for cleaner output")

;; SUMMARY:
;; V22: ❌ Still read-only issues, complex format
;; V23: ✅ Simplified format, sorted output, proper wgrep properties

(provide '02-base-230-wgrep-ripgrep-v23)

(when (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v23.el loaded - Simplified format"))