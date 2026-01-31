;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-08 00:51:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-eval.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

(defun e ()
  "Evaluate code depending on the context - dired or normal buffer."
  (interactive)
  (if (eq major-mode 'dired-mode)
      (my/dired-eval-selected-files)
    (my/eval-region-or-buffer)))

;; (defun my/dired-eval-selected-files ()
;;   "Evaluate selected elisp files in dired."
;;   (let ((marked-files (dired-get-marked-files)))
;;     (dolist (file marked-files)
;;       (when (string-match-p "\\.el$" file)
;;         (message "Evaluating %s..." file)
;;         (load-file file)))))

;; (defun my/eval-region-or-buffer ()
;;   "Evaluate region if active, otherwise evaluate buffer."
;;   (if (use-region-p)
;;       (eval-region (region-beginning) (region-end))
;;     (eval-buffer)))


(provide '03-ui-000-eval)

(when
    (not load-file-name)
  (message "03-ui-000-eval.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))