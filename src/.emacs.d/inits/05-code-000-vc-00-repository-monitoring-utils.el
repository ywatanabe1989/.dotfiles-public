;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2026-01-13 20:58:55>
;;; File: /home/ywatanabe/.emacs.d/inits/05-code-000-vc-00-repository-monitoring-utils.el

;;; Copyright (C) 2026 Yusuke Watanabe (ywatanabe@scitex.ai)

;;; 05-code-000-vc-repository-monitoring-utils.el --- Repo monitor utilities -*- lexical-binding: t -*-

;; Author: ywatanabe
;; Timestamp: 2026-01-13

;;; Commentary:
;; Utility functions for repository monitoring.

;;; Code:

(defun repo-monitor--load-gitignore-patterns (directory)
  "Load .gitignore patterns from DIRECTORY and parents."
  (let ((patterns nil) (dir directory))
    (while dir
      (let ((gitignore (expand-file-name ".gitignore" dir)))
        (when (file-exists-p gitignore)
          (with-temp-buffer
            (insert-file-contents gitignore)
            (goto-char (point-min))
            (while (not (eobp))
              (let ((line (string-trim (buffer-substring-no-properties
                                        (line-beginning-position)
					(line-end-position)))))
                (unless
		    (or (string-empty-p line)
			(string-prefix-p "#" line))
                  (push line patterns)))
              (forward-line 1)))))
      (setq dir (file-name-directory (directory-file-name dir)))
      (when (string= dir "/") (setq dir nil)))
    (nreverse patterns)))

(defun repo-monitor--gitignore-pattern-to-regex (pattern)
  "Convert gitignore PATTERN to Emacs regex."
  (let ((regex pattern))
    (setq regex (replace-regexp-in-string "\\." "\\\\." regex))
    (setq regex (replace-regexp-in-string "\\+" "\\\\+" regex))
    (setq regex (replace-regexp-in-string "\\$" "\\\\$" regex))
    (setq regex (replace-regexp-in-string "\\^" "\\\\^" regex))
    (setq regex
	  (replace-regexp-in-string "\\*\\*/" "\\\\(.*/\\\\)?" regex))
    (setq regex (replace-regexp-in-string "\\*" "[^/]*" regex))
    (setq regex (replace-regexp-in-string "\\?" "." regex))
    (when (string-suffix-p "/" pattern)
      (setq regex (concat regex ".*")))
    (if (string-prefix-p "/" pattern)
        (setq regex (concat "^" (substring regex 1)))
      (setq regex (concat "\\(^\\|/\\)" regex)))
    (concat regex "\\($\\|/\\)")))

(defun repo-monitor--get-recent-files
    (directory days &optional max-count)
  "Get files in DIRECTORY modified within DAYS, sorted by mtime descending.
MAX-COUNT limits the number of files returned (default 100).
Returns list of (FILE . STATUS) where STATUS is 'created, 'modified, or 'recent."
  (when (and (> days 0) (file-directory-p directory))
    (let* ((default-directory directory)
           (limit (or max-count 100))
           (is-git (file-exists-p (expand-file-name ".git" directory)))
           (files (split-string
                   (shell-command-to-string
                    (format "find . -type f -mtime -%d \
! -path '*/.git/*' ! -path '*/__pycache__/*' ! -path '*/.venv/*' \
! -path '*/node_modules/*' ! -path '*/.ruff_cache/*' ! -path '*/.mypy_cache/*' \
! -name '*.pyc' ! -name '*.log' ! -name '*.lock' \
-printf '%%T@ %%P\\n' 2>/dev/null | sort -rn | head -%d | cut -d' ' -f2-"
                            days limit))
                   "\n" t))
           (git-status (when is-git
                         (repo-monitor--parse-git-status directory))))
      (mapcar (lambda (f)
                (cons f (or (cdr (assoc f git-status)) 'recent)))
              files))))

(defun repo-monitor--parse-git-status (directory)
  "Parse git status in DIRECTORY.
Returns alist of (FILE . STATUS) where STATUS is 'created or 'modified."
  (let ((default-directory directory)
        (result nil))
    (dolist (line (split-string
                   (shell-command-to-string
                    "git status --porcelain 2>/dev/null")
                   "\n" t))
      (when (>= (length line) 3)
        (let* ((status-char (substring line 0 2))
               (file (string-trim (substring line 3)))
               (status (cond
                        ((string-match-p "^[?A]" status-char) 'created)
                        ((string-match-p "^.?[MRCUD]" status-char)
			 'modified)
                        (t nil))))
          (when status
            (push (cons file status) result)))))
    result))

;;; 05-code-000-vc-repository-monitoring-utils.el ends here

(provide '05-code-000-vc-00-repository-monitoring-utils)

(when
    (not load-file-name)
  (message "05-code-000-vc-00-repository-monitoring-utils.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))
