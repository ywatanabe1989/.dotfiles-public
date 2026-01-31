;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:46>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-001-helm-fly.el

;; Helm is a powerful incremental completion and selection framework for Emacs. It provides an interface for narrowing down and selecting items from various sources. These packages extend Helm capabilities to work with:

;; 1. `helm-flycheck` - Interact with Flycheck syntax checker results through Helm
;; 2. `helm-flymake` - Navigate Flymake errors using Helm
;; 3. `helm-flyspell` - Correct misspelled words using Helm interface

(use-package helm-flycheck)

(use-package helm-flymake)

(use-package helm-flyspell)

(when
    (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-001-helm-fly)

(when
    (not load-file-name)
  (message "02-base-001-helm-fly.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))