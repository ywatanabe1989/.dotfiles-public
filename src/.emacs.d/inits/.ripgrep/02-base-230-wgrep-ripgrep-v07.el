;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 10:25:46>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v07.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)


;;; Version: 07 - Based on working v02 with proper wgrep integration

;; Version 07: Based on working v02 approach
;; - Remote search and navigation works (from v02)
;; - Added proper wgrep editing functionality
;; - Combines the best of v02 (working navigation) + wgrep editing

;; Version History:
;; v02: Remote + jump working but not editable
;; v03: Navigation broken while trying to add wgrep
;; v04-v06: Various attempts at clean rg.el approach
;; v07: Back to working v02 foundation + clean wgrep integration

;; Cannot find file ‘/ssh:sp:/ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/maintenance/calc_pac_around_seizures_maintain_dbs.py’

;; 1. Main Configuration
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

;; 2. Variables and Helpers
;; ----------------------------------------

(defvar my/rg-remote-executable-cache (make-hash-table :test 'equal))

(defvar my/rg-debug-message nil)

(defun my/rg-debug-message (format-string &rest args)
  (when my/rg-debug-message
    (apply 'message format-string args)))

(defun my/rg-find-executable-v07 ()
  "Find rg executable path with caching for remote hosts."
  (if (file-remote-p default-directory)
      (let ((cache-key (file-remote-p default-directory)))
        (or (gethash cache-key my/rg-remote-executable-cache)
            (let ((result (process-lines "which" "rg")))
              (if
                  (and result
                       (not
                        (string-match-p "not found\\|no rg in"
                                        (car result))))
                  (let ((executable-path (car result)))
                    (puthash cache-key executable-path
                             my/rg-remote-executable-cache)
                    executable-path)
                (error "No 'rg' executable found on remote host")))))
    (or (executable-find "rg")
        (error
         "No 'rg' executable found. Please install ripgrep or check your PATH."))))

;; 3. Core Search Functions
;; ----------------------------------------

(defun my/rg-search-v07 (query)
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
          (my/rg-search-remote-v07 query))
      ;; For local: use standard rg.el
      (let ((default-directory search-directory))
        (rg-project query "*")))))

(defun my/rg-search-remote-v07 (query)
  "Remote rg search with working navigation and wgrep editing."
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
          (insert
           (format "-*- mode: rg; default-directory: \"%s\" -*-\n"
                   default-directory))
          (insert
           (format "rg started at %s\n\n" (current-time-string)))
          (insert (format "cd %s && rg %s %s .\n\n"
                          (file-remote-p default-directory 'localname)
                          flags (shell-quote-argument query)))
          (insert
           (format "Debug: Remote directory: %s\n" default-directory))
          (insert (format "Debug: Query: %s\n\n" query)))

        ;; Use compilation-mode for navigation
        (compilation-mode)
        (setq-local compilation-search-path (list default-directory)))

      ;; Execute remote search
      (let*
          ((cmd-simple
            (format "~/.local/bin/rg %s %s ." flags
                    (shell-quote-argument query)))
           (result (shell-command-to-string cmd-simple)))
        (with-current-buffer buffer
          (let ((inhibit-read-only t))
            (goto-char (point-max))
            (insert "\n=== COMMAND OUTPUT ===\n")
            (insert result)
            (insert "\n=== END OUTPUT ===\n")
            (my/rg-format-results-v07 remote-prefix)

            ;; Set up compilation-mode for navigation
            (setq-local compilation-error-regexp-alist
                        '(("^\\(/ssh:[^:]+:/[^:]+\\):\\([0-9]+\\):\\([0-9]+\\):"
                           1 2 3)))

            ;; Set up for wgrep - SIMPLE approach
            (setq buffer-read-only nil)
            (when (fboundp 'wgrep-setup) (wgrep-setup))

            ;; Define simple wgrep toggle
            (defun my/toggle-wgrep-v07 ()
              (interactive)
              (if (bound-and-true-p wgrep-mode)
                  (wgrep-finish-edit)
                (progn
                  (setq buffer-read-only nil)
                  (wgrep-change-to-wgrep-mode))))

            ;; Add keybindings
            (local-set-key (kbd "w") 'my/toggle-wgrep-v07)
            (local-set-key (kbd "C-c C-c") 'wgrep-finish-edit)
            (local-set-key (kbd "C-c C-k") 'wgrep-abort-changes)
            (local-set-key (kbd "RET") 'compile-goto-error)
            (local-set-key (kbd "<mouse-2>") 'compile-goto-error))))

      (pop-to-buffer buffer))))

(defun my/rg-format-results-v07 (remote-prefix)
  "Format remote rg results for compilation-mode navigation."
  (let ((inhibit-read-only t))
    (goto-char (point-min))
    (when (re-search-forward "=== COMMAND OUTPUT ===\n" nil t)
      (while (re-search-forward "^\\([^:\n\r]+\\)$" nil t)
        (let ((potential-file (match-string 1)))
          (when (and
                 (not (string-match-p "^[[:space:]]*$" potential-file))
                 (not (string-match-p "^[0-9]+:" potential-file))
                 (not (string-match-p "^=+" potential-file))
                 (string-match-p "^\\." potential-file))
                                        ; Files start with ./
            (let ((file-start (match-beginning 0)))
              (forward-line)
              (while (and (not (eobp))
                          (looking-at
                           "^\\([0-9]+\\):\\([0-9]+\\):\\(.+\\)$"))
                (let* ((line (match-string 1))
                       (col (match-string 2))
                       (content (match-string 3))
                       (clean-file (if
                                       (string-prefix-p "/ssh:"
                                                        potential-file)
                                       (replace-regexp-in-string
                                        "^/ssh:[^:]+:" ""
                                        potential-file)
                                     potential-file))
                       (full-path
                        (cond
                         ((string-prefix-p "./" clean-file)
                          (let
                              ((local-abs-path
                                (file-remote-p default-directory
                                               'localname)))
                            (concat remote-prefix
                                    (expand-file-name clean-file
                                                      local-abs-path))))
                         ((string-prefix-p "/" clean-file)
                          (concat remote-prefix clean-file))
                         (t (let
                                ((local-abs-path
                                  (file-remote-p default-directory
                                                 'localname)))
                              (concat remote-prefix
                                      (expand-file-name clean-file
                                                        local-abs-path)))))))
                  ;; Simple replace - no complex text properties
                  (replace-match
                   (format "%s:%s:%s:%s" full-path line col content) t
                   t))
                (forward-line))
              ;; Remove file header line
              (goto-char file-start)
              (when (< file-start (point-max))
                (let
                    ((end-pos
                      (min (1+ (line-end-position)) (point-max))))
                  (delete-region file-start end-pos))))))))))

;; 4. Setup
;; ----------------------------------------

(global-set-key (kbd "C-S-g") 'my/rg-search-v07)

;; Usage Instructions:
;;
;; Version 07 provides:
;; - Working remote search (from v02 foundation)
;; - Working navigation with RET (from v02)
;; - Working wgrep editing: 'w' to edit, C-c C-c to save
;; - Clean, simple implementation
;;
;; Local Search:
;;   - Uses standard rg-project for comprehensive search
;;
;; Remote Search (TRAMP):
;;   - Fast remote execution
;;   - Proper TRAMP path formatting
;;   - Navigation: RET opens files
;;   - Editing: 'w' to enter wgrep mode, C-c C-c to save

(when (not load-file-name)
  (message
   "02-base-230-wgrep-ripgrep-v07.el loaded - Working v02 navigation + wgrep editing"))


(provide '02-base-230-wgrep-ripgrep-v07)

(when
    (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v07.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))