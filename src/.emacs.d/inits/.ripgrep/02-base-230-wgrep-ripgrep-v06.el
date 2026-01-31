;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 10:25:21>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v06.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)


;;; Version: 06 - Working remote search with clean wgrep integration

;; Version 06: Based on working v03 approach
;; - Uses custom remote search that actually works
;; - Clean wgrep integration without read-only issues
;; - Proper navigation and editing functionality
;; - Simplified from complex v03 implementation

;; Version History:
;; v03: Complex custom remote - works but messy
;; v04: Clean rg.el approach but type filtering issues
;; v05: Fixed type filtering but still issues
;; v06: Back to working v03 approach but cleaned up

;; ;; This had problem with path resolution
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

;; 2. Core Functions
;; ----------------------------------------

(defun my/rg-search-v06 (query)
  "Run rg search with automatic remote/local detection.

   For remote directories (TRAMP):
   - Executes ripgrep directly on remote host
   - Fast execution without file transfer overhead
   - Proper TRAMP path formatting

   For local directories:
   - Uses standard rg.el"
  (interactive "sRegexp search for: ")

  ;; Get the correct directory - use my/path-get-path in dired mode if available
  (let ((search-directory
         (cond
          ((and (eq major-mode 'dired-mode)
                (fboundp 'my/path-get-path))
           (my/path-get-path))
          ((eq major-mode 'dired-mode)
           (dired-current-directory))
          (t default-directory))))

    ;; Use custom remote search for TRAMP, standard rg.el for local
    (if (file-remote-p search-directory)
        (let ((default-directory search-directory))
          (my/rg-search-remote-v06 query))
      ;; Use standard rg.el for local searches
      (let ((default-directory search-directory))
        (rg-project query "*")))))

(defun my/rg-search-remote-v06 (query)
  "Fast remote rg search with wgrep support."
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
                          flags
                          (shell-quote-argument query)))
          (insert
           (format "Debug: Remote directory: %s\n" default-directory))
          (insert (format "Debug: Query: %s\n\n" query)))

        ;; Use compilation-mode
        (compilation-mode)
        (setq-local compilation-search-path (list default-directory)))

      ;; Execute remote command
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
            (my/rg-format-results-v06 remote-prefix)

            ;; Set up compilation-mode for navigation
            (setq-local compilation-error-regexp-alist
                        '(("^\\(/ssh:[^:]+:/[^:]+\\):\\([0-9]+\\):\\([0-9]+\\):"
                           1 2 3)))

            ;; Set up for wgrep - keep simple
            (setq buffer-read-only nil)
            (setq-local wgrep-auto-save-buffer t)
            (setq-local wgrep-change-readonly-file t)

            ;; Add keybindings
            (local-set-key (kbd "w") 'wgrep-change-to-wgrep-mode)
            (local-set-key (kbd "C-c C-c") 'wgrep-finish-edit)
            (local-set-key (kbd "C-c C-k") 'wgrep-abort-changes)
            (local-set-key (kbd "RET") 'compile-goto-error)
            (local-set-key (kbd "<mouse-2>") 'compile-goto-error))))

      (pop-to-buffer buffer))))

(defun my/rg-format-results-v06 (remote-prefix)
  "Format remote rg results for compilation-mode navigation."
  (let ((inhibit-read-only t))
    (goto-char (point-min))
    ;; Find the start of actual results
    (when (re-search-forward "=== COMMAND OUTPUT ===\n" nil t)
      ;; Process each file section
      (while (re-search-forward "^\\([^:\n\r]+\\)$" nil t)
        (let ((potential-file (match-string 1)))
          ;; Skip lines that don't look like filenames
          (when (and
                 (not (string-match-p "^[[:space:]]*$" potential-file))
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
                                       (replace-regexp-in-string
                                        "^/ssh:[^:]+:" ""
                                        potential-file)
                                     potential-file))
                       (full-path
                        (cond
                         ;; Convert relative path to absolute TRAMP path
                         ((string-prefix-p "./" clean-file)
                          (let
                              ((local-abs-path
                                (file-remote-p default-directory
                                               'localname)))
                            (concat remote-prefix
                                    (expand-file-name clean-file
                                                      local-abs-path))))
                         ;; Already absolute path, add remote prefix
                         ((string-prefix-p "/" clean-file)
                          (concat remote-prefix clean-file))
                         ;; Relative file, make absolute
                         (t (let
                                ((local-abs-path
                                  (file-remote-p default-directory
                                                 'localname)))
                              (concat remote-prefix
                                      (expand-file-name clean-file
                                                        local-abs-path)))))))
                  ;; Replace with compilation-mode format
                  (replace-match
                   (format "%s:%s:%s:%s" full-path line col content) t
                   t))
                (forward-line))
              ;; Remove the file header line
              (goto-char file-start)
              (when (< file-start (point-max))
                (let
                    ((end-pos
                      (min (1+ (line-end-position)) (point-max))))
                  (delete-region file-start end-pos))))))))))

;; 3. Setup
;; ----------------------------------------

;; Global keybinding

(global-set-key (kbd "C-S-g") 'my/rg-search-v06)

;; Usage Instructions:
;;
;; 1. Local Search:
;;    - Press C-S-g and enter search term
;;    - Uses standard rg-project for comprehensive search
;;    - Standard rg-mode buffer with wgrep support
;;
;; 2. Remote Search (TRAMP):
;;    - In remote directory (/ssh:user@host:/path/)
;;    - Press C-S-g and enter search term
;;    - Executes ripgrep directly on remote host (fast!)
;;    - Results formatted with proper TRAMP paths
;;    - Navigate with RET, edit with 'w', save with C-c C-c
;;
;; Key improvements in v06:
;; - Simplified wgrep integration (no complex text properties)
;; - Working navigation and editing
;; - Based on proven v03 approach
;; - Clean, maintainable code

(when (not load-file-name)
  (message
   "02-base-230-wgrep-ripgrep-v06.el loaded - Working remote search with clean wgrep"))


(provide '02-base-230-wgrep-ripgrep-v06)

(when
    (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v06.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))