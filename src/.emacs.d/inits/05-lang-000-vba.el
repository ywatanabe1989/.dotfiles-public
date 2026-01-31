;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-04-08 17:15:23>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/05-lang-000-vba.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

(require 'vba-mode)
(require 'visual-basic-mode)

(defun my/ensure-vba-mode
    ()
  "Ensure vba-mode is available and loaded."
  (unless
      (require 'vba-mode nil t)
    (my/download-el-to-lisp-dir
     "https://raw.githubusercontent.com/ayanyan/vba-mode/master/vba-mode.el")
    (require 'vba-mode)))

(my/ensure-vba-mode)

(defun vba-mode-variables
    ()
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'vba-indent-line)
  (make-local-variable 'comment-start)
  (setq comment-start "' ")
  (make-local-variable 'comment-start-skip)
  (setq comment-start-skip "'+ *")
  (make-local-variable 'comment-end)
  (setq comment-end "")
  (make-local-variable 'comment-end-skip)
  (setq comment-end-skip nil)
  (setq-local tab-width 4)
  (setq-local vba-mode-indent 4))

(setq vba-mode-indent 4)

;; Keybindings within vba-mode

(define-key vba-mode-map (kbd "TAB") 'vba-indent-line)

(autoload 'vba-mode "vba-mode" "Turn a mode for VBA on." t nil)

(add-to-list 'auto-mode-alist
             '("\\.vba?\\'" . vba-mode))

(add-to-list 'auto-mode-alist
             '("\\.vba?\\'" . visual-basic-mode))

(defun my/change-buffer-to-windows-newlines
    ()
  "Change the entire buffer content to use Windows-style newlines."
  (interactive)
  (goto-char
   (point-min))
  (while
      (search-forward "\n" nil t)
    (replace-match "\r\n" nil t))
  (message "Buffer newlines changed to Windows style"))

(define-key vba-mode-map
            (kbd "C-c w")
            'my/change-buffer-to-windows-newlines)

(defun my/remove-dos-eol-hook
    ()
  (remove-hook 'before-save-hook 'my/remove-dos-eol t))

(add-hook 'vba-mode-hook 'my/remove-dos-eol-hook)

(define-key vba-mode-map (kbd "C-c w")
            'my/change-buffer-to-windows-newlines)

;; Optional: Load message
(when (not load-file-name)
  (message "05-lang-000-vba.el loaded."))

(provide '05-lang-000-vba)

(when
    (not load-file-name)
  (message "05-lang-000-vba.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))