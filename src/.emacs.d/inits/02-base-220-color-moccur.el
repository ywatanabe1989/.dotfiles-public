;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:15>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-220-color-moccur.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-07 15:16:36>
;;; File: ./.dotfiles/.emacs.d/inits/220-color-moccur.el

;; -*- lexical-binding: t -*-

(use-package color-moccur
  :ensure
  t
  :bind ("M-o" . occur-by-moccur)
  :config
  (setq moccur-split-word t)
  ;; Add patterns to the exclusion list
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$"))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-220-color-moccur)

(when
    (not load-file-name)
  (message "02-base-220-color-moccur.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))