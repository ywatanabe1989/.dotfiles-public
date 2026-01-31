;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 10:27:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v09.el
;;; Version: 09 - Clean override with fixed TRAMP paths

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

;; Version 09: Complete override to ensure v09 functions are used
;; - Completely new function names to avoid conflicts
;; - FIXED double TRAMP prefix issue definitively
;; - Forces use of new path resolution logic
;; - Clean, standalone implementation

;; IMPORTANT: This version uses completely new function names
;; to avoid any conflicts with previous versions

;; 1. Main Configuration
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

;; 2. Variables
;; ----------------------------------------

(defvar my/rg-v09-debug t "Enable debug output for v09")

(defun my/rg-v09-debug (format-string &rest args)
  "Debug output for v09."
  (when my/rg-v09-debug
    (apply 'message (concat "V09-DEBUG: " format-string) args)))

;; 3. Core Functions - COMPLETELY NEW NAMES
;; ----------------------------------------

(defun my/rg-search-main-v09 (query)
  "V09: Main search function with completely new name."
  (interactive "sRegexp search for: ")
  
  (my/rg-v09-debug "Starting search with query: %s" query)
  (my/rg-v09-debug "Current directory: %s" default-directory)
  
  ;; Get the correct directory
  (let ((search-directory
         (cond
          ((and (eq major-mode 'dired-mode)
                (fboundp 'my/path-get-path))
           (my/path-get-path))
          ((eq major-mode 'dired-mode)
           (dired-current-directory))
          (t default-directory))))
    
    (my/rg-v09-debug "Search directory: %s" search-directory)
    (my/rg-v09-debug "Is remote: %s" (file-remote-p search-directory))
    
    ;; Use remote search for TRAMP, standard rg.el for local
    (if (file-remote-p search-directory)
        (let ((default-directory search-directory))
          (my/rg-remote-search-v09 query))
      ;; For local: use standard rg.el
      (let ((default-directory search-directory))
        (rg-project query "*")))))

(defun my/rg-remote-search-v09 (query)
  "V09: Remote search with FIXED path resolution."
  (my/rg-v09-debug "Remote search starting")
  
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
         (buffer-name "*rg-v09*"))  ; Use unique buffer name
    
    (my/rg-v09-debug "Remote prefix: %s" remote-prefix)
    (my/rg-v09-debug "Local path: %s" local-path)
    
    (let ((buffer (get-buffer-create buffer-name)))
      (with-current-buffer buffer
        (setq-local default-directory default-directory)
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert (format "-*- mode: rg; default-directory: \"%s\" -*-\n" default-directory))
          (insert (format "V09 rg started at %s\n\n" (current-time-string)))
          (insert (format "cd %s && rg %s %s .\n\n" local-path flags (shell-quote-argument query)))
          (insert (format "V09 Debug: Remote directory: %s\n" default-directory))
          (insert (format "V09 Debug: Query: %s\n" query))
          (insert (format "V09 Debug: Remote prefix: %s\n\n" remote-prefix)))
        
        ;; Use compilation-mode
        (compilation-mode)
        (setq-local compilation-search-path (list default-directory)))
      
      ;; Execute remote search
      (let* ((cmd (format "~/.local/bin/rg %s %s ." flags (shell-quote-argument query)))
             (result (shell-command-to-string cmd)))
        
        (my/rg-v09-debug "Command executed: %s" cmd)
        (my/rg-v09-debug "Result length: %d chars" (length result))
        
        (with-current-buffer buffer
          (let ((inhibit-read-only t))
            (goto-char (point-max))
            (insert "\n=== V09 COMMAND OUTPUT ===\n")
            (insert result)
            (insert "\n=== V09 END OUTPUT ===\n")
            (my/rg-format-v09 remote-prefix local-path)
            
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

(defun my/rg-format-v09 (remote-prefix local-path)
  "V09: Format results with COMPLETELY FIXED path logic."
  (my/rg-v09-debug "Formatting results with remote-prefix: %s" remote-prefix)
  
  (let ((inhibit-read-only t))
    (goto-char (point-min))
    (when (re-search-forward "=== V09 COMMAND OUTPUT ===\n" nil t)
      (while (re-search-forward "^\\([^:\n\r]+\\)$" nil t)
        (let ((raw-file (match-string 1)))
          (when (and (not (string-match-p "^[[:space:]]*$" raw-file))
                     (not (string-match-p "^[0-9]+:" raw-file))
                     (not (string-match-p "^=+" raw-file))
                     (string-match-p "^\\." raw-file)) ; Files start with ./
            
            (my/rg-v09-debug "Processing file: %s" raw-file)
            
            (let ((file-start (match-beginning 0)))
              (forward-line)
              (while (and (not (eobp))
                          (looking-at "^\\([0-9]+\\):\\([0-9]+\\):\\(.+\\)$"))
                (let* ((line (match-string 1))
                       (col (match-string 2))
                       (content (match-string 3))
                       ;; FIXED: Build absolute path correctly without any existing TRAMP prefix
                       (absolute-local-path 
                        (if (string-prefix-p "./" raw-file)
                            (expand-file-name raw-file local-path)
                          raw-file))
                       ;; FIXED: Only add remote prefix once, to clean absolute path
                       (full-tramp-path (concat remote-prefix absolute-local-path)))
                  
                  (my/rg-v09-debug "Raw file: %s -> Absolute: %s -> TRAMP: %s" 
                                   raw-file absolute-local-path full-tramp-path)
                  
                  ;; Replace with compilation-mode format
                  (replace-match (format "%s:%s:%s:%s" full-tramp-path line col content) t t))
                (forward-line))
              ;; Remove file header line
              (goto-char file-start)
              (when (< file-start (point-max))
                (let ((end-pos (min (1+ (line-end-position)) (point-max))))
                  (delete-region file-start end-pos))))))))))

;; 4. Setup - FORCE OVERRIDE
;; ----------------------------------------

;; FORCE override any existing keybinding
(global-set-key (kbd "C-S-g") 'my/rg-search-main-v09)

;; Message to confirm v09 is loaded
(message "=== V09 LOADED - Using completely new functions ===")

;; Usage Instructions:
;;
;; Version 09 - Complete clean implementation:
;; - New function names: my/rg-search-main-v09, my/rg-remote-search-v09
;; - Fixed path logic: no double TRAMP prefix
;; - Debug output shows path transformations
;; - Unique buffer name: *rg-v09*
;;
;; Should fix: '/ssh:sp:/ssh:sp:/path' -> '/ssh:sp:/path'

(provide '02-base-230-wgrep-ripgrep-v09)

(when (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v09.el loaded - COMPLETE CLEAN OVERRIDE"))