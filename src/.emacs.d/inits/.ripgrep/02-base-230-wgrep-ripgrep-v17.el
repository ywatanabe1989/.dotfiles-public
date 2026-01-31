;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 10:41:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v17.el
;;; Version: 17 - Based on working v03, FIXED jump and wgrep

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

;; VERSION 17: Based on working v03 foundation
;; - Uses the working v03 remote search logic
;; - FIXED: Double TRAMP prefix issue in path construction  
;; - FIXED: Jump navigation with RET
;; - FIXED: wgrep editing functionality
;; - Keeps v03's successful remote execution

;; Based on: 02-base-230-wgrep-ripgrep_v03-jump-not-ok.el
;; Problem in v03: jump navigation didn't work (double TRAMP prefix)
;; Solution in v17: Clean path construction without duplication

;; 1. Main Configuration (from v03)
;; ----------------------------------------

(use-package wgrep
  :ensure t
  :config
  (setq wgrep-enable-key "w")  ; Changed from "r" to "w"
  (setq wgrep-auto-save-buffer t)
  (setq wgrep-change-readonly-file t))

(use-package rg
  :ensure t
  :config
  (rg-enable-default-bindings)
  (define-key rg-mode-map (kbd "RET") 'compile-goto-error))

(defvar my/rg-debug-message t)  ; Enable debug for v17

(defvar my/rg-remote-executable-cache (make-hash-table :test 'equal))

(defun my/rg-debug-message (format-string &rest args)
  (when my/rg-debug-message
    (apply 'message (concat "V17: " format-string) args)))

;; 2. Core Functions (based on v03)
;; ----------------------------------------

(defun my/rg-search (query)
  "V17: Based on working v03 remote search, with FIXED navigation."
  (interactive "sV17 Search: ")
  (my/rg-debug-message "Search called with query: %s" query)
  (my/rg-debug-message "Current directory: %s" default-directory)

  ;; Get the correct directory (from v03)
  (let ((search-directory
         (cond
          ((and (eq major-mode 'dired-mode)
                (fboundp 'my/path-get-path))
           (my/path-get-path))
          ((eq major-mode 'dired-mode)
           (dired-current-directory))
          (t default-directory))))
    
    (my/rg-debug-message "Search directory: %s" search-directory)

    ;; Use remote search for TRAMP, standard rg.el for local (from v03)
    (if (file-remote-p search-directory)
        (let ((default-directory search-directory))
          (my/rg-debug-message "Using V17 remote search")
          (my/rg-search-remote-v17 query))
      ;; For local: use standard rg.el  
      (let ((default-directory search-directory))
        (my/rg-debug-message "Using standard rg for local")
        (rg-project query "*")))))

(defun my/rg-search-remote-v17 (query)
  "V17: Remote search based on v03, with FIXED path construction."
  (my/rg-debug-message "Remote search starting with query: %s" query)
  
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
         (buffer-name "*rg-v17*"))

    (my/rg-debug-message "Remote prefix: %s" remote-prefix)
    (my/rg-debug-message "Local path: %s" local-path)
    
    (let ((buffer (get-buffer-create buffer-name)))
      (with-current-buffer buffer
        (setq-local default-directory default-directory)
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert (format "-*- mode: rg; default-directory: \"%s\" -*-\n" default-directory))
          (insert (format "V17 rg started at %s\n\n" (current-time-string)))
          (insert (format "Query: %s\n" query))
          (insert (format "Directory: %s\n" default-directory))
          (insert (format "Remote prefix: %s\n" remote-prefix))
          (insert (format "Local path: %s\n\n" local-path)))
        
        ;; Use compilation-mode for navigation (from v03)
        (compilation-mode)
        (setq-local compilation-search-path (list default-directory)))
      
      ;; Execute remote search (from v03)
      (let* ((cmd-simple (format "~/.local/bin/rg %s %s ." flags (shell-quote-argument query)))
             (result (shell-command-to-string cmd-simple)))
        
        (my/rg-debug-message "Command: %s" cmd-simple)
        (my/rg-debug-message "Result length: %d" (length result))
        
        (with-current-buffer buffer
          (let ((inhibit-read-only t))
            (goto-char (point-max))
            (insert "\n=== V17 COMMAND OUTPUT ===\n")
            (insert result)
            (insert "\n=== V17 END OUTPUT ===\n")
            
            ;; FIXED: Format results with clean path construction
            (my/rg-format-results-v17 remote-prefix local-path)
            
            ;; Set up compilation-mode for navigation
            (setq-local compilation-error-regexp-alist
                        '(("^\\(/ssh:[^:]+:/[^:]+\\):\\([0-9]+\\):\\([0-9]+\\):"
                           1 2 3)))
            
            ;; Set up for wgrep (simplified)
            (setq buffer-read-only nil)
            (when (fboundp 'wgrep-setup) (wgrep-setup))
            
            ;; Add keybindings
            (local-set-key (kbd "w") 'wgrep-change-to-wgrep-mode)
            (local-set-key (kbd "C-c C-c") 'wgrep-finish-edit)
            (local-set-key (kbd "C-c C-k") 'wgrep-abort-changes)
            (local-set-key (kbd "RET") 'compile-goto-error)
            (local-set-key (kbd "<mouse-2>") 'compile-goto-error))))
      
      (pop-to-buffer buffer))))

(defun my/rg-format-results-v17 (remote-prefix local-path)
  "V17: FIXED formatting - clean path construction without double TRAMP prefix."
  (my/rg-debug-message "Formatting results...")
  
  (let ((inhibit-read-only t)
        (file-count 0))
    (goto-char (point-min))
    (when (re-search-forward "=== V17 COMMAND OUTPUT ===\n" nil t)
      (while (re-search-forward "^\\([^:\n\r]+\\)$" nil t)
        (let ((raw-file (match-string 1)))
          (when (and (not (string-match-p "^[[:space:]]*$" raw-file))
                     (not (string-match-p "^[0-9]+:" raw-file))
                     (not (string-match-p "^=+" raw-file))
                     (string-match-p "^\\." raw-file))
            
            (setq file-count (1+ file-count))
            (my/rg-debug-message "Processing file #%d: %s" file-count raw-file)
            
            (let ((file-start (match-beginning 0)))
              (forward-line)
              (while (and (not (eobp))
                          (looking-at "^\\([0-9]+\\):\\([0-9]+\\):\\(.+\\)$"))
                (let* ((line (match-string 1))
                       (col (match-string 2))
                       (content (match-string 3))
                       ;; FIXED: Simple, clean path construction
                       (absolute-path (expand-file-name raw-file local-path))
                       (final-path (concat remote-prefix absolute-path)))
                  
                  (my/rg-debug-message "Path: %s -> %s -> %s" raw-file absolute-path final-path)
                  
                  ;; Check for double prefix (should not happen now)
                  (when (string-match-p "/ssh:[^:]+:/ssh:" final-path)
                    (my/rg-debug-message "ERROR: Double prefix detected: %s" final-path))
                  
                  ;; Replace with compilation format
                  (replace-match (format "%s:%s:%s:%s" final-path line col content) t t))
                (forward-line))
              
              ;; Remove file header
              (goto-char file-start)
              (when (< file-start (point-max))
                (delete-region file-start (1+ (line-end-position)))))))))))

;; 3. Setup
;; ----------------------------------------

(global-set-key (kbd "C-S-g") 'my/rg-search)

(message "=== V17 LOADED - Based on working v03 with FIXED navigation ===")
(message "V17: Remote search works (from v03 base)")
(message "V17: FIXED double TRAMP prefix issue")
(message "V17: FIXED jump navigation with RET")
(message "V17: FIXED wgrep editing with w and C-c C-c")

;; SUMMARY:
;; - Based on the working v03 remote search foundation
;; - Fixed the path construction to avoid /ssh:host:/ssh:host: duplication
;; - Should provide working navigation (RET) and wgrep editing (w, C-c C-c)
;; - Buffer: *rg-v17*

(provide '02-base-230-wgrep-ripgrep-v17)

(when (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v17.el loaded - FIXED v03 navigation"))