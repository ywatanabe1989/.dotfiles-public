;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:32>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-002-path-02-getters.el

;;; Copyright (C) 2024-2025 Yusuke Watanabe (ywatanabe@scitex.ai)

;; 1. Primary Path Functions
;; ----------------------------------------

(defun my/path-clean-path
    (&optional path)
  "Clean PATH by removing SSH prefixes and keeping symlinks.
If PATH is nil, uses buffer's file name.
Example usage:
(my/path-clean-path \"/ssh:host:/path/to/file\")
;; => \"/path/to/file\"
(my/path-clean-path \"~/path/to/file\")
;; => \"/home/user/path/to/file\""
  (interactive)
  (let*
      ((input-path
        (or path
            (buffer-file-name)
            default-directory))
       (cleaned-path
        (if
            (file-remote-p input-path)
            (--my/ssh-path-remove-ssh-prefix input-path)
          (expand-file-name input-path))))
    (if
        (called-interactively-p 'any)
        (message "%s" cleaned-path)
      cleaned-path)))

(defun my/path-get-path
    ()
  "Return the buffer's file path without SSH prefixes and without resolving symlinks."
  (interactive)
  (let*
      ((file-path
        (or buffer-file-name default-directory))
       (clean-path
        (--my/ssh-path-remove-ssh-prefix file-path)))
    (when
        (called-interactively-p 'any)
      (message "path: %s" clean-path))
    clean-path))

;; 2. Path Processing Functions
;; ----------------------------------------

(defun my/path-get-dir
    (&optional path)
  "Return the directory of PATH or buffer without SSH prefixes and symlinks."
  (interactive)
  (let*
      ((current-path
        (or path
            (my/path-get-path)))
       (current-dir
        (if
            (file-directory-p current-path)
            current-path
          (file-name-directory current-path))))
    (when
        (called-interactively-p 'any)
      (message "directory: %s" current-dir))
    current-dir))

(defun my/path-get-filename
    (&optional path)
  "Get the filename from PATH.
If PATH is nil or empty, use the buffer's file name.
This function extracts the file name from a given file path."
  (interactive "sEnter file path (leave empty for file): ")
  (let
      ((file-path
        (if
            (and
             (string-empty-p path)
             (not
              (buffer-file-name)))
            (dired-get-file-for-visit)
          (or path
              (buffer-file-name)))))
    (if file-path
        (file-name-nondirectory file-path)
      (message "No valid file path provided."))))

(defun my/path-get-extension
    (&optional path)
  "Return the file extension of PATH or buffer's file path.
If no file is associated, return nil."
  (interactive)
  (let
      ((current-path
        (or path
            (my/path-get-path))))
    (if current-path
        (file-name-extension current-path)
      (message "No file associated with the buffer."))))

;; 3. Path Transformation Functions
;; ----------------------------------------

(defun my/path-get-path-from
    (from_expression &optional path)
  "Return PATH or buffer's script path (relative to FROM_EXPRESSION)."
  (interactive)
  (let*
      ((path-to-use
        (or path
            (my/path-get-path)))
       (scripts-pos
        (string-match from_expression path-to-use)))
    (if scripts-pos
        (concat "."
                (substring path-to-use scripts-pos))
      path-to-use)))

(defun my/path-get-path-from-git-root
    (&optional path)
  "Get file path relative to git root. Optional PATH can be specified."
  (interactive)
  (let*
      ((git-project-name
        (my/git-get-project-name))
       (rel-path
        (my/path-get-path-from git-project-name path)))
    (if
        (string-prefix-p "." rel-path)
        (concat "./"
                (substring rel-path 1))
      rel-path)))

(defun my/path-get-path-from-script-dir
    (&optional path)
  "Get file path relative to scripts directory as ./path/to/file.
Optionally processes specified PATH instead of buffer's path."
  (interactive)
  (let*
      ((script-expression "scripts")
       (rel-path
        (my/path-get-path-from script-expression path)))
    (if
        (string-prefix-p "." rel-path)
        (concat "./"
                (substring rel-path 1))
      rel-path)))

(defun my/path-get-visible-files
    ()
  "Return a list of file paths from all visible buffers in current tab."
  (interactive)
  (let
      (visible-files)
    (walk-windows
     (lambda
       (window)
       (let*
           ((buffer
             (window-buffer window))
            (file
             (buffer-file-name buffer)))
         (when file
           (push file visible-files))))
     nil 'visible)
    (message "%s" visible-files)
    visible-files))

;; ;;; -*- coding: utf-8; lexical-binding: t -*-
;; ;;; Author: 2025-01-19 19:05:29
;; ;;; Timestamp: <2025-01-19 19:05:29>
;; ;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/000-core/002-path/00-getters.el

;; (defun my/path-clean-path (&optional path)
;;   "Clean PATH by removing SSH prefixes and keeping symlinks.
;; If PATH is nil, uses buffer's file name.

;; Example usage:
;;   (my/path-clean-path \"/ssh:host:/path/to/file\")
;;   ;; => \"/path/to/file\"

;;   (my/path-clean-path \"~/path/to/file\")
;;   ;; => \"/home/user/path/to/file\""
;;   (interactive)
;;   (let* ((input-path (or path (buffer-file-name) default-directory))
;;          (cleaned-path (if (file-remote-p input-path)
;;                            (--my/ssh-path-remove-ssh-prefix input-path)
;;                          (expand-file-name input-path))))
;;     (if (called-interactively-p 'any)
;;         (message "%s" cleaned-path)
;;       cleaned-path)))

;; (defun my/path-get-path ()
;;   "Return the buffer's file path without SSH prefixes and without resolving symlinks."
;;   (interactive)
;;   (let* ((file-path (or buffer-file-name default-directory))
;;          (clean-path (--my/ssh-path-remove-ssh-prefix file-path)))
;;     (when (called-interactively-p 'any)
;;       (message "path: %s" clean-path))
;;     clean-path))
;; ;; (my/path-get-path)

;; (defun my/path-get-dir (&optional path)
;;   "Return the directory of PATH or buffer without SSH prefixes and symlinks."
;;   (interactive)
;;   (let* ((current-path (or path (my/path-get-path)))
;;          (current-dir (if (file-directory-p current-path)
;;                           current-path
;;                         (file-name-directory current-path))))
;;     (when (called-interactively-p 'any)
;;       (message "directory: %s" current-dir))
;;     current-dir))
;; ;; (my/path-get-dir)

;; (defun my/path-get-filename (&optional path)
;;   "Get the filename from PATH.
;; If PATH is nil or empty, use the buffer's file name.
;; This function extracts the file name from a given file path."
;;   (interactive "sEnter file path (leave empty for file): ")
;;   (let ((file-path (if (and (string-empty-p path) (not (buffer-file-name)))
;;                        (dired-get-file-for-visit)
;;                      (or path (buffer-file-name)))))
;;     (if file-path
;;         (file-name-nondirectory file-path)
;;       (message "No valid file path provided."))))
;; ;; (message (my/path-get-filename))

;; (defun my/path-get-extension (&optional path)
;;   "Return the file extension of PATH or buffer's file path.
;; If no file is associated, return nil."
;;   (interactive)
;;   (let ((current-path (or path (my/path-get-path))))
;;     (if current-path
;;         (file-name-extension current-path)
;;       (message "No file associated with the buffer."))))
;; ;; (message (my/path-get-extension))

;; (defun my/path-get-path-from (from_expression &optional path)
;;   "Return PATH or buffer's script path (relative to FROM_EXPRESSION)."
;;   (interactive)
;;   (let* ((path-to-use (or path (my/path-get-path)))
;;          (scripts-pos (string-match from_expression path-to-use)))
;;     (if scripts-pos
;;         (concat "." (substring path-to-use scripts-pos))
;;       path-to-use)))
;; ;; (my/path-get-path-from ".dotfiles", "./.dotfiles/aaa")

;; (defun my/path-get-path-from-git-root (&optional path)
;;   "Get file path relative to git root. Optional PATH can be specified."
;;   (interactive)
;;   (let* ((git-project-name (my/git-get-project-name))
;;          (rel-path (my/path-get-path-from git-project-name path)))
;;     (if (string-prefix-p "." rel-path)
;;         (concat "./" (substring rel-path 1))
;;       ;; (concat "./" rel-path)
;;       rel-path)))
;; ;; (my/path-get-path-from-git-root)

;; (defun my/path-get-path-from-script-dir (&optional path)
;;   "Get file path relative to scripts directory as ./path/to/file.
;; Optionally processes specified PATH instead of buffer's path."
;;   (interactive)
;;   (let* ((script-expression "scripts")
;;          (rel-path (my/path-get-path-from script-expression path)))
;;     (if (string-prefix-p "." rel-path)
;;         (concat "./" (substring rel-path 1))
;;       rel-path)))
;; ;; (my/path-get-path-from-script-dir)

;; (defun my/path-get-visible-files ()
;;   "Return a list of file paths from all visible buffers in current tab."
;;   (interactive)
;;   (let (visible-files)
;;     (walk-windows
;;      (lambda (window)
;;        (let* ((buffer (window-buffer window))
;;               (file (buffer-file-name buffer)))
;;          (when file
;;            (push file visible-files))))
;;      nil 'visible)
;;     (message "%s" visible-files)
;;     visible-files))
;; ;; (my/path-get-visible-files)

;; (when (not load-file-name)
;;   (message "%s loaded." (file-name-nondirectory (or load-file-name buffer-file-name))))

(bind-key*
 (kbd "C-c C-f")
 'my/path-copy-current-script-path)

(when
    (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '01-core-002-path-02-getters)

(when
    (not load-file-name)
  (message "01-core-002-path-02-getters.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))