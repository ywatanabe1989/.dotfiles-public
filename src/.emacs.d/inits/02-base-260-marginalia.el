;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:16>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-260-marginalia.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-07 15:16:37>
;;; File: ./.dotfiles/.emacs.d/inits/260-marginalia.el

;; (all-the-icons-install-fonts)
;; (use-package marginalia
;;   :init (marginalia-mode))

;; Enable rich annotations using the Marginalia package

(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind
  (:map minibuffer-local-map
        ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-260-marginalia)

(when
    (not load-file-name)
  (message "02-base-260-marginalia.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))