;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:10:37>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/05-code-000-comment-out-formats.el

(defvar my/comment-formats
  '((python-mode . "#")
    (sh-mode . "#")
    (emacs-lisp-mode . ";;")
    (lisp-mode . ";;")
    (c-mode . "//")
    (c++-mode . "//")
    (matlab-mode . "%")
    (latex-mode . "%")
    (markdown-mode . "[//]: #")
    (org-mode . "#")
    (js-mode . "//")
    (javascript-mode . "//")
    (typescript-mode . "//")
    (css-mode . "/*")
    (scss-mode . "//")
    (less-css-mode . "//")
    (ruby-mode . "#")
    (perl-mode . "#")
    (php-mode . "//")
    (sql-mode . "--")
    (rust-mode . "//")
    (go-mode . "//")
    (swift-mode . "//")
    (java-mode . "//")
    (yaml-mode . "#")
    (toml-mode . "#")
    (conf-mode . "#"))
  "Alist of major modes and their comment syntax.")

(defun my/get-comment-syntax ()
  "Get comment syntax based on current major mode or code block context."
  (interactive)
  (cond
   ;; Inside org-mode code block
   ((and (eq major-mode 'org-mode)
         (org-in-src-block-p))
    (let
        ((lang (org-element-property :language (org-element-at-point))))
      (or
       (cdr (assoc (intern (concat lang "-mode")) my/comment-formats))
       (cdr (assoc major-mode my/comment-formats))
       "#")))
   ;; Inside markdown code fence
   ((and (eq major-mode 'markdown-mode)
         (markdown-code-block-at-point-p))
    (let* ((info (markdown-code-block-lang))
           (lang (when info (concat info "-mode"))))
      (or (and lang (cdr (assoc (intern lang) my/comment-formats)))
          (cdr (assoc major-mode my/comment-formats))
          "#")))
   ;; Default behavior
   (t (or (cdr (assoc major-mode my/comment-formats)) "#"))))

;; (--my/get-comment-syntax)

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '05-code-000-comment-out-formats)

(when
    (not load-file-name)
  (message "05-code-000-comment-out-formats.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))