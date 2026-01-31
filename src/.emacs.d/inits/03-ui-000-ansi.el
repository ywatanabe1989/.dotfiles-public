;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-04-30 11:45:28>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-ansi.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(require 'ansi-color)

;; Define patterns for files that should have ANSI colors applied

(defvar my/ansi-colors-regexps
  '("\\.log\\'" "\\.pytest\\'" "\\.output\\'")
  "Regular expressions for file patterns that should have ANSI colors applied automatically.")

;; Interactive function to toggle ANSI colors in buffer

(defun my/ansi-colors-toggle-buffer ()
  "Toggle ANSI color rendering in the current buffer."
  (interactive)
  (if (get-text-property (point-min) 'ansi-color-applied)
      (progn
        (let ((inhibit-read-only t))
          (remove-text-properties (point-min) (point-max)
                                  '(ansi-color-applied nil))
          (revert-buffer :ignore-auto :noconfirm))
        (message "ANSI colors removed"))
    (progn
      (ansi-color-apply-on-region (point-min) (point-max))
      (put-text-property (point-min) (point-max) 'ansi-color-applied t)
      (message "ANSI colors applied"))))

;; Hook function to apply ANSI colors when opening files

(defun my/ansi-colors-apply-if-match ()
  "Apply ANSI colors if the current file matches patterns in my/ansi-colors-regexps."
  (when (and buffer-file-name
             (seq-some (lambda (pattern)
                         (string-match pattern buffer-file-name))
                       my/ansi-colors-regexps))
    (ansi-color-apply-on-region (point-min) (point-max))
    (put-text-property (point-min) (point-max) 'ansi-color-applied t)
    (read-only-mode)))


(provide '03-ui-000-ansi)

(when
    (not load-file-name)
  (message "03-ui-000-ansi.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))