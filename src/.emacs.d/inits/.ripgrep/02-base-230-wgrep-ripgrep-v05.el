;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 10:18:30>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v05.el
;;; Version: 05 - Fixed rg-project type filtering issue

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

;; Version 05: Fixed type filtering issue from v04
;; - Uses rg-project with "*" to avoid --type=custom filtering
;; - Standard rg.el + wgrep + TRAMP integration
;; - No custom buffer manipulation
;; - Clean, simple implementation

;; Version History:
;; v03: Custom remote implementation with complex formatting
;; v04: Clean rg.el approach but had type filtering issues  
;; v05: Fixed type filtering with rg-project

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
  ;; Enable navigation and wgrep integration
  (define-key rg-mode-map (kbd "RET") 'compile-goto-error)
  (define-key rg-mode-map (kbd "w") 'wgrep-change-to-wgrep-mode)
  (define-key rg-mode-map (kbd "C-c C-c") 'wgrep-finish-edit)
  (define-key rg-mode-map (kbd "C-c C-k") 'wgrep-abort-changes)
  ;; Automatically enable wgrep in rg-mode buffers
  (add-hook 'rg-mode-hook (lambda ()
                           (when (fboundp 'wgrep-setup)
                             (wgrep-setup)))))

;; 2. Core Search Function  
;; ----------------------------------------

(defun my/rg-search-v05 (query)
  "Run ripgrep search using standard rg.el with TRAMP support.
   
   Version 05 fixes:
   - Uses rg-project with '*' to avoid type filtering
   - No more '--type=custom' issues
   - Searches all files without restrictions
   
   This function:
   - Uses standard rg.el for both local and remote searches
   - Lets TRAMP handle remote execution automatically
   - Provides wgrep editing capabilities
   - Works with dired-mode directory detection"
  (interactive "sRegexp search for: ")
  
  ;; Get the correct directory - use my/path-get-path in dired mode if available
  (let ((search-directory
         (cond
          ;; If in dired mode and my/path-get-path is available, use it
          ((and (eq major-mode 'dired-mode)
                (fboundp 'my/path-get-path))
           (my/path-get-path))
          ;; If in dired mode but function not available, use dired-current-directory
          ((eq major-mode 'dired-mode)
           (dired-current-directory))
          ;; Otherwise use default-directory
          (t default-directory))))
    
    ;; Set up rg command line flags
    (let ((rg-command-line-flags
           (list "--no-ignore"
                 "--glob=!**/*undo-tree*"
                 "--glob=!**/.old/**" 
                 "--glob=!**/*.log"
                 "--glob=!**/RUNNING/**"
                 "--glob=!**/FINISHED_SUCCESS/**"
                 "--glob=!**/FINISHED/**")))
      
      ;; Use standard rg.el - TRAMP will handle remote execution automatically
      ;; FIXED: Use rg-project with "*" to avoid type filtering issues
      (let ((default-directory search-directory)
            (rg-ignore-case 'smart))
        (rg-project query "*")))))

;; 3. Helper Functions
;; ----------------------------------------

(defun my/rg-check-executable-v05 ()
  "Check if rg is installed and usable on local or remote system."
  (interactive)
  (if (file-remote-p default-directory)
      ;; For remote systems, check via TRAMP
      (let ((result (ignore-errors 
                      (process-lines "which" "rg"))))
        (when (or (null result)
                  (string-match-p "not found\\|no rg in" (car result)))
          (error "No 'rg' executable found on remote host. Please install ripgrep.")))
    ;; For local systems
    (unless (executable-find "rg")
      (error "No 'rg' executable found. Please install ripgrep or check your PATH."))))

;; 4. Setup
;; ----------------------------------------

;; Global keybinding
(global-set-key (kbd "C-S-g") 'my/rg-search-v05)

;; Usage Instructions:
;;
;; 1. Local Search:
;;    - Navigate to any directory
;;    - Press C-S-g and enter search term
;;    - Results appear in rg-mode buffer (no type filtering!)
;;    - Press RET to navigate to files
;;    - Press 'w' to enter wgrep mode for editing
;;    - Make changes, then C-c C-c to save
;;
;; 2. Remote Search (TRAMP):
;;    - Open a remote file or directory via TRAMP (e.g., /ssh:user@host:/path/)
;;    - Press C-S-g and enter search term  
;;    - rg.el automatically executes ripgrep on remote host
;;    - Results show TRAMP paths (/ssh:user@host:/path/file)
;;    - Press RET to navigate (TRAMP opens remote files)
;;    - Press 'w' for wgrep mode, make changes, C-c C-c to save
;;    - wgrep automatically saves changes to remote files via TRAMP
;;
;; 3. Dired Integration:
;;    - Works seamlessly in dired buffers
;;    - Automatically uses dired directory as search root
;;    - Supports both local and remote dired buffers
;;
;; Changes from v04:
;; - Fixed type filtering issue by using rg-project with "*" 
;; - No more "--type=custom" errors
;; - Searches ALL files without type restrictions

(provide '02-base-230-wgrep-ripgrep-v05)

(when (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v05.el loaded - Fixed type filtering issue"))