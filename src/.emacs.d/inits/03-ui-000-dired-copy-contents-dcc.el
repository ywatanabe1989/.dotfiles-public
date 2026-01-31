;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-30 17:49:33>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-dired-copy-contents-dcc.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(require 'dired)
(require 'genai)
(require 'genai-file-collector)

(defgroup dired-copy-contents nil
  "Copy contents of files from dired."
  :group 'dired
  :prefix "dcc-")

(defcustom dcc-save-to-cache t
  "Whether to save copied contents to cache directory."
  :type 'boolean
  :group 'dired-copy-contents)

(defcustom dcc-cache-directory "~/win/downloads"
  "Directory to save copied contents."
  :type 'string
  :group 'dired-copy-contents)

(defcustom dcc-separator-style 'equals
  "Style of separator between files."
  :type '(choice (const :tag "Equal signs" equals)
                 (const :tag "Dashes" dashes)
                 (const :tag "Comment style" comment)
                 (const :tag "Custom" custom))
  :group 'dired-copy-contents)

(defcustom dcc-custom-separator "# "
  "Custom separator prefix when dcc-separator-style is 'custom."
  :type 'string
  :group 'dired-copy-contents)

(defun dcc--get-separator ()
  "Get separator string based on dcc-separator-style."
  (pcase dcc-separator-style
    ('equals (make-string 80 ?=))
    ('dashes (make-string 80 ?-))
    ('comment (concat (make-string 20 ?#) " " (make-string 59 ?#)))
    ('custom (concat dcc-custom-separator
                     (make-string (- 78 (length dcc-custom-separator))
                                  (aref dcc-custom-separator 0))))
    (_ (make-string 80 ?=))))

(defun dcc--copy-contents (selected-entries)
  "Copy contents of SELECTED-ENTRIES to kill ring and optionally cache."
  (let ((files-string "")
        (separator (dcc--get-separator))
        (total-lines 0)
        (timestamp (format-time-string "%Y-%m-%d %H:%M:%S"))
        (cache-timestamp (format-time-string "%Y%m%d_%H%M%S"))
        (dired-location (file-name-nondirectory
                         (directory-file-name default-directory))))
    (setq files-string
          (concat files-string
                  (format "%s\n" separator)
                  (format "Copied %d files at %s\n"
                          (length selected-entries) timestamp)
                  (format "%s\n\n" separator)))
    (dolist (entry selected-entries)
      (let* ((file-path (cadr entry))
             (relative-path (file-relative-name file-path))
             (file-size
              (file-attribute-size (file-attributes file-path)))
             (estimated-words (genai-fc--estimate-words file-path))
             (file-contents (with-temp-buffer
                              (insert-file-contents-literally
                               file-path)
                              (buffer-string)))
             (file-lines (length (split-string file-contents "\n" t))))
        (setq files-string
              (concat files-string
                      (format "%s\n" separator)
                      (format "File: %s\n" file-path)
                      (format "Relative: %s\n" relative-path)
                      (format
                       "Size: %d bytes, Lines: %d, Words: ~%d\n"
                       file-size file-lines estimated-words)
                      (format "%s\n" separator)
                      file-contents
                      (unless (string-suffix-p "\n" file-contents)
                        "\n")
                      "\n"))
        (setq total-lines (+ total-lines file-lines))))
    (kill-new files-string)
    (when dcc-save-to-cache
      (let* ((cache-dir (expand-file-name dcc-cache-directory))
             (cache-filename
              (format "%s-%s.txt" cache-timestamp dired-location))
             (cache-filepath
              (expand-file-name cache-filename cache-dir)))
        (unless (file-exists-p cache-dir)
          (make-directory cache-dir t))
        (with-temp-file cache-filepath
          (insert files-string))
        (message "Saved to %s" cache-filepath)))
    total-lines))

(defun dcc--handle-selection (selected-entries total-words)
  "Handle selected entries for clipboard copy."
  (when (y-or-n-p (format "Copy %d files with total ~%d words? "
                          (length selected-entries) total-words))
    (let ((copied-lines (dcc--copy-contents selected-entries)))
      (kill-buffer (current-buffer))
      (message "Copied %d files (%d lines and ~%d words)"
               (length selected-entries) copied-lines total-words))))

(defun dcc-run ()
  "Create buffer with files to copy from marked files in visible dired buffers."
  (interactive)
  (genai-fc-collect-and-display "*Files to Copy*"
                                #'dcc--handle-selection))


(provide '03-ui-000-dired-copy-contents-dcc)

(when
    (not load-file-name)
  (message "03-ui-000-dired-copy-contents-dcc.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))
