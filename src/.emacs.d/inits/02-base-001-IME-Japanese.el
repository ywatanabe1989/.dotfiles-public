;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-06-19 09:18:18>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-001-IME-Japanese.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; (defun my/to-ja ()
;;   (interactive)
;;   (add-to-list 'load-path "/usr/share/emacs/site-lisp/ddskk")
;;   (require 'skk)

;;   (set-language-environment "Japanese")
;;   (setq default-input-method "japanese-skk")

;;   (prefer-coding-system 'utf-8)
;;   (set-default-coding-systems 'utf-8)
;;   (set-terminal-coding-system 'utf-8)
;;   (set-keyboard-coding-system 'utf-8)

;;   (set-fontset-font t 'japanese-jisx0208
;;                     (font-spec :family "Noto Sans CJK JP" :size 14))

;;   (activate-input-method "japanese-skk"))

;; sudo apt install skkdic

(defun my/to-ja ()
  (interactive)
  (add-to-list 'load-path "/usr/share/emacs/site-lisp/ddskk")
  (require 'skk)
  (require 'skk-vars)

  (setq skk-large-jisyo "/usr/share/skk/SKK-JISYO.L")
  (setq skk-jisyo-file "~/.skk-jisyo")

  (skk-mode 1))

;; (defun my/to-ja ()
;;   (interactive)
;;   (add-to-list 'load-path "/usr/share/emacs/site-lisp/ddskk")
;;   (load "/usr/share/emacs/site-lisp/ddskk/skk-autoloads")
;;   (require 'skk)

;;   (setq skk-large-jisyo "/usr/share/skk/SKK-JISYO.L")
;;   (setq skk-extra-jisyo-file-list
;;         '("/usr/share/skk/SKK-JISYO.jinmei"
;;           "/usr/share/skk/SKK-JISYO.geo"
;;           "/usr/share/skk/SKK-JISYO.propernoun"))

;;   (set-language-environment "Japanese")
;;   (setq default-input-method "japanese-skk")

;;   (prefer-coding-system 'utf-8)
;;   (set-default-coding-systems 'utf-8)
;;   (set-terminal-coding-system 'utf-8)
;;   (set-keyboard-coding-system 'utf-8)

;;   (set-fontset-font t 'japanese-jisx0208
;;                     (font-spec :family "Noto Sans CJK JP" :size 14))

;;   (activate-input-method "japanese-skk"))

(defun my/toggle-ja-en ()
  (interactive)
  (if current-input-method
      (my/to-en)
    (my/to-ja)))

(global-set-key (kbd "C-c l") 'my/toggle-ja-en)

;; (global-set-key (kbd "C-c l j") 'my/to-ja)

;; (global-set-key (kbd "C-c l e") 'my/to-en)


(provide '02-base-001-IME-Japanese)

(when
    (not load-file-name)
  (message "02-base-001-IME-Japanese.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))