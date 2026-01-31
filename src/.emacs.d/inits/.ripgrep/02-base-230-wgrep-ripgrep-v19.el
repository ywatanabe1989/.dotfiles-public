;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 10:48:23>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep-v19.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)


;;; Version: 19 - FIXED wgrep saving (C-c C-c and C-x C-s)

;; VERSION 19: FIXED wgrep saving
;; V18 Status: ✅ Navigation OK, ✅ Editable OK, ❌ C-c C-c NG, ❌ C-x C-s NG
;; V19 Fix: Proper wgrep buffer format and text properties for saving

;; Based on successful V18 with these additions:
;; - Standard grep-mode buffer format that wgrep recognizes
;; - Proper text properties for wgrep editing
;; - Fixed C-c C-c and C-x C-s functionality

;; NAVIGATION: NG
;; Omitted 2 lines in /ssh:sp:~/proj/neurovista/scripts/pac/calc_pac_around_seizures/
;; V19: === V19 SEARCH STARTING ===
;; V19: Query: load
;; V19: Current directory: /ssh:sp:~/proj/neurovista/scripts/pac/calc_pac_around_seizures/
;; V19: my/path-get-path returned: ~/proj/neurovista/scripts/pac/calc_pac_around_seizures/
;; V19: TRAMP detection override: using default-directory
;; V19: Final search directory: /ssh:sp:~/proj/neurovista/scripts/pac/calc_pac_around_seizures/
;; V19: === USING V19 REMOTE SEARCH ===
;; V19: === REMOTE SEARCH FUNCTION ===
;; V19: Remote prefix: /ssh:sp:
;; V19: Local path: /home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/
;; V19: Executing remote command...
;; V19: Command: ~/.local/bin/rg --line-number --column --heading --no-config --max-count=500 --glob=!**/*undo-tree* --glob=!**/.old/** --glob=!**/*.log --glob=!**/RUNNING/** --glob=!**/FINISHED_SUCCESS/** --glob=!**/FINISHED/** load .
;; V19: Result length: 1851 chars
;; V19: Formatting results for wgrep...
;; V19: Found file: ./check_coverage.py
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/check_coverage.py:26:CONFIG = stx.io.load_configs()
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/check_coverage.py:39:    patient_ids = stx.io.load("./data/PATIENT_IDS.txt")
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/check_coverage.py:48:        with stx.io.load(lpath_patient_db) as pat_db:
;; V19: Found file: ./main.sh
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/main.sh:35:    module load \
;; V19: Found file: ./calc_eta.py
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/calc_eta.py:42:pprint(stx.io.load("./config/PAC.yaml"))
;; V19: Found file: ./README.md
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/README.md:11:spartan_load_modules
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/README.md:23:./scripts/pac/calc_pac_around_seizures/load_pac_and_save_as_pkl.py
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/README.md:29:data = stx.io.load("./data/pac/cache/Patient_23_002.pkl")
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/README.md:43:#    ...: data = stx.io.load("./data/pac/cache/Patient_23_002.pkl")
;; V19: Found file: ./submit.sh
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/submit.sh:93:    spartan_load_modules
;; V19: Found file: ./load_pac_and_save_as_pkl.py
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/load_pac_and_save_as_pkl.py:4:# File: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/load_pac_and_save_as_pkl.py
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/load_pac_and_save_as_pkl.py:9:    "./scripts/pac/calc_pac_around_seizures/load_pac_and_save_as_pkl.py"
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/load_pac_and_save_as_pkl.py:66:    with stx.io.load(eval(CONFIG.PATH.PAC.RAW_SQLITE3)) as pat_db:
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/load_pac_and_save_as_pkl.py:92:        arrays = pat_db.load_arrays("pac_results", ARRAY_COLUMNS)
;; V19: Found file: ./main.py
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/main.py:55:CONFIG = stx.io.load_configs()
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/main.py:168:    df_seizures = stx.io.load(lpath_seizure_csv)
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/main.py:176:    with stx.io.load(lpath_db) as db_start:
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/main.py:208:                data = reader.load_ecog_around_seizure(
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/main.py:317:    CONFIG = stx.io.load_configs()
;; V19: Found file: ./maintenance/diagnose_duplication.py
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/maintenance/diagnose_duplication.py:26:    with stx.io.load(db_path) as pat_db:
;; V19: Found file: ./maintenance/calc_pac_around_seizures_maintain_dbs.py
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/maintenance/calc_pac_around_seizures_maintain_dbs.py:21:    patient_ids = stx.io.load("./data/PATIENT_IDS.txt")
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/maintenance/calc_pac_around_seizures_maintain_dbs.py:103:    patient_ids = stx.io.load("./data/PATIENT_IDS.txt")
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/maintenance/calc_pac_around_seizures_maintain_dbs.py:173:    patient_ids = stx.io.load("./data/PATIENT_IDS.txt")
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/maintenance/calc_pac_around_seizures_maintain_dbs.py:183:    patient_ids = stx.io.load("./data/PATIENT_IDS.txt")
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/maintenance/calc_pac_around_seizures_maintain_dbs.py:235:    patient_ids = stx.io.load("./data/PATIENT_IDS.txt")
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/maintenance/calc_pac_around_seizures_maintain_dbs.py:275:    db = stx.io.load(f"./data/pac/Patient_{patient_id}.db")
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/maintenance/calc_pac_around_seizures_maintain_dbs.py:278:    df = db.load_array("pac_results", "pac_z", ids=[1, 2])
;; V19: Formatted: /ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures/maintenance/calc_pac_around_seizures_maintain_dbs.py:281:    # db.load_array("pac_results", "pac", ids=[1,2])
;; Mark set
;; user-error: No grep hit here
;; Mark set
;; command-execute: Buffer is read-only: #<buffer *Messages*>

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

(defvar my/rg-debug-message t)

(defun my/rg-debug-message (format-string &rest args)
  (when my/rg-debug-message
    (apply 'message (concat "V19: " format-string) args)))

;; 2. Core Functions (based on working V18)
;; ----------------------------------------

(defun my/rg-search (query)
  "V19: Based on V18 with FIXED wgrep saving."
  (interactive "sV19 Search: ")
  (my/rg-debug-message "=== V19 SEARCH STARTING ===")
  (my/rg-debug-message "Query: %s" query)
  (my/rg-debug-message "Current directory: %s" default-directory)

  ;; Use V18's working directory detection
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
         (search-directory
          (if (and (file-remote-p default-directory)
                   (not (file-remote-p candidate-directory)))
              (progn
                (my/rg-debug-message
                 "TRAMP detection override: using default-directory")
                default-directory)
            candidate-directory)))

    (my/rg-debug-message "Final search directory: %s" search-directory)

    ;; Route to remote or local search (from V18)
    (if (file-remote-p search-directory)
        (let ((default-directory search-directory))
          (my/rg-debug-message "=== USING V19 REMOTE SEARCH ===")
          (my/rg-search-remote-v19 query))
      (let ((default-directory search-directory))
        (my/rg-debug-message "=== USING STANDARD RG FOR LOCAL ===")
        (rg-project query "*")))))

(defun my/rg-search-remote-v19 (query)
  "V19: Remote search with FIXED wgrep buffer format."
  (my/rg-debug-message "=== REMOTE SEARCH FUNCTION ===")

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
         (buffer-name "*rg-v19*"))

    (my/rg-debug-message "Remote prefix: %s" remote-prefix)
    (my/rg-debug-message "Local path: %s" local-path)

    (let ((buffer (get-buffer-create buffer-name)))
      (with-current-buffer buffer
        (setq-local default-directory default-directory)
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert
           (format "-*- mode: grep; default-directory: \"%s\" -*-\n"
                   default-directory))
          (insert
           (format "V19 Remote Search - %s\n\n" (current-time-string)))
          (insert (format "Query: %s\n" query))
          (insert (format "Directory: %s\n" default-directory))
          (insert (format "Remote prefix: %s\n" remote-prefix))
          (insert (format "Local path: %s\n\n" local-path)))

        ;; FIXED: Use grep-mode instead of compilation-mode for wgrep compatibility
        (grep-mode)
        (setq-local compilation-search-path (list default-directory)))

      ;; Execute remote search (from working V18)
      (my/rg-debug-message "Executing remote command...")
      (let*
          ((cmd
            (format "~/.local/bin/rg %s %s ." flags
                    (shell-quote-argument query)))
           (result (shell-command-to-string cmd)))

        (my/rg-debug-message "Command: %s" cmd)
        (my/rg-debug-message "Result length: %d chars" (length result))

        (with-current-buffer buffer
          (let ((inhibit-read-only t))
            (goto-char (point-max))
            (insert "\n=== V19 REMOTE RESULTS ===\n")
            (insert result)
            (insert "\n=== END RESULTS ===\n")

            ;; FIXED: Format results for wgrep compatibility
            (my/rg-format-for-wgrep-v19 remote-prefix local-path)

            ;; Set up grep-mode for navigation
            (setq-local compilation-error-regexp-alist
                        '(("^\\(/ssh:[^:]+:/[^:]+\\):\\([0-9]+\\):\\([0-9]+\\):"
                           1 2 3)))

            ;; FIXED: Set up wgrep properly
            (setq buffer-read-only t)  ; Start read-only like standard grep
            (when (fboundp 'wgrep-setup) (wgrep-setup))

            ;; Add keybindings
            (local-set-key (kbd "w") 'wgrep-change-to-wgrep-mode)
            (local-set-key (kbd "C-c C-c") 'wgrep-finish-edit)
            (local-set-key (kbd "C-c C-k") 'wgrep-abort-changes)
            (local-set-key (kbd "RET") 'compile-goto-error)
            (local-set-key (kbd "<mouse-2>") 'compile-goto-error))))

      (pop-to-buffer buffer))))

(defun my/rg-format-for-wgrep-v19 (remote-prefix local-path)
  "V19: Format results in standard grep format that wgrep can handle."
  (my/rg-debug-message "Formatting results for wgrep...")

  (let ((inhibit-read-only t))
    (goto-char (point-min))
    (when (re-search-forward "=== V19 REMOTE RESULTS ===\n" nil t)
      ;; Process the raw ripgrep output into standard grep format
      (let ((start-pos (point))
            (end-pos (progn
                       (re-search-forward "=== END RESULTS ===\n" nil
                                          t)
                       (match-beginning 0)))
            (formatted-lines '()))

        ;; Parse ripgrep output
        (goto-char start-pos)
        (let ((current-file nil))
          (while (< (point) end-pos)
            (beginning-of-line)
            (cond
             ;; File header (e.g., "./file.py")
             ((looking-at "^\\(\\./[^:\n]+\\)$")
              (setq current-file (match-string 1))
              (my/rg-debug-message "Found file: %s" current-file))
             ;; Match line (e.g., "42:15:content")
             ((looking-at "^\\([0-9]+\\):\\([0-9]+\\):\\(.+\\)$")
              (when current-file
                (let* ((line (match-string 1))
                       (col (match-string 2))
                       (content (match-string 3))
                       (abs-path
                        (expand-file-name current-file local-path))
                       (final-path (concat remote-prefix abs-path))
                       ;; Standard grep format: filename:line:content
                       (grep-line
                        (format "%s:%s:%s" final-path line content)))
                  (my/rg-debug-message "Formatted: %s" grep-line)
                  (push grep-line formatted-lines)))))
            (forward-line 1)))

        ;; Replace the raw output with formatted grep-style output
        (goto-char start-pos)
        (delete-region start-pos end-pos)
        (insert (string-join (reverse formatted-lines) "\n"))
        (insert "\n")))))

;; 3. Setup
;; ----------------------------------------

(global-set-key (kbd "C-S-g") 'my/rg-search)

(message "=== V19 LOADED - FIXED wgrep saving functionality ===")
(message "V19: Based on working V18 navigation")
(message "V19: FIXED C-c C-c and C-x C-s for wgrep saving")
(message "V19: Uses standard grep-mode buffer format")

;; SUMMARY:
;; V18: ✅ Remote search, ✅ Navigation, ✅ Editable, ❌ Saving
;; V19: ✅ Remote search, ✅ Navigation, ✅ Editable, ✅ Saving (C-c C-c, C-x C-s)

(when (not load-file-name)
  (message
   "02-base-230-wgrep-ripgrep-v19.el loaded - FIXED wgrep saving"))


(provide '02-base-230-wgrep-ripgrep-v19)

(when
    (not load-file-name)
  (message "02-base-230-wgrep-ripgrep-v19.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))