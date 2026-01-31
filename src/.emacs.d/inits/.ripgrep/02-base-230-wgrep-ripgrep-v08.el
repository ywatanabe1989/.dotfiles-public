;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 10:26:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v08.el
;;; Version: 08 - Fixed TRAMP path resolution issue

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

;; Version 08: Fixed double TRAMP prefix issue
;; - FIXED: '/ssh:sp:/ssh:sp:/path' -> '/ssh:sp:/path' 
;; - Proper path construction logic
;; - Based on working remote search from previous versions
;; - Clean wgrep integration

;; Version History:
;; v02-v07: All had double TRAMP prefix issue in navigation
;; v08: Fixed path resolution to avoid '/ssh:host:/ssh:host:/path'

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

;; 2. Variables and Helpers
;; ----------------------------------------

(defvar my/rg-remote-executable-cache (make-hash-table :test 'equal))
(defvar my/rg-debug-message nil)

(defun my/rg-debug-message (format-string &rest args)
  (when my/rg-debug-message
    (apply 'message format-string args)))

;; 3. Core Search Functions
;; ----------------------------------------

(defun my/rg-search-v08 (query)
  "Run rg search with automatic remote/local detection."
  (interactive "sRegexp search for: ")
  
  ;; Get the correct directory
  (let ((search-directory
         (cond
          ((and (eq major-mode 'dired-mode)
                (fboundp 'my/path-get-path))
           (my/path-get-path))
          ((eq major-mode 'dired-mode)
           (dired-current-directory))
          (t default-directory))))
    
    ;; Use remote search for TRAMP, standard rg.el for local
    (if (file-remote-p search-directory)
        (let ((default-directory search-directory))
          (my/rg-search-remote-v08 query))
      ;; For local: use standard rg.el
      (let ((default-directory search-directory))
        (rg-project query "*")))))

(defun my/rg-search-remote-v08 (query)
  "Remote rg search with FIXED path resolution."
  (let* ((remote-prefix (file-remote-p default-directory))
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
         (buffer-name "*rg*"))
    
    (let ((buffer (get-buffer-create buffer-name)))
      (with-current-buffer buffer
        (setq-local default-directory default-directory)
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert (format "-*- mode: rg; default-directory: \"%s\" -*-\n" default-directory))
          (insert (format "rg started at %s\n\n" (current-time-string)))
          (insert (format "cd %s && rg %s %s .\n\n"
                          (file-remote-p default-directory 'localname)
                          flags (shell-quote-argument query)))
          (insert (format "Debug: Remote directory: %s\n" default-directory))
          (insert (format "Debug: Query: %s\n" query))
          (insert (format "Debug: Remote prefix: %s\n\n" remote-prefix)))
        
        ;; Use compilation-mode for navigation
        (compilation-mode)
        (setq-local compilation-search-path (list default-directory)))
      
      ;; Execute remote search
      (let* ((cmd-simple (format "~/.local/bin/rg %s %s ." flags (shell-quote-argument query)))
             (result (shell-command-to-string cmd-simple)))
        (with-current-buffer buffer
          (let ((inhibit-read-only t))
            (goto-char (point-max))
            (insert "\n=== COMMAND OUTPUT ===\n")
            (insert result)
            (insert "\n=== END OUTPUT ===\n")
            (my/rg-format-results-v08 remote-prefix)
            
            ;; Set up compilation-mode for navigation  
            (setq-local compilation-error-regexp-alist
                        '(("^\\(/ssh:[^:]+:/[^:]+\\):\\([0-9]+\\):\\([0-9]+\\):"
                           1 2 3)))
            
            ;; Set up for wgrep
            (setq buffer-read-only nil)
            (when (fboundp 'wgrep-setup) (wgrep-setup))
            
            ;; Define simple wgrep toggle  
            (defun my/toggle-wgrep-v08 ()
              (interactive)
              (if (bound-and-true-p wgrep-mode)
                  (wgrep-finish-edit)
                (progn 
                  (setq buffer-read-only nil)
                  (wgrep-change-to-wgrep-mode))))
            
            ;; Add keybindings
            (local-set-key (kbd "w") 'my/toggle-wgrep-v08)
            (local-set-key (kbd "C-c C-c") 'wgrep-finish-edit)
            (local-set-key (kbd "C-c C-k") 'wgrep-abort-changes)
            (local-set-key (kbd "RET") 'compile-goto-error)
            (local-set-key (kbd "<mouse-2>") 'compile-goto-error))))
      
      (pop-to-buffer buffer))))

(defun my/rg-format-results-v08 (remote-prefix)
  "Format remote rg results with FIXED path resolution."
  (let ((inhibit-read-only t))
    (goto-char (point-min))
    (when (re-search-forward "=== COMMAND OUTPUT ===\n" nil t)
      (while (re-search-forward "^\\([^:\n\r]+\\)$" nil t)
        (let ((potential-file (match-string 1)))
          (when (and (not (string-match-p "^[[:space:]]*$" potential-file))
                     (not (string-match-p "^[0-9]+:" potential-file))
                     (not (string-match-p "^=+" potential-file))
                     (string-match-p "^\\." potential-file)) ; Files start with ./
            (let ((file-start (match-beginning 0)))
              (forward-line)
              (while (and (not (eobp))
                          (looking-at "^\\([0-9]+\\):\\([0-9]+\\):\\(.+\\)$"))
                (let* ((line (match-string 1))
                       (col (match-string 2))
                       (content (match-string 3))
                       ;; FIXED: Clean any existing TRAMP prefix first
                       (clean-file (replace-regexp-in-string "^/ssh:[^:]+:" "" potential-file))
                       (full-path
                        (cond
                         ;; Convert relative path to absolute TRAMP path
                         ((string-prefix-p "./" clean-file)
                          (let ((local-abs-path (file-remote-p default-directory 'localname)))
                            ;; FIXED: Ensure no double prefix by building path correctly
                            (concat remote-prefix (expand-file-name clean-file local-abs-path))))
                         ;; Already absolute path, add remote prefix (but avoid double prefix)
                         ((string-prefix-p "/" clean-file)
                          (if (string-prefix-p remote-prefix clean-file)
                              clean-file  ; Already has remote prefix
                            (concat remote-prefix clean-file)))
                         ;; Relative file, make absolute
                         (t (let ((local-abs-path (file-remote-p default-directory 'localname)))
                              (concat remote-prefix (expand-file-name clean-file local-abs-path)))))))
                  
                  ;; Debug output
                  (when my/rg-debug-message
                    (my/rg-debug-message "File: %s -> %s" potential-file full-path))
                  
                  ;; Simple replace - no complex text properties
                  (replace-match (format "%s:%s:%s:%s" full-path line col content) t t))
                (forward-line))
              ;; Remove file header line
              (goto-char file-start)
              (when (< file-start (point-max))
                (let ((end-pos (min (1+ (line-end-position)) (point-max))))
                  (delete-region file-start end-pos))))))))))

;; 4. Setup
;; ----------------------------------------

(global-set-key (kbd "C-S-g") 'my/rg-search-v08)

;; Enable debug messages for troubleshooting (set to nil to disable)
(setq my/rg-debug-message t)

;; Usage Instructions:
;;
;; Version 08 fixes the major path resolution issue:
;; - BEFORE: '/ssh:sp:/ssh:sp:/path' (navigation failed)
;; - AFTER:  '/ssh:sp:/path' (navigation should work)
;;
;; Features:
;; - Working remote search 
;; - FIXED navigation with RET 
;; - Working wgrep editing: 'w' to edit, C-c C-c to save
;; - Debug output to help troubleshoot path issues
;;
;; To disable debug output: (setq my/rg-debug-message nil)

(provide '02-base-230-wgrep-ripgrep-v08)

(when (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v08.el loaded - FIXED path resolution"))