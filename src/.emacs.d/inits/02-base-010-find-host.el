;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-04-16 08:27:51>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-010-find-host.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

(defun --my/find-host-file-dired
    ()
  "Return the lowercase host name of the current buffer."
  (interactive)
  (let*
      ((default-directory
        (or
         (buffer-file-name)
         default-directory))
       (remote-host
        (when
            (file-remote-p default-directory)
          (tramp-file-name-host
           (tramp-dissect-file-name default-directory))))
       (host
        (or remote-host
            (system-name))))
    (downcase
     (format "%s" host))))

(defun --my/term-estimate-remote-host
    ()
  (interactive)
  (with-current-buffer
      (current-buffer)
    (save-excursion
      (goto-char (point-max))
      ;; Search backward for a line containing (..) pattern followed by $
      (when (re-search-backward "(\\([^)]+\\)).*\\$" nil t)
        (let ((line-start (line-beginning-position))
              (line-end (line-end-position))
              (last-match nil))
          ;; Find all (...) patterns on this line and keep the last one
          (goto-char line-start)
          (while (re-search-forward "(\\([^)]+\\))" line-end t)
            (setq last-match (match-string 1)))
          (when last-match
            (downcase last-match)))))))

(defun my/find-host
    ()
  "Find lowercase host based on mode."
  (interactive)
  (let
      ((host
        (if
            (or (eq major-mode 'term-mode) (eq major-mode 'vterm-mode))
            (--my/term-estimate-remote-host)
          (--my/find-host-file-dired))))
    host))

(provide '02-base-010-find-host)

(when
    (not load-file-name)
  (message "02-base-010-find-host.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))