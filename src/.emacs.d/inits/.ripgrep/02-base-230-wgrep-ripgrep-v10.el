;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 10:28:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v10.el
;;; Version: 10 - Complete cleanup and override

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

;; Version 10: COMPLETE cleanup - undefines old functions first
;; - Removes all old function definitions
;; - Redefines C-S-g keybinding completely
;; - Forces use of new v10 implementation
;; - FIXED double TRAMP prefix issue

;; STEP 1: CLEANUP - Remove old function definitions
;; ----------------------------------------

;; Undefine old functions to prevent conflicts
(when (fboundp 'my/rg-search)
  (fmakunbound 'my/rg-search)
  (message "V10: Removed old my/rg-search"))

(when (fboundp 'my/rg-search-remote-fast)
  (fmakunbound 'my/rg-search-remote-fast)
  (message "V10: Removed old my/rg-search-remote-fast"))

;; Clear the keybinding completely
(global-unset-key (kbd "C-S-g"))
(message "V10: Cleared C-S-g keybinding")

;; STEP 2: Package Configuration
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

;; STEP 3: V10 Implementation
;; ----------------------------------------

(defvar my/rg-v10-debug t "Enable debug output for v10")

(defun my/rg-v10-debug (format-string &rest args)
  "V10 debug output."
  (when my/rg-v10-debug
    (apply 'message (concat "V10: " format-string) args)))

(defun my/rg-search-v10 (query)
  "V10: Main search function - COMPLETELY NEW."
  (interactive "sV10 Regexp search for: ")
  
  (my/rg-v10-debug "=== V10 SEARCH STARTING ===")
  (my/rg-v10-debug "Query: %s" query)
  (my/rg-v10-debug "Directory: %s" default-directory)
  
  ;; Get the correct directory
  (let ((search-directory
         (cond
          ((and (eq major-mode 'dired-mode)
                (fboundp 'my/path-get-path))
           (my/path-get-path))
          ((eq major-mode 'dired-mode)
           (dired-current-directory))
          (t default-directory))))
    
    (my/rg-v10-debug "Search directory resolved: %s" search-directory)
    
    ;; Use remote search for TRAMP, standard rg.el for local
    (if (file-remote-p search-directory)
        (let ((default-directory search-directory))
          (my/rg-v10-debug "Using V10 REMOTE search")
          (my/rg-remote-v10 query))
      ;; For local: use standard rg.el
      (let ((default-directory search-directory))
        (my/rg-v10-debug "Using standard rg-project for local")
        (rg-project query "*")))))

(defun my/rg-remote-v10 (query)
  "V10: Remote search with FIXED path construction."
  (my/rg-v10-debug "Remote search function starting")
  
  (let* ((remote-prefix (file-remote-p default-directory))
         (local-path (file-remote-p default-directory 'localname))
         (flags "--line-number --column --heading --no-config --max-count=500 --glob=!**/*undo-tree* --glob=!**/.old/** --glob=!**/*.log --glob=!**/RUNNING/** --glob=!**/FINISHED_SUCCESS/** --glob=!**/FINISHED/**")
         (buffer-name "*rg-v10*"))
    
    (my/rg-v10-debug "Remote prefix: %s" remote-prefix)
    (my/rg-v10-debug "Local path: %s" local-path)
    
    (let ((buffer (get-buffer-create buffer-name)))
      (with-current-buffer buffer
        (setq-local default-directory default-directory)
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert (format "-*- mode: rg; default-directory: \"%s\" -*-\n" default-directory))
          (insert (format "V10 rg started at %s\n\n" (current-time-string)))
          (insert (format "V10 Remote prefix: %s\n" remote-prefix))
          (insert (format "V10 Local path: %s\n" local-path))
          (insert (format "V10 Query: %s\n\n" query)))
        
        ;; Use compilation-mode
        (compilation-mode)
        (setq-local compilation-search-path (list default-directory)))
      
      ;; Execute remote search
      (let* ((cmd (format "~/.local/bin/rg %s %s ." flags (shell-quote-argument query)))
             (result (shell-command-to-string cmd)))
        
        (my/rg-v10-debug "Executed: %s" cmd)
        (my/rg-v10-debug "Result chars: %d" (length result))
        
        (with-current-buffer buffer
          (let ((inhibit-read-only t))
            (goto-char (point-max))
            (insert "\n=== V10 OUTPUT ===\n")
            (insert result)
            (insert "\n=== V10 END ===\n")
            
            ;; Format results with FIXED path logic
            (my/rg-format-v10 remote-prefix local-path)
            
            ;; Set up compilation-mode
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

(defun my/rg-format-v10 (remote-prefix local-path)
  "V10: Format with COMPLETELY FIXED path logic."
  (my/rg-v10-debug "Formatting with remote-prefix: %s, local-path: %s" remote-prefix local-path)
  
  (let ((inhibit-read-only t)
        (file-count 0))
    (goto-char (point-min))
    (when (re-search-forward "=== V10 OUTPUT ===\n" nil t)
      (while (re-search-forward "^\\([^:\n\r]+\\)$" nil t)
        (let ((raw-file (match-string 1)))
          (when (and (not (string-match-p "^[[:space:]]*$" raw-file))
                     (not (string-match-p "^[0-9]+:" raw-file))
                     (not (string-match-p "^=+" raw-file))
                     (string-match-p "^\\." raw-file))
            
            (setq file-count (1+ file-count))
            (my/rg-v10-debug "File #%d: %s" file-count raw-file)
            
            (let ((file-start (match-beginning 0)))
              (forward-line)
              (while (and (not (eobp))
                          (looking-at "^\\([0-9]+\\):\\([0-9]+\\):\\(.+\\)$"))
                (let* ((line (match-string 1))
                       (col (match-string 2))
                       (content (match-string 3))
                       ;; FIXED: Build path step by step with debug
                       (expanded-path (expand-file-name raw-file local-path))
                       (final-path (concat remote-prefix expanded-path)))
                  
                  (my/rg-v10-debug "  %s -> %s -> %s" raw-file expanded-path final-path)
                  
                  ;; Replace with correct format
                  (replace-match (format "%s:%s:%s:%s" final-path line col content) t t))
                (forward-line))
              
              ;; Remove file header
              (goto-char file-start)
              (when (< file-start (point-max))
                (delete-region file-start (1+ (line-end-position)))))))))))

;; STEP 4: FINAL SETUP
;; ----------------------------------------

;; Set the keybinding to v10 function
(global-set-key (kbd "C-S-g") 'my/rg-search-v10)

(message "=== V10 COMPLETELY LOADED - OLD FUNCTIONS REMOVED ===")
(message "V10: C-S-g now bound to my/rg-search-v10")

;; Test the binding
(my/rg-v10-debug "Keybinding test: C-S-g -> %s" (key-binding (kbd "C-S-g")))

(provide '02-base-230-wgrep-ripgrep-v10)

(when (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v10.el loaded - COMPLETE CLEANUP AND OVERRIDE"))