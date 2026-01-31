;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:15>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-240-orderless.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-07 15:16:37>
;;; File: ./.dotfiles/.emacs.d/inits/240-orderless.el

(when (require 'orderless nil t)
  (use-package orderless
    :custom
    (completion-styles '(orderless basic))
    (completion-category-overrides
     '((file (styles basic partial-completion))))))

;; ;; better candidate filtering
;; (use-package orderless
;;   :custom
;;   (completion-styles '(orderless basic))
;;   (completion-category-overrides '((file (styles basic partial-completion)))))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-240-orderless)

(when
    (not load-file-name)
  (message "02-base-240-orderless.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))