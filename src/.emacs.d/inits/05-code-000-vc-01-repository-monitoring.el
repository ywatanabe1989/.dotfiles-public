;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2026-01-15 17:44:17>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/05-code-000-vc-01-repository-monitoring.el

;;; Copyright (C) 2026 Yusuke Watanabe (ywatanabe@scitex.ai)

;;; 05-code-000-vc-repository-monitoring.el --- Repository file monitoring -*- lexical-binding: t -*-

;; Author: ywatanabe
;; Timestamp: 2026-01-13

;;; Commentary:
;; Real-time repository monitoring using inotifywait.
;; Shows file changes with color-coded status:
;;   - Green: created
;;   - Yellow: modified
;;   - Red: deleted

;;; Code:

(require '05-code-000-vc-00-repository-monitoring-utils)

(defgroup repo-monitor nil
  "Repository file monitoring."
  :group 'tools
  :prefix "repo-monitor-")

(defcustom repo-monitor-buffer-name "*Repo Monitor*"
  "Name of the repository monitor buffer."
  :type 'string
  :group 'repo-monitor)

(defcustom repo-monitor-debounce-seconds 0.5
  "Debounce interval in seconds."
  :type 'number
  :group 'repo-monitor)

(defcustom repo-monitor-max-lines 100
  "Maximum lines to keep in buffer."
  :type 'integer
  :group 'repo-monitor)

(defcustom repo-monitor-exclude-patterns
  '("\\.git" "\\.venv" "\\.env" "venv" "__pycache__" "node_modules"
    "build" "dist" "\\.tox" "\\.egg-info" "\\.cache" "\\.pytest_cache"
    "\\.ruff_cache" "\\.mypy_cache" "\\.coverage" "htmlcov"
    "\\.ipynb_checkpoints" "\\.sass-cache" "vendor" "target")
  "Directories to exclude from monitoring."
  :type '(repeat string)
  :group 'repo-monitor)

(defcustom repo-monitor-temp-file-patterns
  '("^\\.#" "^#.*#$" "~$" "\\.swp$" "\\.swo$" "\\.swn$"
    "\\.tmp\\.[0-9]+" "^\\.saves-" "\\.bak$" "\\.orig$" "^4913$"
    "\\.pyc$" "\\.pyo$" "\\.class$" "\\.o$" "\\.so$"
    "\\.sh\\.log$" "\\.log$" "\\.lock$")
  "Patterns for temporary files to ignore."
  :type '(repeat string)
  :group 'repo-monitor)

(defcustom repo-monitor-respect-gitignore t
  "If non-nil, filter files that match .gitignore patterns."
  :type 'boolean
  :group 'repo-monitor)

(defcustom repo-monitor-recent-days 7
  "Show files modified within this many days on startup (0 to disable)."
  :type 'integer
  :group 'repo-monitor)

;; Faces for different event types

(defface repo-monitor-created-face
  '((t :foreground "#50fa7b" :weight normal))
  "Face for created files."
  :group 'repo-monitor)

(defface repo-monitor-modified-face
  '((t :foreground "#f1fa8c" :weight normal))
  "Face for modified files."
  :group 'repo-monitor)

(defface repo-monitor-deleted-face
  '((t :foreground "#ff5555" :weight normal))
  "Face for deleted files."
  :group 'repo-monitor)

(defface repo-monitor-header-face
  '((t :foreground "#6272a4" :weight bold))
  "Face for header text."
  :group 'repo-monitor)

(defface repo-monitor-recent-face
  '((t :foreground "#8be9fd" :slant italic))
  "Face for recent (historical) files."
  :group 'repo-monitor)

;; Internal variables

(defvar repo-monitor--process nil "The inotifywait process.")

(defvar repo-monitor--directory nil "Currently monitored directory.")

(defvar repo-monitor--last-events (make-hash-table :test 'equal)
  "Debouncing hash.")

(defvar repo-monitor--header-end-marker nil
  "Marker for end of header.")

(defvar repo-monitor--gitignore-patterns nil
  "Cached gitignore patterns.")

(defvar repo-monitor--is-git-repo nil
  "Whether directory is a git repo.")

(defun repo-monitor--temp-file-p (filename)
  "Check if FILENAME is a temporary file."
  (let ((basename (file-name-nondirectory filename)))
    (cl-some (lambda (pattern)
               (string-match-p pattern basename))
             repo-monitor-temp-file-patterns)))

(defun repo-monitor--gitignored-p (relpath)
  "Check if RELPATH matches any gitignore pattern."
  (when (and repo-monitor-respect-gitignore
             repo-monitor--is-git-repo
             repo-monitor--gitignore-patterns)
    (cl-some (lambda (pattern)
               (let
		   ((regex
		     (repo-monitor--gitignore-pattern-to-regex
		      pattern)))
                 (string-match-p regex relpath)))
             repo-monitor--gitignore-patterns)))

(defun repo-monitor--build-exclude-regex ()
  "Build exclude regex for inotifywait."
  (concat "("
          (mapconcat (lambda (p) (concat "/\\." p "\\|/" p))
                     repo-monitor-exclude-patterns
                     "\\|")
          ")"))

(defun repo-monitor--get-face (event)
  "Get face for EVENT type."
  (cond
   ((string-match-p "CREATE" event) 'repo-monitor-created-face)
   ((string-match-p "MOVED_TO" event) 'repo-monitor-modified-face)
   ((string-match-p "MODIFY" event) 'repo-monitor-modified-face)
   ((string-match-p "DELETE" event) 'repo-monitor-deleted-face)
   (t 'default)))

(defun repo-monitor--should-show-p (event)
  "Check if EVENT should be displayed (filter MOVED_FROM)."
  (not (string-match-p "MOVED_FROM" event)))

(defun repo-monitor--debounce-p (filepath)
  "Check if FILEPATH event should be debounced."
  (let* ((now (float-time))
         (last-time (gethash filepath repo-monitor--last-events 0))
         (diff (- now last-time)))
    (if (< diff repo-monitor-debounce-seconds)
        t
      (puthash filepath now repo-monitor--last-events)
      nil)))

(defun repo-monitor--truncate-buffer ()
  "Truncate buffer to `repo-monitor-max-lines', removing oldest (bottom) entries."
  (when-let ((buf (get-buffer repo-monitor-buffer-name)))
    (with-current-buffer buf
      (let ((line-count (count-lines (point-min) (point-max))))
        (when (> line-count repo-monitor-max-lines)
          (let ((inhibit-read-only t)
                (excess (- line-count repo-monitor-max-lines)))
            ;; Delete from the bottom (oldest entries)
            (goto-char (point-max))
            (forward-line (- excess))
            (delete-region (point) (point-max))))))))

(defun repo-monitor--remove-duplicate (relpath)
  "Remove existing entry for RELPATH from buffer."
  (when (and repo-monitor--header-end-marker
             (marker-position repo-monitor--header-end-marker))
    (save-excursion
      (goto-char (marker-position repo-monitor--header-end-marker))
      (let ((inhibit-read-only t))
        (while (search-forward-regexp
                (concat "^" (regexp-quote relpath) "$") nil t)
          (delete-region (line-beginning-position)
                         (min (1+ (line-end-position)) (point-max))))))))

(defun repo-monitor--process-filter (proc output)
  "Process filter for inotifywait OUTPUT from PROC."
  (when (buffer-live-p (process-buffer proc))
    (dolist (line (split-string output "\n" t))
      (when (string-match "^\\(.+\\) \\([A-Z_,]+\\) " line)
        (let* ((filepath (match-string 1 line))
               (event (match-string 2 line))
               (relpath (if repo-monitor--directory
                            (file-relative-name filepath
						repo-monitor--directory)
                          filepath)))
          ;; Filter temp files, gitignored, MOVED_FROM, and debounce
          (unless (or (repo-monitor--temp-file-p filepath)
                      (repo-monitor--gitignored-p relpath)
                      (not (repo-monitor--should-show-p event))
                      (repo-monitor--debounce-p relpath))
            (let ((face (repo-monitor--get-face event)))
              (with-current-buffer (process-buffer proc)
                (let ((inhibit-read-only t))
                  ;; Remove duplicate if exists
                  (repo-monitor--remove-duplicate relpath)
                  ;; Insert at top (after header)
                  (if (and repo-monitor--header-end-marker
                           (marker-position
			    repo-monitor--header-end-marker))
                      (goto-char
		       (marker-position
			repo-monitor--header-end-marker))
                    (goto-char (point-max)))
                  (insert (propertize relpath 'face face) "\n")
                  (repo-monitor--truncate-buffer))))))))))

(defface repo-monitor-key-face
  '((t :foreground "#bd93f9" :weight bold))
  "Face for keybinding hints."
  :group 'repo-monitor)

(defface repo-monitor-dim-face
  '((t :foreground "#6272a4"))
  "Face for dimmed text."
  :group 'repo-monitor)

(defun repo-monitor--insert-header (directory)
  "Insert header for DIRECTORY monitoring."
  (let ((inhibit-read-only t))
    (erase-buffer)
    (insert (propertize (format "Monitoring %s\n" directory)
                        'face 'repo-monitor-header-face))
    (insert "Colors: "
	    (propertize "■ created" 'face
			'repo-monitor-created-face)
	    "  "
            (propertize "■ modified" 'face 'repo-monitor-modified-face)
	    "  "
            (propertize "■ deleted" 'face 'repo-monitor-deleted-face)
	    "\n")
    (let ((keys '(("RET" . "open") ("o" . "other") ("v" . "view")
		  ("=" . "diff")
                  ("P" . "switch") ("g" . "revert") ("i" . "info")
		  ("q" . "quit"))))
      (insert (propertize "Keys: " 'face 'repo-monitor-dim-face))
      (dolist (k keys)
        (insert (propertize (car k) 'face 'repo-monitor-key-face)
                (propertize (concat ":" (cdr k) " ") 'face
			    'repo-monitor-dim-face)))
      (insert "\n\n"))
    ;; Set marker and insert recent files
    (setq repo-monitor--header-end-marker (point-marker))
    (dolist
        (entry
         (repo-monitor--get-recent-files directory
                                         repo-monitor-recent-days
                                         repo-monitor-max-lines))
      (let* ((file (car entry))
             (status (cdr entry))
             (face (pcase status
                     ('created 'repo-monitor-created-face)
                     ('modified 'repo-monitor-modified-face)
                     ('deleted 'repo-monitor-deleted-face)
                     (_ 'repo-monitor-recent-face))))
        (insert (propertize file 'face face) "\n")))))

;;;###autoload

(defun repo-monitor-start (&optional directory in-current-window)
  "Start monitoring DIRECTORY (default: current project root or default-directory).
If IN-CURRENT-WINDOW is non-nil, display in current window."
  (interactive
   (list (read-directory-name "Monitor directory: "
                              (or (vc-root-dir) default-directory))))
  (repo-monitor-stop)
  (unless (executable-find "inotifywait")
    (error
     "inotifywait not found. Install with: sudo apt install inotify-tools"))
  (let*
      ((dir
	(expand-file-name
	 (or directory (vc-root-dir) default-directory)))
       (buf (get-buffer-create repo-monitor-buffer-name))
       (exclude-regex (repo-monitor--build-exclude-regex)))
    (setq repo-monitor--directory dir)
    (setq repo-monitor--is-git-repo
          (file-exists-p (expand-file-name ".git" dir)))
    (setq repo-monitor--gitignore-patterns
          (when repo-monitor--is-git-repo
            (repo-monitor--load-gitignore-patterns dir)))
    (clrhash repo-monitor--last-events)
    (with-current-buffer buf
      (repo-monitor-mode)
      (repo-monitor--insert-header dir))
    (setq repo-monitor--process
          (start-process "repo-monitor" buf
                         "inotifywait" "-m" "-r" "-q"
                         "--exclude" exclude-regex
                         "-e" "modify,create,delete,move"
                         "--format" "%w%f %e %T"
                         "--timefmt" "%H:%M:%S"
                         dir))
    (set-process-filter repo-monitor--process
			#'repo-monitor--process-filter)
    (set-process-query-on-exit-flag repo-monitor--process nil)
    (if in-current-window
        (switch-to-buffer buf)
      (display-buffer buf))
    (message "Monitoring %s" dir)))

;;;###autoload

(defun repo-monitor-stop ()
  "Stop repository monitoring."
  (interactive)
  (when
      (and repo-monitor--process
	   (process-live-p repo-monitor--process))
    (delete-process repo-monitor--process)
    (setq repo-monitor--process nil)
    (message "Repository monitoring stopped")))

;;;###autoload

(defun repo-monitor-toggle ()
  "Toggle repository monitoring."
  (interactive)
  (if
      (and repo-monitor--process
	   (process-live-p repo-monitor--process))
      (repo-monitor-stop)
    (repo-monitor-start)))

(defun repo-monitor-revert ()
  "Reload/refresh the monitor buffer with current state."
  (interactive)
  (when-let ((buf (get-buffer repo-monitor-buffer-name)))
    (with-current-buffer buf
      (repo-monitor--insert-header repo-monitor--directory)
      ;; Move to first file line (after header)
      (goto-char (point-min))
      (forward-line 4))))

(defalias 'repo-monitor-clear 'repo-monitor-revert)

(defun repo-monitor-info ()
  "Show current monitoring configuration in minibuffer."
  (interactive)
  (message
   "Dir: %s | Git: %s | Gitignore: %s (%d patterns) | Debounce: %.1fs"
   (or repo-monitor--directory "none")
   (if repo-monitor--is-git-repo "yes" "no")
   (if repo-monitor-respect-gitignore "on" "off")
   (length (or repo-monitor--gitignore-patterns nil))
   repo-monitor-debounce-seconds))

(defun repo-monitor--get-file-at-point ()
  "Get the file path at current line, or nil if on header."
  (let ((file (string-trim (thing-at-point 'line t))))
    (when (and repo-monitor--directory
               (not (string-empty-p file))
               (not
		(string-match-p
		 "^Monitoring\\|^Colors:\\|^Keys:" file)))
      (expand-file-name file repo-monitor--directory))))

(defun repo-monitor-find-file ()
  "Open file at point in current window (like dired)."
  (interactive)
  (when-let ((file (repo-monitor--get-file-at-point)))
    (find-file file)))

(defun repo-monitor-find-file-other-window ()
  "Open file at point in other window."
  (interactive)
  (when-let ((file (repo-monitor--get-file-at-point)))
    (find-file-other-window file)))

(defun repo-monitor-view-file ()
  "View file at point in view-mode."
  (interactive)
  (when-let ((file (repo-monitor--get-file-at-point)))
    (view-file file)))

(defun repo-monitor-diff-file ()
  "Show git diff for file at point."
  (interactive)
  (when-let ((file (repo-monitor--get-file-at-point)))
    (if (and repo-monitor--directory
             (file-exists-p
	      (expand-file-name ".git" repo-monitor--directory)))
        (let ((default-directory repo-monitor--directory)
              (relpath
	       (file-relative-name file repo-monitor--directory)))
          (if (fboundp 'magit-diff-buffer-file)
              (with-current-buffer (find-file-noselect file)
                (magit-diff-buffer-file))
            (vc-diff nil nil (list file))))
      (message "Not in a git repository"))))

(defvar repo-monitor-mode-map nil
  "Keymap for `repo-monitor-mode'.")

(setq repo-monitor-mode-map
      (let ((map (make-sparse-keymap)))
        (define-key map (kbd "RET") #'repo-monitor-find-file)
        (define-key map (kbd "o")
		    #'repo-monitor-find-file-other-window)
        (define-key map (kbd "v") #'repo-monitor-view-file)
        (define-key map (kbd "=") #'repo-monitor-diff-file)
        (define-key map (kbd "g") #'repo-monitor-revert)
        (define-key map (kbd "i") #'repo-monitor-info)
        (define-key map (kbd "s") #'repo-monitor-stop)
        (define-key map (kbd "q") #'quit-window)
        (define-key map (kbd "n") #'next-line)
        (define-key map (kbd "p") #'previous-line)
        map))

(define-derived-mode repo-monitor-mode special-mode
  "RepoMon"
  "Major mode for repository monitoring buffer."
  (setq-local truncate-lines t)
  (setq-local buffer-read-only t))

;;; Dired integration

(defun repo-monitor--get-project-root (&optional dir)
  "Get project root for DIR, or current directory if git-managed."
  (let* ((directory (expand-file-name (or dir default-directory)))
         (git-root (locate-dominating-file directory ".git")))
    (or git-root directory)))

;;;###autoload

(defun repo-monitor-dired ()
  "Start monitoring from dired in current window.
Uses project root if git-managed, else dired directory."
  (interactive)
  (let ((dir (if (derived-mode-p 'dired-mode)
                 (repo-monitor--get-project-root
		  (dired-current-directory))
               (repo-monitor--get-project-root))))
    (repo-monitor-start dir t)))

;;;###autoload

(defun repo-monitor-here ()
  "Start monitoring current directory in current window (no project root detection)."
  (interactive)
  (let ((dir (if (derived-mode-p 'dired-mode)
                 (dired-current-directory)
               default-directory)))
    (repo-monitor-start dir t)))

;;;###autoload

(defun repo-monitor-switch-directory ()
  "Switch monitoring to a different directory (find-file style navigation)."
  (interactive)
  (let* ((start-dir (or repo-monitor--directory default-directory))
         (dir (read-directory-name "Monitor directory: " start-dir)))
    (repo-monitor-start (repo-monitor--get-project-root dir) t)))

;; Add keybinding to dired
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "C-c m") #'repo-monitor-dired)
  (define-key dired-mode-map (kbd "C-c M") #'repo-monitor-here))

;; Force bind if dired already loaded
(when (boundp 'dired-mode-map)
  (define-key dired-mode-map (kbd "C-c m") #'repo-monitor-dired)
  (define-key dired-mode-map (kbd "C-c M") #'repo-monitor-here))

;; Add extra keybindings in repo-monitor buffer

(define-key repo-monitor-mode-map (kbd "P")
	    #'repo-monitor-switch-directory)

(define-key repo-monitor-mode-map (kbd "d") #'repo-monitor-dired)

;;; 05-code-000-vc-repository-monitoring.el ends here

(provide '05-code-000-vc-01-repository-monitoring)

(when
    (not load-file-name)
  (message "05-code-000-vc-01-repository-monitoring.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))
