;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 10:32:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-FINAL.el
;;; FINAL VERSION - Handles both interactive and programmatic calls

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

;; FINAL VERSION: Handles the discovered issue
;; - Something is calling (my/rg-search "load") programmatically
;; - This version handles both interactive C-S-g and automatic calls
;; - FIXED double TRAMP prefix issue
;; - Working navigation and wgrep editing

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

;; 2. Main Search Function - Handles both interactive and programmatic calls
;; ----------------------------------------

(defun my/rg-search (query)
  "FINAL: Search function that handles both interactive and automatic calls.
   
   This function is called both:
   1. Interactively via C-S-g keybinding  
   2. Programmatically by some hook/advice with 'load' query
   
   Handles remote TRAMP directories with FIXED path resolution."
  (interactive "sSearch: ")
  
  (message "FINAL: Starting search with query: %s" query)
  (message "FINAL: Directory: %s" default-directory)
  (message "FINAL: Interactive call: %s" (called-interactively-p 'any))
  
  ;; Get the correct search directory
  (let ((search-directory
         (cond
          ((and (eq major-mode 'dired-mode)
                (fboundp 'my/path-get-path))
           (my/path-get-path))
          ((eq major-mode 'dired-mode)
           (dired-current-directory))
          (t default-directory))))
    
    (message "FINAL: Search directory: %s" search-directory)
    
    ;; Use remote search for TRAMP, standard rg.el for local
    (if (file-remote-p search-directory)
        (let ((default-directory search-directory))
          (message "FINAL: Using remote search")
          (my/rg-remote-search-final query))
      ;; For local: use standard rg.el
      (let ((default-directory search-directory))
        (message "FINAL: Using local rg-project")
        (rg-project query "*")))))

(defun my/rg-remote-search-final (query)
  "FINAL: Remote search with FIXED path resolution and wgrep support."
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
         (buffer-name "*rg-FINAL*"))
    
    (message "FINAL: Remote prefix: %s" remote-prefix)
    (message "FINAL: Local path: %s" local-path)
    
    (let ((buffer (get-buffer-create buffer-name)))
      (with-current-buffer buffer
        (setq-local default-directory default-directory)
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert (format "-*- mode: rg; default-directory: \"%s\" -*-\n" default-directory))
          (insert (format "FINAL rg started at %s\n\n" (current-time-string)))
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
        
        (message "FINAL: Command executed, result length: %d" (length result))
        
        (with-current-buffer buffer
          (let ((inhibit-read-only t))
            (goto-char (point-max))
            (insert "\n=== SEARCH RESULTS ===\n")
            (insert result)
            (insert "\n=== END RESULTS ===\n")
            
            ;; Format results with FIXED path resolution
            (my/rg-format-final remote-prefix local-path)
            
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

(defun my/rg-format-final (remote-prefix local-path)
  "FINAL: Format results with COMPLETELY FIXED path logic."
  (let ((inhibit-read-only t)
        (file-count 0))
    (goto-char (point-min))
    (when (re-search-forward "=== SEARCH RESULTS ===\n" nil t)
      (while (re-search-forward "^\\([^:\n\r]+\\)$" nil t)
        (let ((raw-file (match-string 1)))
          (when (and (not (string-match-p "^[[:space:]]*$" raw-file))
                     (not (string-match-p "^[0-9]+:" raw-file))
                     (not (string-match-p "^=+" raw-file))
                     (string-match-p "^\\." raw-file)) ; Files start with ./
            
            (setq file-count (1+ file-count))
            (message "FINAL: Processing file #%d: %s" file-count raw-file)
            
            (let ((file-start (match-beginning 0)))
              (forward-line)
              (while (and (not (eobp))
                          (looking-at "^\\([0-9]+\\):\\([0-9]+\\):\\(.+\\)$"))
                (let* ((line (match-string 1))
                       (col (match-string 2))
                       (content (match-string 3))
                       ;; FIXED: Clean path construction
                       (abs-path (expand-file-name raw-file local-path))
                       (final-path (concat remote-prefix abs-path)))
                  
                  (message "FINAL: %s -> %s -> %s" raw-file abs-path final-path)
                  
                  ;; Replace with correct format
                  (replace-match (format "%s:%s:%s:%s" final-path line col content) t t))
                (forward-line))
              
              ;; Remove file header
              (goto-char file-start)
              (when (< file-start (point-max))
                (delete-region file-start (1+ (line-end-position)))))))))))

;; 3. Setup
;; ----------------------------------------

;; Set the keybinding
(global-set-key (kbd "C-S-g") 'my/rg-search)

(message "=== FINAL VERSION LOADED ===")
(message "FINAL: my/rg-search function defined (handles both interactive and automatic calls)")
(message "FINAL: C-S-g bound to: %s" (key-binding (kbd "C-S-g")))
(message "FINAL: Ready for both C-S-g keypresses and automatic 'load' calls")

;; Usage:
;; - Press C-S-g for interactive search
;; - Handles automatic calls like (my/rg-search "load")
;; - Navigation: RET opens files (FIXED paths)
;; - Editing: 'w' for wgrep mode, C-c C-c to save
;; - Buffer: *rg-FINAL*

(provide '02-base-230-wgrep-ripgrep-FINAL)

(when (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-FINAL.el loaded - HANDLES ALL CALLS"))