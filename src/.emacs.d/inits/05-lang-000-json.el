;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-12-24 03:57:52>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/05-lang-000-json.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; Pretty print JSON
(setq json-encoding-pretty-print t)

;; Use json-mode for better JSON editing

(use-package json-mode
  :ensure
  t
  :mode ("\\.json\\'" "\\.jsonl\\'")
  :config)

;; Validate JSON on save

(defun my/json-validate-on-save ()
  "Validate JSON syntax before saving."
  (when (derived-mode-p 'json-mode)
    (condition-case err
        (json-read-from-string (buffer-string))
      (json-error
       (message "JSON syntax error: %s" (error-message-string err))
       nil))))

;; Format JSON with jq (if available)

(defun my/json-format-buffer ()
  "Format the current JSON buffer using jq."
  (interactive)
  (if (executable-find "jq")
      (let ((point (point)))
        (shell-command-on-region (point-min) (point-max) "jq ." nil t)
        (goto-char (min point (point-max))))
    (json-pretty-print-buffer)))

;; JSON mode hook

(defun my/json-mode-hook ()
  "Hook for JSON mode."
  (define-key json-mode-map (kbd "C-c f") #'my/json-format-buffer)
  ;; Enable flycheck for on-the-fly syntax checking
  (flycheck-mode 1)
  ;; Select checker based on available tools (jsonlint > jq > python)
  (cond
   ((executable-find "jsonlint")
    (setq-local flycheck-checker 'json-jsonlint))
   ((executable-find "jq")
    (setq-local flycheck-checker 'json-jq))
   (t
    (setq-local flycheck-checker 'json-python-json)))
  ;; Validate on save
  (add-hook 'before-save-hook #'my/json-validate-on-save nil t))

(when
    (not load-file-name)
  (message "05-lang-000-json.el loaded."))


(provide '05-lang-000-json)

(when
    (not load-file-name)
  (message "05-lang-000-json.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))