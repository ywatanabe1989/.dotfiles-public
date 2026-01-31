;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:34>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-002-path-99-find-files.el

(defun my/find-files
    (find-args-str &optional exclude-patterns)
  "Find files in DIR matching PATTERN. EXCLUDE-PATTERNS is a list of patterns to exclude."
  (let
      ((exclude-cmd
        (if exclude-patterns
            (concat " | grep -v '"
                    (mapconcat
                     (lambda
                       (pat)
                       pat)
                     exclude-patterns
                     "\\|")
                    "'")
          "")))
    (split-string
     (shell-command-to-string
      (format "find %s %s"
              find-args-str
              exclude-cmd))
     "\n" t)))

(provide '01-core-002-path-99-find-files)

(when
    (not load-file-name)
  (message "01-core-002-path-99-find-files.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))