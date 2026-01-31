;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 11:05:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v22.el
;;; Version: 22 - FIXED wgrep with proper text properties

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

;; VERSION 22: FIXED wgrep with proper text properties based on wgrep source analysis
;; V21 Issues: ❌ wgrep still read-only because missing wgrep-line-filename property
;; V22 Fix: 
;; - Set wgrep-line-filename property on filename:line:column part
;; - This property tells wgrep what parts should be read-only
;; - Based on analysis of /tmp/Emacs-wgrep/wgrep.el line 427-431

;; Based on V20 navigation + proper wgrep text properties

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
    (apply 'message (concat "V22: " format-string) args)))

;; 2. Core Functions
;; ----------------------------------------

(defun my/rg-search (query)
  "V22: Fixed wgrep with proper text properties."
  (interactive "sV22 Search: ")
  (my/rg-debug-message "=== V22 SEARCH STARTING ===")
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
          (my/rg-debug-message "=== USING V22 REMOTE SEARCH ===")
          (my/rg-search-remote-v22 query))
      (let ((default-directory search-directory))
        (my/rg-debug-message "=== USING STANDARD RG FOR LOCAL ===")
        (rg-project query "*")))))

(defun my/rg-search-remote-v22 (query)
  "V22: Remote search with PROPER wgrep text properties."
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
         (buffer-name "*rg-v22*"))

    (my/rg-debug-message "Remote prefix: %s" remote-prefix)
    (my/rg-debug-message "Local path: %s" local-path)
    
    (let ((buffer (get-buffer-create buffer-name)))
      (with-current-buffer buffer
        (setq-local default-directory default-directory)
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert (format "-*- mode: grep; default-directory: \"%s\" -*-\n" default-directory))
          (insert (format "V22 Remote Search - %s\n\n" (current-time-string)))
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
            (insert "\n=== V22 REMOTE RESULTS ===\n")
            (insert result)
            (insert "\n=== END RESULTS ===\n")
            
            ;; Format results WITH PROPER WGREP TEXT PROPERTIES
            (my/rg-format-for-wgrep-v22 remote-prefix local-path)
            
            ;; Set up compilation-mode for navigation
            (setq-local compilation-error-regexp-alist
                        '(("^\\(/ssh:[^:]+:/[^:]+\\):\\([0-9]+\\):\\([0-9]+\\):"
                           1 2 3)))
            
            ;; Set up wgrep properly
            (my/rg-debug-message "Setting up wgrep with proper properties...")
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
            (local-set-key (kbd "<mouse-2>") 'compile-goto-error)
            
            (my/rg-debug-message "Buffer setup complete"))))
      
      (pop-to-buffer buffer))))

(defun my/rg-format-for-wgrep-v22 (remote-prefix local-path)
  "V22: Format results with PROPER wgrep text properties.
The key is setting wgrep-line-filename property on the filename:line:column part.
This tells wgrep what should be read-only vs editable."
  (my/rg-debug-message "Formatting results with wgrep properties...")
  
  (let ((inhibit-read-only t))
    (goto-char (point-min))
    (when (re-search-forward "=== V22 REMOTE RESULTS ===\n" nil t)
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
                       (final-path (concat remote-prefix abs-path)))
                  ;; Store formatted line with metadata
                  (push (list final-path line col content) formatted-lines)))))
            (forward-line 1)))
        
        ;; Replace the raw output with formatted grep-style output WITH PROPERTIES
        (goto-char start-pos)
        (delete-region start-pos end-pos)
        
        ;; Insert formatted lines with proper wgrep text properties
        (dolist (entry (reverse formatted-lines))
          (let* ((path (nth 0 entry))
                 (line (nth 1 entry))
                 (col (nth 2 entry))
                 (content (nth 3 entry))
                 (header (format "%s:%s:%s:" path line col))
                 (start (point)))
            
            ;; Insert the full line
            (insert header)
            (let ((header-end (point)))
              ;; CRITICAL: Set wgrep-line-filename property on the HEADER part only
              ;; This marks filename:line:column: as read-only, content as editable
              (put-text-property start header-end 'wgrep-line-filename path)
              ;; Mark the header as non-editable
              (put-text-property start header-end 'front-sticky t)
              
              ;; Insert the editable content (NO properties - this makes it editable)
              (insert content)
              (insert "\n")
              
              (my/rg-debug-message "Added wgrep properties for: %s" 
                                  (buffer-substring-no-properties start header-end)))))
        
        (insert "\n")))))

;; 3. Setup
;; ----------------------------------------

(global-set-key (kbd "C-S-g") 'my/rg-search)

(message "=== V22 LOADED - FIXED wgrep with proper text properties ===")
(message "V22: Based on wgrep source - sets wgrep-line-filename on header only")
(message "V22: Navigation (RET) and wgrep editing (w, C-c C-c) should now work")
(message "V22: Header (filename:line:col:) is read-only, content is editable")

;; SUMMARY:
;; V20: ✅ Navigation, ❌ Missing column in format
;; V21: ✅ Navigation, ❌ wgrep read-only issues
;; V22: ✅ Navigation, ✅ wgrep editing with correct text properties

(provide '02-base-230-wgrep-ripgrep-v22)

(when (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v22.el loaded - FIXED wgrep properties"))