;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-11-05 02:01:12>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-mouse.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

;; Mouse configuration
(setq mouse-drag-copy-region t)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse t)

;; Drag and drop
(setq mouse-drag-and-drop-region t)
(setq mouse-drag-and-drop-region-cross-program t)

;; File drag and drop protocol
(setq dnd-protocol-alist
      '(("^file:///" . dnd-open-local-file)
        ("^file://" . dnd-open-file)
        ("^file:" . dnd-open-local-file)))

;; Enable context menu
(context-menu-mode 1)

;; Mouse wheel zoom

(global-set-key [C-mouse-4] 'text-scale-increase)

(global-set-key [C-mouse-5] 'text-scale-decrease)

;; Mouse navigation

(global-set-key [mouse-8] 'previous-buffer)

(global-set-key [mouse-9] 'next-buffer)

;; Tab bar mouse scroll navigation
;; Built-in bindings exist in tab-bar-map, but ensure they work:
(with-eval-after-load 'tab-bar
  (define-key tab-bar-map [wheel-up] #'tab-previous)
  (define-key tab-bar-map [wheel-down] #'tab-next)
  (define-key tab-bar-map [wheel-left] #'tab-previous)
  (define-key tab-bar-map [wheel-right] #'tab-next))

;; Enable mouse in terminal (xterm-mouse-mode)
(unless (display-graphic-p)
  (xterm-mouse-mode 1)
  ;; Also enable mouse wheel in terminal
  (global-set-key [mouse-4] 'scroll-down-line)
  (global-set-key [mouse-5] 'scroll-up-line))

(provide '03-ui-000-mouse)

(when
    (not load-file-name)
  (message "03-ui-000-mouse.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))
