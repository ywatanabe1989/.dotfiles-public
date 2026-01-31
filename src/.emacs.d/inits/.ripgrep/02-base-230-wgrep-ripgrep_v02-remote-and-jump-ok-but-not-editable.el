;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 09:55:37>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)


;; Cannot find file ‘/ssh:sp:/ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/maintenance/calc_pac_around_seizures_maintain_dbs.py’


;; 1. Main Configuration
;; ----------------------------------------

(use-package wgrep
  :ensure
  t
  :config
  (setq wgrep-enable-key "r")
  (setq wgrep-auto-save-buffer t)
  (setq wgrep-change-readonly-file t))

(use-package rg
  :ensure
  t
  :config
  (rg-enable-default-bindings)
  (define-key rg-mode-map (kbd "RET") 'compile-goto-error))

(defvar my/rg-debug-message nil)

(defvar my/rg-remote-executable-cache (make-hash-table :test 'equal))

(defvar my/rg-remote-search-buffer "*rg-remote*")

(defun my/rg-debug-message (format-string &rest args)
  (when my/rg-debug-message
    (apply 'message format-string args)))

;; 2. Core Functions
;; ----------------------------------------

(defun my/rg-find-executable ()
  "Find rg executable path with caching for remote hosts."
  (my/rg-debug-message "DEBUG: my/rg-find-executable called")
  (my/rg-debug-message "DEBUG: default-directory = %s"
                       default-directory)
  (my/rg-debug-message "DEBUG: file-remote-p = %s"
                       (file-remote-p default-directory))
  (if (file-remote-p default-directory)
      (let ((cache-key (file-remote-p default-directory)))
        (or (gethash cache-key my/rg-remote-executable-cache)
            (let ((result (process-lines "which" "rg")))
              (my/rg-debug-message "DEBUG: remote which result = %s"
                                   result)
              (if
                  (and result
                       (not
                        (string-match-p "not found\\|no rg in"
                                        (car result))))
                  (let ((executable-path (car result)))
                    (my/rg-debug-message
                     "DEBUG: found rg at %s, caching" executable-path)
                    (puthash cache-key executable-path
                             my/rg-remote-executable-cache)
                    executable-path)
                (error "No 'rg' executable found on remote host")))))
    (let ((local-rg (executable-find "rg")))
      (my/rg-debug-message "DEBUG: local executable-find result = %s"
                           local-rg)
      (or local-rg
          (error
           "No 'rg' executable found. Please install ripgrep or check your PATH.")))))

(defun my/rg-search-remote-fast (query)
  "Fast remote rg search using async shell command with rg-mode-like formatting."
  (my/rg-debug-message
   "DEBUG: my/rg-search-remote-fast called with query: %s" query)
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
         (cmd (format "cd %s && rg %s %s ."
                      (shell-quote-argument
                       (file-remote-p default-directory 'localname))
                      flags
                      (shell-quote-argument query)))
         (buffer-name "*rg*"))
    (my/rg-debug-message "DEBUG: remote command: %s" cmd)
    (let ((buffer (get-buffer-create buffer-name)))
      (with-current-buffer buffer
        (setq-local default-directory default-directory)
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert (format
                   "-*- mode: rg; default-directory: \"%s\" -*-\n"
                   default-directory))
          (insert
           (format "rg started at %s\n\n" (current-time-string)))
          (insert (format "%s\n\n" cmd))
          (insert
           (format "Debug: Remote directory: %s\n"
                   default-directory))
          (insert (format "Debug: Query: %s\n\n" query)))
        ;; Use compilation-mode for better wgrep integration
        (compilation-mode)
        (setq-local compilation-search-path (list default-directory)))
      ;; Use simple synchronous approach with full path
      (let* ((default-directory default-directory)
             (cmd-simple
              (format "~/.local/bin/rg %s %s ." flags
                      (shell-quote-argument query)))
             (result (shell-command-to-string cmd-simple)))
        (with-current-buffer buffer
          (let ((inhibit-read-only t))
            (goto-char (point-max))
            (insert "\n=== COMMAND OUTPUT ===\n")
            (insert result)
            (insert "\n=== END OUTPUT ===\n")
            (my/rg-format-remote-results-rg-style remote-prefix)
            ;; Set up compilation-mode for navigation
            (setq-local compilation-error-regexp-alist
                        '(("^\\(/ssh:[^:]+:/[^:]+\\):\\([0-9]+\\):\\([0-9]+\\):"
                           1 2 3)))
            ;; Force buffer to be writable
            (setq buffer-read-only nil)
            (setq-local buffer-read-only nil)
            ;; Enable wgrep functionality after making buffer writable
            (when (fboundp 'wgrep-setup)
              (wgrep-setup))
            ;; Add custom function to toggle wgrep mode
            (defun my/toggle-wgrep ()
              (interactive)
              (if (bound-and-true-p wgrep-mode)
                  (wgrep-finish-edit)
                (progn
                  (setq buffer-read-only nil)
                  (wgrep-change-to-wgrep-mode))))
            ;; Add wgrep keybindings
            (local-set-key (kbd "w") 'my/toggle-wgrep)
            (local-set-key (kbd "C-c C-c") 'wgrep-finish-edit)
            (local-set-key (kbd "C-c C-k") 'wgrep-abort-changes)
            ;; Add compilation navigation
            (local-set-key (kbd "RET") 'compile-goto-error)
            (local-set-key (kbd "<mouse-2>") 'compile-goto-error))))
      (pop-to-buffer buffer))))

(defun my/rg-format-remote-results (remote-prefix)
  "Format remote rg results with proper file paths."
  (let ((inhibit-read-only t))
    (goto-char (point-min))
    (while
        (re-search-forward "^\\([^:\n]+\\):\\([0-9]+\\):\\([0-9]+\\):"
                           nil t)
      (let ((file (match-string 1))
            (line (match-string 2))
            (col (match-string 3)))
        (replace-match
         (format "%s%s:%s:%s:" remote-prefix file line col)
         t t)))))

(defun my/rg-format-remote-results-rg-style (remote-prefix)
  "Format remote rg results for compilation-mode navigation."
  (let ((inhibit-read-only t))
    (goto-char (point-min))
    ;; Find the start of actual results
    (when (re-search-forward "=== COMMAND OUTPUT ===\n" nil t)
      (let ((start-pos (point)))
        ;; Process each file section
        (while (re-search-forward "^\\([^:\n\r]+\\)$" nil t)
          (let ((potential-file (match-string 1)))
            ;; Skip lines that don't look like filenames
            (when (and
                   (not
                    (string-match-p "^[[:space:]]*$" potential-file))
                   (not (string-match-p "^[0-9]+:" potential-file))
                   (not (string-match-p "^=+" potential-file))
                   (string-match-p "^\\." potential-file))
                                        ; Files start with ./
              ;; Convert to compilation-mode format: filename:line:col:content
              (let ((file-start (match-beginning 0)))
                (forward-line)
                ;; Process lines under this file
                (while (and (not (eobp))
                            (looking-at
                             "^\\([0-9]+\\):\\([0-9]+\\):\\(.+\\)$"))
                  (let* ((line (match-string 1))
                         (col (match-string 2))
                         (content (match-string 3))
                         (clean-file (if
                                         (string-prefix-p "/ssh:"
                                                          potential-file)
                                         ;; Remove any existing TRAMP prefix to avoid duplication
                                         (replace-regexp-in-string
                                          "^/ssh:[^:]+:" ""
                                          potential-file)
                                       potential-file))
                         (full-path
                          (cond
                           ;; If starts with ./ convert to absolute path
                           ((string-prefix-p "./" clean-file)
                            (let ((local-abs-path (file-remote-p default-directory 'localname)))
                              (concat remote-prefix 
                                      (expand-file-name clean-file local-abs-path))))
                           ;; If it's already an absolute path, add remote prefix
                           ((string-prefix-p "/" clean-file)
                            (concat remote-prefix clean-file))
                           ;; Otherwise, assume it's a relative file and make it absolute
                           (t (let ((local-abs-path (file-remote-p default-directory 'localname)))
                                (concat remote-prefix 
                                        (expand-file-name clean-file local-abs-path)))))))
                    ;; Replace with compilation-mode format
                    (replace-match
                     (format "%s:%s:%s:%s" full-path line col content)
                     t t))
                  (forward-line))
                ;; Remove the file header line safely
                (goto-char file-start)
                (when (< file-start (point-max))
                  (let
                      ((end-pos
                        (min (1+ (line-end-position)) (point-max))))
                    (delete-region file-start end-pos)))))))))))

(defun my/rg-search (query)
  "Run rg in the current directory. Automatically uses fast remote version for TRAMP."
  (interactive "sRegexp search for: ")
  (my/rg-debug-message "DEBUG: my/rg-search called with query: %s"
                       query)
  (my/rg-debug-message "DEBUG: current directory: %s"
                       default-directory)

  ;; Get the correct directory - use my/path-get-path in dired mode
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
    (my/rg-debug-message "DEBUG: search directory: %s"
                         search-directory)

    ;; Use fast remote version for TRAMP connections
    (if (or (file-remote-p search-directory)
            (file-remote-p default-directory))
        (let ((default-directory (if (file-remote-p search-directory) 
                                     search-directory 
                                   default-directory)))
          (my/rg-search-remote-fast query))
      ;; Use standard rg.el for local searches
      (let ((default-directory search-directory))
        (let* ((rg-executable-path (my/rg-find-executable))
               (rg-command-line-flags
                (list "--no-ignore"
                      "--glob=!**/*undo-tree*"
                      "--glob=!**/.old/**"
                      "--glob=!**/*.log"
                      "--glob=!**/RUNNING/**"
                      "--glob=!**/FINISHED_SUCCESS/**"
                      "--glob=!**/FINISHED/**")))
          (my/rg-debug-message "DEBUG: rg executable path: %s"
                               rg-executable-path)
          (my/rg-debug-message "DEBUG: rg command line flags: %s"
                               rg-command-line-flags)
          (cl-letf (((symbol-function 'rg-executable)
                     (lambda ()
                       (my/rg-debug-message
                        "DEBUG: rg-executable override called, returning: %s"
                        rg-executable-path)
                       rg-executable-path)))
            (my/rg-debug-message
             "DEBUG: calling rg-run with: query=%s, type=*, dir=./" query)
            (rg-run query "*" "./")))))))

;; 3. Helper Functions
;; ----------------------------------------

(defun my/rg-check-executable ()
  "Check if rg is installed and usable."
  (interactive)
  (if (file-remote-p default-directory)
      (let ((result (process-lines "which" "rg")))
        (when (or (null result)
                  (string-match-p "not found\\|no rg in" (car result)))
          (error "No 'rg' executable found on remote host")))
    (unless (executable-find "rg")
      (error
       "No 'rg' executable found. Please install ripgrep or check your PATH."))))

(defun my/rg-get-remote-prefix (file-path)
  "Return the SSH prefix for the given FILE-PATH."
  (when
      (string-match "^/\\(?:ssh\\|scp\\|rsync\\|sshx\\):\\([^:]+\\):"
                    file-path)
    (match-string 0 file-path)))

(defun my/rg-remove-remote-prefix (path)
  "Remove the initial SSH prefix from PATH if present."
  (if (file-remote-p path)
      (substring path (1+ (string-match-p ":" path)))
    path))

(defun my/rg-prepend-remote-prefix (func &rest args)
  "Prepend the remote prefix to file paths in the rg buffer."
  (let* ((result (apply func args))
         (tramp-prefix (my/rg-get-remote-prefix
                        (or buffer-file-name default-directory))))
    (mapcar (lambda (file-path)
              (if (string-match-p "^/" file-path)
                  (concat tramp-prefix
                          (my/rg-remove-remote-prefix file-path))
                file-path))
            result)))

(defun my/rg-modify-results (&rest _)
  "Modify the ripgrep results to include the remote prefix."
  (when
      (and (eq major-mode 'rg-mode) (file-remote-p default-directory))
    (let ((inhibit-read-only t)
          (remote-prefix (file-remote-p default-directory)))
      (goto-char (point-min))
      (while (re-search-forward "^\\([^:\n]+\\):" nil t)
        (replace-match (concat remote-prefix (match-string 1)) t t nil
                       1)))))

(defun my/rg-enable-wgrep (&rest _args)
  "Automatically enable wgrep mode in rg-mode buffers."
  (when (eq major-mode 'rg-mode)
    (set (make-local-variable 'wgrep-auto-save-buffer) t)
    (wgrep-change-to-wgrep-mode)))

;; 4. Setup
;; ----------------------------------------
(advice-add 'wgrep-process-extract-result :around
            #'my/rg-prepend-remote-prefix)
(advice-add 'rg-run :after #'my/rg-modify-results)

(global-set-key (kbd "C-S-g") 'my/rg-search)

;; on remote, sp, this error raised when I call my/rg-search on dired mode; why?
;; user-error: No ’rg’ executable found in host sp


(provide '02-base-230-wgrep-ripgrep)

(when
    (not load-file-name)
  (message "02-base-230-wgrep-ripgrep.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))