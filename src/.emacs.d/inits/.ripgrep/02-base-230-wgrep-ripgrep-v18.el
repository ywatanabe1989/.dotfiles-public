;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 10:46:16>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v18.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)


;;; Version: 18 - FIXED directory detection for TRAMP

;; VERSION 18: FIXED directory detection issue
;; - V17 was detecting TRAMP directories as local
;; - Fixed: Now properly detects /ssh:host:path as remote
;; - Uses default-directory directly if path helpers return local-looking paths
;; - Based on working v03 remote search logic

;; ISSUE IN V17:
;; Current directory: /ssh:sp:~/proj/...
;; Search directory: ~/proj/... (missing TRAMP prefix!)
;; Result: Used local search instead of remote

;; Navigation: OK
;; Editable: OK (withtout w)
;; C-c C-c: NG
;; C-x C-s: NG

;; Killed
;; Quit
;; Open ~/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v18.el
;; Mark saved where search started [2 times]
;; Omitting...
;; (Nothing to omit)
;; Omitting...
;; Omitted 2 lines in /ssh:sp:~/proj/neurovista/scripts/pac/calc_pac_around_seizures/
;; Omitting...
;; Omitted 2 lines in /ssh:sp:~/proj/neurovista/scripts/pac/calc_pac_around_seizures/
;; Mark saved where search started
;; V18: === V18 SEARCH STARTING ===
;; V18: Query: load
;; V18: Current directory: /ssh:sp:~/proj/neurovista/scripts/pac/calc_pac_around_seizures/
;; V18: Major mode: dired-mode
;; V18: my/path-get-path returned: ~/proj/neurovista/scripts/pac/calc_pac_around_seizures/
;; V18: TRAMP detection override: using default-directory
;; V18: Final search directory: /ssh:sp:~/proj/neurovista/scripts/pac/calc_pac_around_seizures/
;; V18: Is remote: /ssh:sp:
;; V18: === USING V18 REMOTE SEARCH ===
;; V18: === REMOTE SEARCH FUNCTION ===
;; V18: Query: load
;; V18: Directory: /ssh:sp:~/proj/neurovista/scripts/pac/calc_pac_around_seizures/
;; V18: Remote prefix: /ssh:sp:
;; V18: Local path: /home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/
;; V18: Executing remote command...
;; V18: Command: ~/.local/bin/rg --line-number --column --heading --no-config --max-count=500 --glob=!**/*undo-tree* --glob=!**/.old/** --glob=!**/*.log --glob=!**/RUNNING/** --glob=!**/FINISHED_SUCCESS/** --glob=!**/FINISHED/** load .
;; V18: Result length: 1851 chars
;; V18: First 100 chars: ./calc_eta.py
;; 42:15:pprint(stx.io.load("./config/PAC.yaml"))

;; ./submit.sh
;; 93:13:    spartan_load_mod
;; V18: Formatting results...
;; V18: File #1: ./calc_eta.py
;; V18:   ./calc_eta.py -> /home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/calc_eta.py -> /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/calc_eta.py
;; V18: File #2: ./submit.sh
;; V18:   ./submit.sh -> /home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/submit.sh -> /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/submit.sh
;; V18: File #3: ./README.md
;; V18:   ./README.md -> /home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/README.md -> /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/README.md [4 times]
;; V18: File #4: ./main.sh
;; V18:   ./main.sh -> /home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/main.sh -> /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/main.sh
;; V18: File #5: ./load_pac_and_save_as_pkl.py
;; V18:   ./load_pac_and_save_as_pkl.py -> /home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/load_pac_and_save_as_pkl.py -> /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/load_pac_and_save_as_pkl.py [4 times]
;; V18: File #6: ./check_coverage.py
;; V18:   ./check_coverage.py -> /home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/check_coverage.py -> /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/check_coverage.py [3 times]
;; V18: File #7: ./main.py
;; V18:   ./main.py -> /home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/main.py -> /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/main.py [5 times]
;; V18: File #8: ./maintenance/diagnose_duplication.py
;; V18:   ./maintenance/diagnose_duplication.py -> /home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/maintenance/diagnose_duplication.py -> /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/maintenance/diagnose_duplication.py
;; V18: File #9: ./maintenance/calc_pac_around_seizures_maintain_dbs.py
;; V18:   ./maintenance/calc_pac_around_seizures_maintain_dbs.py -> /home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/maintenance/calc_pac_around_seizures_maintain_dbs.py -> /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/maintenance/calc_pac_around_seizures_maintain_dbs.py [8 times]
;; Cleaned up 0 dead buffer entries
;; Mark set
;; Can’t guess python-indent-offset, using defaults: 4
;; Current locus from *rg-v18*
;; Mark saved where search started
;; Mark set [3 times]
;; Replaced 6 occurrences
;; (No changes to be performed)
;; C-x C-a is undefined
;; Press C-x C-s when finished or C-c C-k to abort changes.
;; (No changes to be performed)
;; C-x C-a is undefined
;; C-c C-s is undefined
;; (No changes to be performed)
;; Press C-x C-s when finished or C-c C-k to abort changes.
;; (No changes to be performed)
;; Cleaned up 0 dead buffer entries
;; command-execute: Buffer is read-only: #<buffer *Messages*>

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

(defvar my/rg-debug-message t)

(defun my/rg-debug-message (format-string &rest args)
  (when my/rg-debug-message
    (apply 'message (concat "V18: " format-string) args)))

;; 2. Core Functions with FIXED directory detection
;; ----------------------------------------

(defun my/rg-search (query)
  "V18: FIXED directory detection for TRAMP paths."
  (interactive "sV18 Search: ")
  (my/rg-debug-message "=== V18 SEARCH STARTING ===")
  (my/rg-debug-message "Query: %s" query)
  (my/rg-debug-message "Current directory: %s" default-directory)
  (my/rg-debug-message "Major mode: %s" major-mode)

  ;; FIXED: Smarter directory detection
  (let* ((candidate-directory
          (cond
           ((and (eq major-mode 'dired-mode)
                 (fboundp 'my/path-get-path))
            (let ((dir (my/path-get-path)))
              (my/rg-debug-message "my/path-get-path returned: %s" dir)
              dir))
           ((eq major-mode 'dired-mode)
            (let ((dir (dired-current-directory)))
              (my/rg-debug-message
               "dired-current-directory returned: %s" dir)
              dir))
           (t
            (my/rg-debug-message "Using default-directory")
            default-directory)))
         ;; FIXED: If candidate looks local but we're in TRAMP, use default-directory
         (search-directory
          (if (and (file-remote-p default-directory)  ; We're in TRAMP
                   (not (file-remote-p candidate-directory)))
                                        ; But candidate is local
              (progn
                (my/rg-debug-message
                 "TRAMP detection override: using default-directory")
                default-directory)
            candidate-directory)))

    (my/rg-debug-message "Final search directory: %s" search-directory)
    (my/rg-debug-message "Is remote: %s"
                         (file-remote-p search-directory))

    ;; Route to remote or local search
    (if (file-remote-p search-directory)
        (let ((default-directory search-directory))
          (my/rg-debug-message "=== USING V18 REMOTE SEARCH ===")
          (my/rg-search-remote-v18 query))
      ;; For local: use standard rg.el
      (let ((default-directory search-directory))
        (my/rg-debug-message "=== USING STANDARD RG FOR LOCAL ===")
        (rg-project query "*")))))

(defun my/rg-search-remote-v18 (query)
  "V18: Remote search based on working v03, with FIXED path construction."
  (my/rg-debug-message "=== REMOTE SEARCH FUNCTION ===")
  (my/rg-debug-message "Query: %s" query)
  (my/rg-debug-message "Directory: %s" default-directory)

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
         (buffer-name "*rg-v18*"))

    (my/rg-debug-message "Remote prefix: %s" remote-prefix)
    (my/rg-debug-message "Local path: %s" local-path)

    (let ((buffer (get-buffer-create buffer-name)))
      (with-current-buffer buffer
        (setq-local default-directory default-directory)
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert
           (format "-*- mode: rg; default-directory: \"%s\" -*-\n"
                   default-directory))
          (insert
           (format "V18 Remote Search - %s\n\n" (current-time-string)))
          (insert (format "Query: %s\n" query))
          (insert (format "Directory: %s\n" default-directory))
          (insert (format "Remote prefix: %s\n" remote-prefix))
          (insert (format "Local path: %s\n\n" local-path)))

        ;; Use compilation-mode for navigation
        (compilation-mode)
        (setq-local compilation-search-path (list default-directory)))

      ;; Execute remote search (from working v03)
      (my/rg-debug-message "Executing remote command...")
      (let*
          ((cmd
            (format "~/.local/bin/rg %s %s ." flags
                    (shell-quote-argument query)))
           (result (shell-command-to-string cmd)))

        (my/rg-debug-message "Command: %s" cmd)
        (my/rg-debug-message "Result length: %d chars" (length result))
        (my/rg-debug-message "First 100 chars: %s"
                             (substring result 0
                                        (min 100 (length result))))

        (with-current-buffer buffer
          (let ((inhibit-read-only t))
            (goto-char (point-max))
            (insert "\n=== V18 REMOTE RESULTS ===\n")
            (insert result)
            (insert "\n=== END RESULTS ===\n")

            ;; Format results with FIXED path construction
            (my/rg-format-results-v18 remote-prefix local-path)

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

(defun my/rg-format-results-v18 (remote-prefix local-path)
  "V18: Format results with clean path construction."
  (my/rg-debug-message "Formatting results...")

  (let ((inhibit-read-only t)
        (file-count 0))
    (goto-char (point-min))
    (when (re-search-forward "=== V18 REMOTE RESULTS ===\n" nil t)
      (while (re-search-forward "^\\([^:\n\r]+\\)$" nil t)
        (let ((raw-file (match-string 1)))
          (when (and (not (string-match-p "^[[:space:]]*$" raw-file))
                     (not (string-match-p "^[0-9]+:" raw-file))
                     (not (string-match-p "^=+" raw-file))
                     (string-match-p "^\\." raw-file))

            (setq file-count (1+ file-count))
            (my/rg-debug-message "File #%d: %s" file-count raw-file)

            (let ((file-start (match-beginning 0)))
              (forward-line)
              (while (and (not (eobp))
                          (looking-at
                           "^\\([0-9]+\\):\\([0-9]+\\):\\(.+\\)$"))
                (let* ((line (match-string 1))
                       (col (match-string 2))
                       (content (match-string 3))
                       ;; Clean path construction
                       (abs-path
                        (expand-file-name raw-file local-path))
                       (final-path (concat remote-prefix abs-path)))

                  (my/rg-debug-message "  %s -> %s -> %s" raw-file
                                       abs-path final-path)

                  ;; Replace with compilation format
                  (replace-match
                   (format "%s:%s:%s:%s" final-path line col content)
                   t t))
                (forward-line))

              ;; Remove file header
              (goto-char file-start)
              (when (< file-start (point-max))
                (delete-region file-start (1+ (line-end-position)))))))))))

;; 3. Setup
;; ----------------------------------------

(global-set-key (kbd "C-S-g") 'my/rg-search)

(message "=== V18 LOADED - FIXED TRAMP directory detection ===")
(message "V18: Now properly routes TRAMP directories to remote search")
(message "V18: Should show 'USING V18 REMOTE SEARCH' for TRAMP paths")

;; Test the current directory detection
(my/rg-debug-message "Current setup:")
(my/rg-debug-message "  default-directory: %s" default-directory)
(my/rg-debug-message "  is remote: %s"
                     (file-remote-p default-directory))
(my/rg-debug-message "  major-mode: %s" major-mode)

(when (not load-file-name)
  (message
   "02-base-230-wgrep-ripgrep-v18.el loaded - FIXED TRAMP detection"))


(provide '02-base-230-wgrep-ripgrep-v18)

(when
    (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v18.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))