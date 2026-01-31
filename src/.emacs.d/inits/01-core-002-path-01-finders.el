;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:32>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-002-path-01-finders.el

(defun --my/path-find-readme-path-local (&optional dir)
  "Find README.org or README.md in DIR (defaults to current directory), preferring .org."
  (let* ((dir (or dir default-directory))
         (org-path (concat dir "/README.org"))
         (org-path-dev (concat dir "/.README.org"))
         (md-path (concat dir "/README.md"))
         (md-path-dev (concat dir "/.README.md")))
    (cond
     ((file-exists-p org-path-dev) org-path-dev)
     ((file-exists-p md-path-dev) md-path-dev)
     ((file-exists-p org-path) org-path)
     ((file-exists-p md-path) md-path)
     (t md-path))))

(defun --my/path-find-readme-path-remote (path host)
  "Find README.org or README.md in remote PATH on HOST, preferring .org."
  (let* ((dir (file-name-directory path))
         (org-path (format "/ssh:%s:%s/README.org" host dir))
         (md-path (format "/ssh:%s:%s/README.md" host dir)))
    (cond ((file-exists-p org-path) org-path)
          ((file-exists-p md-path) md-path)
          (t md-path))))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '01-core-002-path-01-finders)

(when
    (not load-file-name)
  (message "01-core-002-path-01-finders.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))