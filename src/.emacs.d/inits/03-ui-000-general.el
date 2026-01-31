;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-12-18 21:24:28>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-general.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; -*- lexical-binding: t -*-

;; Font
;; (set-frame-font "DejaVu Sans Mono-10" nil t)
(set-frame-font "DejaVu Sans Mono-9" nil t)
(set-fontset-font t 'unicode "Symbols Nerd Font Mono" nil 'append)

;; (set-frame-font "Consolas-10" nil t)
;; (set-frame-font "Inconsolata-10" nil t)
;; (set-frame-font "Monaco-10" nil t)
;; (set-frame-font "Source Code Pro-10" nil t)
;; (set-frame-font "Iosevka Extended 12" nil t)

;; Column number
(column-number-mode t)

;; Line number
(global-display-line-numbers-mode -1)
(setq display-line-numbers "%4d \u2502 ")

;; Highlight line

(defface my/hl-line-face
  '((((class color) (background dark))
     (:background "NavyBlue" t))
    (((class color) (background light))
     (:background "LightSkyBlue" t))
    (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my/hl-line-face)
(global-hl-line-mode t)

;; Display Encoding
(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")

;; Parenthesis
(show-paren-mode t)
;; (show-paren-mode 0)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)

;; Time
(display-time-mode t)
(display-time)
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)

;; Battery
                                        ; (display-battery-mode nil)

;; Disable menu bar, tool bar, and scroll bar
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq mode-line-format t)

;; ;; fixme
;; (setq default-frame-alist (cons '(tool-bar-lines . 0) default-frame-alist))
;; (setq initial-frame-alist (cons '(tool-bar-lines . 0) initial-frame-alist))

;; (define-key global-map (kbd "C-c l") 'toggle-truncate-lines)
;; (define-key global-map (kbd "C-c l") nil)

;; (defun my/enable-company-for-files ()
;;   "Enable company-mode for specific files."
;;   (when (and (buffer-file-name)
;;              (string-match-p "\\.myext\\'" (buffer-file-name)))
;;     (company-mode 1)))

;; (add-hook 'find-file-hook 'vc-find-file-hook)
;; (add-hook 'find-file-hook 'my/enable-company-for-files)


(provide '03-ui-000-general)

(when
    (not load-file-name)
  (message "03-ui-000-general.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))