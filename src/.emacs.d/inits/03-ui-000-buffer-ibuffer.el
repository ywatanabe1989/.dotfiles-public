;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-04-30 12:11:10>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-buffer-ibuffer.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; -*- lexical-binding: t -*-

(require 'ibuffer)

(setq-default ibuffer-saved-filter-groups
              `(("Default"
                 ("Terminal" (or
                              (mode . term-mode)
                              (mode . eshell-mode)
                              (mode . shell-mode)
                              (mode . vterm-mode)))
                 ("Temporary" (and (name . "^\\*.*\\*$")
                                   (not (name . "\\*GPT\\*"))
                                   (not (mode . dired-mode))
                                   (not (mode . python-mode))
                                   (not (mode . org-mode))
                                   (not (mode . lisp-mode))
                                   (not (mode . term-mode))
                                   (not (mode . eshell-mode))
                                   (not (mode . shell-mode))))
                 ("Dired" (mode . dired-mode))
                 ("Python" (mode . python-mode))
                 ("Image" (or (mode . image-mode)
                              (name . "\\.\\(png\\|jpe?g\\|gif\\)$")))
                 ("Elisp" (or (mode . emacs-lisp-mode)
                              (mode . lisp-interaction-mode)))
                 ("HTML" (mode . html-mode))
                 ("CSV" (mode . csv-mode))
                 ("Markdown" (or (mode . markdown-mode)
                                 (mode . gfm-mode)))
                 ("LaTeX" (mode . latex-mode))
                 ("Other" (not (or (mode . dired-mode)
                                   (name . "^\\*.*\\*$")
                                   (mode . image-mode)
                                   (name
                                    . "\\.\\(png\\|jpe?g\\|gif\\)$")
                                   (mode . emacs-lisp-mode)
                                   (mode . lisp-interaction-mode)
                                   (mode . html-mode)
                                   (mode . csv-mode)
                                   (mode . markdown-mode)
                                   (mode . gfm-mode)
                                   (mode . latex-mode)))))))

;; Bindings

;; Background ibuffer initialization for faster startup
(defvar my/ibuffer-initialized nil
  "Flag to track if ibuffer has been pre-initialized.")

(defun my/ibuffer-background-init ()
  "Initialize ibuffer in background to speed up first call."
  (unless my/ibuffer-initialized
    (save-window-excursion
      (let ((inhibit-message t))
        (ibuffer t nil nil t)
        (when-let ((buf (get-buffer "*Ibuffer*")))
          (with-current-buffer buf
            (ibuffer-update nil t)))))
    (setq my/ibuffer-initialized t)))

(defun my/ibuffer-fast ()
  "Open ibuffer, initializing in background if needed."
  (interactive)
  (unless my/ibuffer-initialized
    (my/ibuffer-background-init))
  (ibuffer))

;; Pre-initialize ibuffer after Emacs is idle for 2 seconds
(run-with-idle-timer 2 nil #'my/ibuffer-background-init)

(global-set-key (kbd "C-x C-b") 'my/ibuffer-fast)


(provide '03-ui-000-buffer-ibuffer)

(when
    (not load-file-name)
  (message "03-ui-000-buffer-ibuffer.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))