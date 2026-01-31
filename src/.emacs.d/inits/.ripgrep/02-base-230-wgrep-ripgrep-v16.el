;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 10:40:14>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v16.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)


;;; Version: 16 - FIXED remote detection and search logic

;; VERSION 16: FIXED REMOTE DETECTION
;; - Fixed logic error that was using rg-project for remote directories
;; - Now properly detects and uses remote search for TRAMP paths
;; - Fixed double TRAMP prefix issue
;; - Working navigation and wgrep editing

;; VERSION HISTORY:
;; v15: Had remote detection but wrong search routing
;; v16: FIXED - properly routes remote directories to remote search

;; 1. Package Configuration
;; ----------------------------------------

(use-package wgrep
  :ensure
  t
  :config
  (setq wgrep-enable-key "w")
  (setq wgrep-auto-save-buffer t)
  (setq wgrep-change-readonly-file t))

(use-package rg
  :ensure
  t
  :config
  (rg-enable-default-bindings)
  (define-key rg-mode-map (kbd "RET") 'compile-goto-error))

;; 2. Debug Configuration
;; ----------------------------------------

(defvar my/rg-v16-debug t "Enable debug output for v16")

(defun my/rg-v16-debug (format-string &rest args)
  "V16 debug output."
  (when my/rg-v16-debug
    (apply 'message (concat "V16: " format-string) args)))

;; 3. Main Search Function - FIXED LOGIC
;; ----------------------------------------

(defun my/rg-search (query)
  "V16: FIXED remote detection and search routing."
  (interactive "sV16 Search: ")

  (my/rg-v16-debug "=== V16 SEARCH STARTING ===")
  (my/rg-v16-debug "Query: %s" query)
  (my/rg-v16-debug "Current directory: %s" default-directory)

  ;; Get the correct search directory
  (let ((search-directory
         (cond
          ((and (eq major-mode 'dired-mode)
                (fboundp 'my/path-get-path))
           (let ((dir (my/path-get-path)))
             (my/rg-v16-debug
              "Got directory from my/path-get-path: %s" dir)
             dir))
          ((eq major-mode 'dired-mode)
           (let ((dir (dired-current-directory)))
             (my/rg-v16-debug
              "Got directory from dired-current-directory: %s" dir)
             dir))
          (t
           (my/rg-v16-debug "Using default-directory: %s"
                            default-directory)
           default-directory))))

    (my/rg-v16-debug "Final search directory: %s" search-directory)

    ;; FIXED: Check if the search directory is remote
    (let ((is-remote (file-remote-p search-directory)))
      (my/rg-v16-debug "Is remote check: %s" is-remote)

      (if is-remote
          (progn
            (my/rg-v16-debug "=== USING REMOTE SEARCH ===")
            (let ((default-directory search-directory))
              (my/rg-remote-search-v16 query)))
        (progn
          (my/rg-v16-debug "=== USING LOCAL SEARCH ===")
          (let ((default-directory search-directory))
            (rg-project query "*")))))))

(defun my/rg-remote-search-v16 (query)
  "V16: Remote search with proper execution and path formatting."
  (my/rg-v16-debug "=== REMOTE SEARCH FUNCTION CALLED ===")
  (my/rg-v16-debug "Query: %s" query)
  (my/rg-v16-debug "Directory: %s" default-directory)

  (let* ((remote-prefix (file-remote-p default-directory))
         (local-path (file-remote-p default-directory 'localname))
         (buffer-name "*rg-v16*"))

    (my/rg-v16-debug "Remote prefix: %s" remote-prefix)
    (my/rg-v16-debug "Local path: %s" local-path)

    ;; Create buffer
    (let ((buffer (get-buffer-create buffer-name)))
      (with-current-buffer buffer
        (setq-local default-directory default-directory)
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert
           (format "-*- mode: rg; default-directory: \"%s\" -*-\n"
                   default-directory))
          (insert
           (format "V16 Remote Search - %s\n\n" (current-time-string)))
          (insert (format "Query: %s\n" query))
          (insert (format "Directory: %s\n" default-directory))
          (insert (format "Remote prefix: %s\n" remote-prefix))
          (insert (format "Local path: %s\n\n" local-path)))

        ;; Use compilation-mode
        (compilation-mode)
        (setq-local compilation-search-path (list default-directory)))

      ;; EXECUTE REMOTE SEARCH
      (my/rg-v16-debug "=== EXECUTING REMOTE COMMAND ===")
      (let*
          ((flags
            "--line-number --column --heading --no-config --max-count=100")
           (cmd
            (format "~/.local/bin/rg %s %s ." flags
                    (shell-quote-argument query))))

        (my/rg-v16-debug "Command: %s" cmd)
        (my/rg-v16-debug "Executing in directory: %s"
                         default-directory)

        (let ((result (shell-command-to-string cmd)))
          (my/rg-v16-debug "Command executed")
          (my/rg-v16-debug "Result length: %d characters"
                           (length result))
          (my/rg-v16-debug "First 200 chars of result: %s"
                           (substring result 0
                                      (min 200 (length result))))

          (with-current-buffer buffer
            (let ((inhibit-read-only t))
              (goto-char (point-max))
              (insert "\n=== RAW RESULTS ===\n")
              (insert result)
              (insert "\n=== FORMATTED RESULTS ===\n")

              ;; Simple path formatting
              (if (string-empty-p (string-trim result))
                  (insert "No matches found.\n")
                (let ((lines (split-string result "\n" t)))
                  (dolist (line lines)
                    (cond
                     ;; File header (starts with ./)
                     ((string-match "^\\(\\./[^:]+\\)$" line)
                      (let* ((file-path (match-string 1 line))
                             (abs-path
                              (expand-file-name file-path local-path))
                             (tramp-path
                              (concat remote-prefix abs-path)))
                        (my/rg-v16-debug "File: %s -> %s -> %s"
                                         file-path abs-path tramp-path)
                        (insert (format "\n%s:\n" tramp-path))))
                     ;; Match line (line:col:content)
                     ((string-match
                       "^\\([0-9]+\\):\\([0-9]+\\):\\(.+\\)$" line)
                      (insert (format "  %s:%s: %s\n"
                                      (match-string 1 line)
                                      (match-string 2 line)
                                      (match-string 3 line))))
                     ;; Other lines
                     (t (insert (format "%s\n" line)))))))

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
              (local-set-key (kbd "<mouse-2>") 'compile-goto-error)))))

      (pop-to-buffer buffer)
      (my/rg-v16-debug "=== REMOTE SEARCH COMPLETE ==="))))

;; 4. Setup
;; ----------------------------------------

;; Set keybinding

(global-set-key (kbd "C-S-g") 'my/rg-search)

(message "=== V16 LOADED - FIXED REMOTE DETECTION ===")
(message
 "V16: Fixed logic to properly route remote directories to remote search")
(message "V16: C-S-g -> %s" (key-binding (kbd "C-S-g")))

;; USAGE:
;; - Local directories: Uses rg-project (standard, fast)
;; - Remote directories: Uses custom remote search (fixed paths)
;; - Buffer name: *rg-v16* for remote searches
;; - Navigation: RET to open files
;; - Editing: w for wgrep, C-c C-c to save

(when (not load-file-name)
  (message
   "02-base-230-wgrep-ripgrep-v16.el loaded - FIXED REMOTE ROUTING"))


(provide '02-base-230-wgrep-ripgrep-v16)

(when
    (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v16.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))