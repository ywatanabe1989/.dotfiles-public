;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:09:04>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-indent.el

;; Indent
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; Highlight indent

(use-package highlight-indent-guides
  :ensure
  t
  :config
  (setq highlight-indent-guides-method 'character)
  (setq highlight-indent-guides-character 124)
  (setq highlight-indent-guides-responsive 'top)
  (setq highlight-indent-guides-auto-enabled nil)
  (setq highlight-indent-guides-delay 0)

  ;; Set faces for the guides
  (set-face-background 'highlight-indent-guides-odd-face "dimgray")
  (set-face-background 'highlight-indent-guides-even-face "dimgray")
  (set-face-foreground 'highlight-indent-guides-character-face
                       "dimgray")
  (set-face-background 'highlight-indent-guides-top-odd-face
                       "darkgray")
  (set-face-background 'highlight-indent-guides-top-even-face
                       "darkgray")
  (set-face-foreground 'highlight-indent-guides-top-character-face
                       "darkgray"))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '03-ui-000-indent)

(when
    (not load-file-name)
  (message "03-ui-000-indent.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))