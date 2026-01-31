;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-10-25 22:22:51>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-modeline-doom.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; (use-package all-the-icons
;;   :if (display-graphic-p))

;; (use-package nerd-icons)
;; (setq nerd-icons-font-family "Symbols Nerd Font Mono")

;; Invalid face attribute: inherit (doom-modeline-face)
;; Invalid face reference: doom-modeline-face

(use-package doom-modeline
  :after
  all-the-icons
  :init
  (doom-modeline-mode 1)
  :custom-face
  (doom-modeline-face
   ((t :inherit default :background nil :foreground nil)))
  :config
  ;; Size & Style
  (setq doom-modeline-height 1)
  (setq doom-modeline-bar-width 0)
  (setq doom-modeline-buffer-file-name-style 'truncate-nil)
  ;; Features
  (setq doom-modeline-vcs t)
  (setq doom-modeline-percent-position '(-3 "%p"))
  (setq doom-modeline-misc-info t)
  ;; Disabled Features
  (setq doom-modeline-minor-modes nil)
  (setq doom-modeline-buffer-encoding nil)
  (setq doom-modeline-battery nil)
  (setq doom-modeline-env-enable-python nil)
  (setq doom-modeline-env-enable-go nil)
  ;; Icons
  (setq doom-modeline-icon t)
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-major-mode-color-icon t)
  (setq doom-modeline-unicode-fallback t)
  (setq doom-modeline-modal-icon t)
  ;; Colors & Highlighting
  (setq doom-modeline-highlight-modified-buffer-name nil)
  (setq doom-modeline-color-change-for-remote nil)
  (setq doom-modeline-buffer-state-icon nil)
  ;; Components
  (doom-modeline-def-segment user-and-host
    "Display username and hostname."
    (let* ((host (my/find-host))
           (user (user-login-name))
           (icon-and-color (--my/get-host-icon-and-color host))
           (bg-color (cdr icon-and-color))
           (fg-color (my/contrast-color bg-color)))
      (propertize
       (concat
        (doom-modeline-spc)
        (propertize (format "%s@%s" user host) 'face
                    `(:foreground ,fg-color :height 0.8))
        (doom-modeline-spc))
       'face `(:background ,bg-color :foreground ,fg-color))))
  ;; Update the modeline definition to use user-and-host instead of host
  (doom-modeline-def-modeline 'main
    '(bar user-and-host workspace-name window-number modals matches
          buffer-info remote-host buffer-position parrot
          selection-info)
    '(misc-info minor-modes input-method indent-info buffer-encoding
                major-mode process vcs))
  (doom-modeline-set-modeline 'main t)
  :hook (after-init . doom-modeline-mode))


(provide '03-ui-000-modeline-doom)

(when
    (not load-file-name)
  (message "03-ui-000-modeline-doom.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))