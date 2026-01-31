;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 11:15:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v24.el
;;; Version: 24 - Use compilation-start for proper grep buffer

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

;; VERSION 24: Use compilation-start to create a proper grep buffer
;; V23 Issues: ❌ Still "Text is read-only" - manual buffer setup not compatible
;; V24 Fix: 
;; - Use compilation-start with grep-mode to create proper buffer
;; - Let Emacs handle the buffer setup correctly
;; - Process results through compilation machinery

;; Based on V23 but using compilation-start

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

(defvar my/rg-debug-message nil)

(defun my/rg-debug-message (format-string &rest args)
  (when my/rg-debug-message
    (apply 'message (concat "V24: " format-string) args)))

;; 2. Core Functions
;; ----------------------------------------

(defun my/rg-search (query)
  "V24: Use compilation-start for proper grep buffer."
  (interactive "sV24 Search: ")
  (my/rg-debug-message "=== V24 SEARCH STARTING ===")
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
          (my/rg-debug-message "=== USING V24 REMOTE SEARCH ===")
          (my/rg-search-remote-v24 query))
      (let ((default-directory search-directory))
        (my/rg-debug-message "=== USING STANDARD RG FOR LOCAL ===")
        (rg-project query "*")))))

(defun my/rg-search-remote-v24 (query)
  "V24: Remote search using compilation-start for proper buffer setup."
  (my/rg-debug-message "=== REMOTE SEARCH FUNCTION ===")
  
  (let* ((remote-prefix (file-remote-p default-directory))
         (local-path (file-remote-p default-directory 'localname))
         (flags (string-join '("--line-number"
                               "--with-filename"
                               "--no-heading"  ;; CHANGED: No heading for standard grep format
                               "--no-config"
                               "--max-count=500"
                               "--glob=!**/*undo-tree*"
                               "--glob=!**/.old/**"
                               "--glob=!**/*.log"
                               "--glob=!**/RUNNING/**"
                               "--glob=!**/FINISHED_SUCCESS/**"
                               "--glob=!**/FINISHED/**")
                             " "))
         ;; Create a command that outputs grep-compatible format
         (cmd (format "~/.local/bin/rg %s %s . | sed 's|^\\./|%s%s/|'" 
                      flags 
                      (shell-quote-argument query)
                      remote-prefix
                      local-path)))

    (my/rg-debug-message "Remote prefix: %s" remote-prefix)
    (my/rg-debug-message "Local path: %s" local-path)
    (my/rg-debug-message "Command: %s" cmd)
    
    ;; Use compilation-start to create a proper grep buffer
    (compilation-start cmd 'grep-mode
                       (lambda (_) "*rg-v24*")
                       nil)))

(defun my/rg-search-remote-v24-alternative (query)
  "V24 Alternative: Create grep buffer manually but mimic grep exactly."
  (my/rg-debug-message "=== REMOTE SEARCH ALTERNATIVE ===")
  
  (let* ((remote-prefix (file-remote-p default-directory))
         (local-path (file-remote-p default-directory 'localname))
         (flags (string-join '("--line-number"
                               "--with-filename"
                               "--no-heading"
                               "--no-config"
                               "--max-count=500"
                               "--glob=!**/*undo-tree*"
                               "--glob=!**/.old/**"
                               "--glob=!**/*.log"
                               "--glob=!**/RUNNING/**"
                               "--glob=!**/FINISHED_SUCCESS/**"
                               "--glob=!**/FINISHED/**")
                             " "))
         (buffer-name "*rg-v24-alt*"))

    (my/rg-debug-message "Executing remote command...")
    (let* ((cmd (format "~/.local/bin/rg %s %s ." flags (shell-quote-argument query)))
           (result (shell-command-to-string cmd)))
      
      (my/rg-debug-message "Result length: %d chars" (length result))
      
      ;; Create buffer mimicking standard grep
      (let ((buffer (get-buffer-create buffer-name)))
        (with-current-buffer buffer
          (let ((inhibit-read-only t))
            (erase-buffer)
            (insert (format "-*- mode: grep; default-directory: \"%s\" -*-\n\n" default-directory))
            (insert (format "rg %s\n\n" (shell-quote-argument query)))
            
            ;; Process and insert results in standard grep format
            (save-excursion
              (let ((temp-buffer (generate-new-buffer " *temp*")))
                (with-current-buffer temp-buffer
                  (insert result)
                  (goto-char (point-min))
                  ;; Convert relative paths to absolute TRAMP paths
                  (while (re-search-forward "^\\./\\([^:]+\\):\\([0-9]+\\):\\(.+\\)$" nil t)
                    (let* ((file (match-string 1))
                           (line (match-string 2))
                           (content (match-string 3))
                           (abs-path (expand-file-name file local-path))
                           (final-path (concat remote-prefix abs-path)))
                      (with-current-buffer buffer
                        (insert (format "%s:%s:%s\n" final-path line content))))))
                (kill-buffer temp-buffer))))
          
          ;; Set up grep-mode
          (grep-mode)
          (setq-local compilation-directory default-directory)
          
          ;; Let grep-mode handle the rest
          (setq buffer-read-only t))
        
        (pop-to-buffer buffer)))))

;; 3. Setup with alternative command
;; ----------------------------------------

(defun my/rg-search-v24-alt (query)
  "V24 Alternative version for testing."
  (interactive "sV24-Alt Search: ")
  (let* ((search-directory
          (if (file-remote-p default-directory)
              default-directory
            (or (and (eq major-mode 'dired-mode)
                     (dired-current-directory))
                default-directory))))
    (if (file-remote-p search-directory)
        (let ((default-directory search-directory))
          (my/rg-search-remote-v24-alternative query))
      (let ((default-directory search-directory))
        (rg-project query "*")))))

(global-set-key (kbd "C-S-g") 'my/rg-search)
(global-set-key (kbd "C-S-h") 'my/rg-search-v24-alt)  ;; Alternative binding for testing

(message "=== V24 LOADED - Using compilation-start ===")
(message "V24: C-S-g uses compilation-start for proper grep buffer")
(message "V24: C-S-h uses alternative manual approach")
(message "V24: Both should support wgrep properly")

;; SUMMARY:
;; V23: ❌ Manual buffer setup incompatible with wgrep
;; V24: ✅ Use compilation-start for proper grep buffer setup

(provide '02-base-230-wgrep-ripgrep-v24)

(when (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v24.el loaded - Proper grep buffer"))