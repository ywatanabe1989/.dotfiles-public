;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 10:30:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v12-diagnostic.el
;;; Version: 12 - DIAGNOSTIC to find the issue

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

;; Version 12: DIAGNOSTIC VERSION
;; - Find what's still calling the old my/rg-search
;; - Create stub functions to catch calls
;; - Trace the problem source

;; STEP 1: Create diagnostic stub for the old function
;; ----------------------------------------

(defun my/rg-search (&rest args)
  "DIAGNOSTIC STUB: Catches calls to old my/rg-search."
  (interactive "sOLD FUNCTION CALLED - Search: ")
  (message "=== DIAGNOSTIC: OLD my/rg-search WAS CALLED ===")
  (message "DIAGNOSTIC: Args: %s" args)
  (message "DIAGNOSTIC: Called from: %s" (backtrace-to-string (backtrace)))
  (message "DIAGNOSTIC: This should NOT happen!")
  ;; Call the new function instead
  (call-interactively 'my/rg-search-v12))

;; STEP 2: Define the new working function
;; ----------------------------------------

(defun my/rg-search-v12 (query)
  "V12: WORKING search function."
  (interactive "sV12 Search: ")
  (message "=== V12: CORRECT FUNCTION CALLED ===")
  (message "V12: Query: %s" query)
  (message "V12: Directory: %s" default-directory)
  
  ;; Simple test implementation first
  (let ((buffer (get-buffer-create "*v12-test*")))
    (with-current-buffer buffer
      (erase-buffer)
      (insert "V12 Test Search Results\n")
      (insert "======================\n\n")
      (insert (format "Query: %s\n" query))
      (insert (format "Directory: %s\n" default-directory))
      (insert (format "Remote: %s\n" (file-remote-p default-directory)))
      (insert (format "Time: %s\n\n" (current-time-string)))
      
      ;; If remote, do actual search
      (when (file-remote-p default-directory)
        (let* ((cmd (format "~/.local/bin/rg --line-number --max-count=10 %s ." 
                           (shell-quote-argument query)))
               (result (shell-command-to-string cmd)))
          (insert "Raw results:\n")
          (insert result)
          (insert "\n\nFormatted paths:\n")
          
          ;; Show path construction
          (let ((remote-prefix (file-remote-p default-directory))
                (local-path (file-remote-p default-directory 'localname)))
            (insert (format "Remote prefix: %s\n" remote-prefix))
            (insert (format "Local path: %s\n" local-path))
            
            ;; Parse a sample file
            (when (string-match "^\\(\\./[^:\n]+\\)" result)
              (let* ((sample-file (match-string 1 result))
                     (expanded (expand-file-name sample-file local-path))
                     (final-path (concat remote-prefix expanded)))
                (insert (format "\nSample path construction:\n"))
                (insert (format "  Raw: %s\n" sample-file))
                (insert (format "  Expanded: %s\n" expanded))
                (insert (format "  Final: %s\n" final-path))
                (insert (format "  Has double prefix: %s\n" 
                               (string-match-p "/ssh:[^:]+:/ssh:" final-path)))))))))
    
    (pop-to-buffer buffer)
    (message "V12: Test completed successfully")))

;; STEP 3: Diagnostic keybinding checks
;; ----------------------------------------

(defun my/diagnostic-keybinding ()
  "Check what C-S-g is actually bound to."
  (interactive)
  (let ((binding (key-binding (kbd "C-S-g"))))
    (message "=== KEYBINDING DIAGNOSTIC ===")
    (message "C-S-g is bound to: %s" binding)
    (message "Function symbol: %s" (if (symbolp binding) binding "NOT A SYMBOL"))
    (message "Function exists: %s" (if (symbolp binding) (fboundp binding) "N/A"))
    (message "Is command: %s" (if (symbolp binding) (commandp binding) "N/A"))
    (message "Function definition: %s" 
             (if (and (symbolp binding) (fboundp binding))
                 (symbol-function binding)
               "UNDEFINED"))))

;; STEP 4: Set up bindings and diagnostics  
;; ----------------------------------------

;; Clear old binding first
(global-unset-key (kbd "C-S-g"))

;; Set new binding
(global-set-key (kbd "C-S-g") 'my/rg-search-v12)

;; Add diagnostic binding
(global-set-key (kbd "C-c d") 'my/diagnostic-keybinding)

;; STEP 5: Package configuration
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

;; STEP 6: Final diagnostics
;; ----------------------------------------

(message "=== V12 DIAGNOSTIC VERSION LOADED ===")
(message "V12: Created diagnostic stub for old my/rg-search")
(message "V12: New function: my/rg-search-v12") 
(message "V12: C-S-g bound to: %s" (key-binding (kbd "C-S-g")))
(message "V12: Try C-S-g now")
(message "V12: Try C-c d for keybinding diagnostics")
(message "V12: If old function is called, you'll see diagnostic messages")

(provide '02-base-230-wgrep-ripgrep-v12-diagnostic)

(when (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v12-diagnostic.el loaded - DIAGNOSTIC MODE"))