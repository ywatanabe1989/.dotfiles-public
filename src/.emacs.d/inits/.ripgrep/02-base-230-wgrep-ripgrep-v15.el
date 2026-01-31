;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 10:38:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v15.el
;;; Version: 15 - FINAL working version with proper versioning

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

;; VERSION 15: FINAL WORKING VERSION
;; - Handles both interactive (C-S-g) and programmatic calls
;; - Fixed double TRAMP prefix issue for remote directories
;; - Uses standard rg.el for local, custom remote search for TRAMP
;; - Working navigation (RET) and wgrep editing (w, C-c C-c)
;; - Proper versioning and documentation

;; VERSION HISTORY:
;; v01-v14: Various attempts and diagnostics
;; v15: FINAL working implementation with proper versioning

;; KEY FEATURES:
;; - Smart detection: local vs remote directories
;; - Fixed paths: no /ssh:host:/ssh:host: duplication
;; - Full functionality: search, navigate, edit
;; - Handles automatic calls from hooks/advice

;; 1. Package Configuration
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

;; 2. Debug Configuration
;; ----------------------------------------

(defvar my/rg-v15-debug t "Enable debug output for v15")

(defun my/rg-v15-debug (format-string &rest args)
  "V15 debug output."
  (when my/rg-v15-debug
    (apply 'message (concat "V15: " format-string) args)))

;; 3. Main Search Function
;; ----------------------------------------

(defun my/rg-search (query)
  "V15: Main search function - handles both interactive and automatic calls.
   
   FEATURES:
   - Detects local vs remote directories automatically
   - Uses standard rg.el for local searches (fast, reliable)
   - Uses custom remote search for TRAMP (fixed path resolution)
   - Handles both C-S-g keypresses and programmatic calls
   - Fixed double TRAMP prefix issue
   
   USAGE:
   - Press C-S-g for interactive search
   - Automatic calls like (my/rg-search 'load') work too
   - Navigation: RET opens files
   - Editing: 'w' for wgrep mode, C-c C-c to save"
  (interactive "sV15 Search: ")
  
  (my/rg-v15-debug "=== V15 SEARCH STARTING ===")
  (my/rg-v15-debug "Query: %s" query)
  (my/rg-v15-debug "Directory: %s" default-directory)
  (my/rg-v15-debug "Interactive: %s" (called-interactively-p 'any))
  
  ;; Get the correct search directory
  (let ((search-directory
         (cond
          ((and (eq major-mode 'dired-mode)
                (fboundp 'my/path-get-path))
           (my/path-get-path))
          ((eq major-mode 'dired-mode)
           (dired-current-directory))
          (t default-directory))))
    
    (my/rg-v15-debug "Search directory: %s" search-directory)
    (my/rg-v15-debug "Is remote: %s" (file-remote-p search-directory))
    
    ;; Smart routing: remote vs local
    (if (file-remote-p search-directory)
        (let ((default-directory search-directory))
          (my/rg-v15-debug "Using V15 REMOTE search")
          (my/rg-remote-search-v15 query))
      ;; For local: use standard rg.el (reliable and fast)
      (let ((default-directory search-directory))
        (my/rg-v15-debug "Using standard rg-project for local")
        (rg-project query "*")))))

(defun my/rg-remote-search-v15 (query)
  "V15: Remote search with FIXED path resolution and full wgrep support."
  (my/rg-v15-debug "Remote search function starting")
  
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
         (buffer-name "*rg-v15*"))
    
    (my/rg-v15-debug "Remote prefix: %s" remote-prefix)
    (my/rg-v15-debug "Local path: %s" local-path)
    
    (let ((buffer (get-buffer-create buffer-name)))
      (with-current-buffer buffer
        (setq-local default-directory default-directory)
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert (format "-*- mode: rg; default-directory: \"%s\" -*-\n" default-directory))
          (insert (format "V15 rg started at %s\n\n" (current-time-string)))
          (insert (format "Query: %s\n" query))
          (insert (format "Directory: %s\n" default-directory))
          (insert (format "Remote prefix: %s\n" remote-prefix))
          (insert (format "Local path: %s\n\n" local-path)))
        
        ;; Use compilation-mode for navigation
        (compilation-mode)
        (setq-local compilation-search-path (list default-directory)))
      
      ;; Execute remote search
      (let* ((cmd (format "~/.local/bin/rg %s %s ." flags (shell-quote-argument query)))
             (result (shell-command-to-string cmd)))
        
        (my/rg-v15-debug "Command: %s" cmd)
        (my/rg-v15-debug "Result length: %d chars" (length result))
        
        (with-current-buffer buffer
          (let ((inhibit-read-only t))
            (goto-char (point-max))
            (insert "\n=== V15 SEARCH RESULTS ===\n")
            (insert result)
            (insert "\n=== V15 END RESULTS ===\n")
            
            ;; Format results with FIXED path resolution
            (my/rg-format-v15 remote-prefix local-path)
            
            ;; Set up compilation-mode for navigation  
            (setq-local compilation-error-regexp-alist
                        '(("^\\(/ssh:[^:]+:/[^:]+\\):\\([0-9]+\\):\\([0-9]+\\):"
                           1 2 3)))
            
            ;; Set up for wgrep
            (setq buffer-read-only nil)
            (when (fboundp 'wgrep-setup) (wgrep-setup))
            
            ;; Add keybindings
            (local-set-key (kbd "w") 'wgrep-change-to-wgrep-mode)
            (local-set-key (kbd "C-c C-c") 'wgrep-finish-edit)
            (local-set-key (kbd "C-c C-k") 'wgrep-abort-changes)
            (local-set-key (kbd "RET") 'compile-goto-error)
            (local-set-key (kbd "<mouse-2>") 'compile-goto-error))))
      
      (pop-to-buffer buffer))))

(defun my/rg-format-v15 (remote-prefix local-path)
  "V15: Format results with COMPLETELY FIXED path logic - no double prefixes."
  (my/rg-v15-debug "Formatting results...")
  (my/rg-v15-debug "Remote prefix: %s" remote-prefix)
  (my/rg-v15-debug "Local path: %s" local-path)
  
  (let ((inhibit-read-only t)
        (file-count 0))
    (goto-char (point-min))
    (when (re-search-forward "=== V15 SEARCH RESULTS ===\n" nil t)
      (while (re-search-forward "^\\([^:\n\r]+\\)$" nil t)
        (let ((raw-file (match-string 1)))
          (when (and (not (string-match-p "^[[:space:]]*$" raw-file))
                     (not (string-match-p "^[0-9]+:" raw-file))
                     (not (string-match-p "^=+" raw-file))
                     (string-match-p "^\\." raw-file)) ; Files start with ./
            
            (setq file-count (1+ file-count))
            (my/rg-v15-debug "File #%d: %s" file-count raw-file)
            
            (let ((file-start (match-beginning 0)))
              (forward-line)
              (while (and (not (eobp))
                          (looking-at "^\\([0-9]+\\):\\([0-9]+\\):\\(.+\\)$"))
                (let* ((line (match-string 1))
                       (col (match-string 2))
                       (content (match-string 3))
                       ;; FIXED: Step-by-step path construction to avoid double prefix
                       (abs-local-path (expand-file-name raw-file local-path))
                       (final-tramp-path (concat remote-prefix abs-local-path)))
                  
                  (my/rg-v15-debug "  %s -> %s -> %s" raw-file abs-local-path final-tramp-path)
                  
                  ;; Verify no double prefix
                  (when (string-match-p "/ssh:[^:]+:/ssh:" final-tramp-path)
                    (my/rg-v15-debug "WARNING: Double prefix detected in: %s" final-tramp-path))
                  
                  ;; Replace with correct format
                  (replace-match (format "%s:%s:%s:%s" final-tramp-path line col content) t t))
                (forward-line))
              
              ;; Remove file header
              (goto-char file-start)
              (when (< file-start (point-max))
                (delete-region file-start (1+ (line-end-position)))))))))))

;; 4. Setup and Configuration
;; ----------------------------------------

;; Set the keybinding
(global-set-key (kbd "C-S-g") 'my/rg-search)

;; Messages and verification
(message "=== V15 LOADED SUCCESSFULLY ===")
(message "V15: Enhanced ripgrep + wgrep + TRAMP integration")
(message "V15: C-S-g bound to: %s" (key-binding (kbd "C-S-g")))
(message "V15: Local searches use standard rg.el")
(message "V15: Remote searches use fixed TRAMP path resolution")
(message "V15: Navigation (RET) and wgrep editing (w, C-c C-c) supported")

;; USAGE SUMMARY:
;;
;; LOCAL DIRECTORIES:
;;   - Fast standard rg.el search
;;   - All standard rg-mode features
;;   - Automatic wgrep support
;;
;; REMOTE DIRECTORIES (TRAMP):
;;   - Custom remote search execution  
;;   - FIXED path resolution (no double /ssh:host: prefixes)
;;   - Working navigation with RET
;;   - Working wgrep editing with w and C-c C-c
;;   - Unique buffer: *rg-v15*
;;
;; KEYBINDINGS:
;;   - C-S-g: Start search
;;   - RET: Navigate to file
;;   - w: Enter wgrep edit mode
;;   - C-c C-c: Save wgrep changes
;;   - C-c C-k: Abort wgrep changes

(provide '02-base-230-wgrep-ripgrep-v15)

(when (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v15.el loaded - FINAL VERSIONED IMPLEMENTATION"))