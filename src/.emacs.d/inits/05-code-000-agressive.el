;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-04-21 08:00:19>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/05-code-000-agressive.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

;; Attempt to load aggressive-indent, but don't error if not found
(require 'aggressive-indent nil t)

;; Define the toggle function

(defun my/toggle-aggressive-indent-mode ()
  "Toggle `aggressive-indent-mode` globally."
  (interactive)
  ;; aggressive-indent-mode is the variable indicating the mode's status
  (if aggressive-indent-mode
      ;; If it's currently on, turn it off
      (progn
        (aggressive-indent-mode -1)
        (message "Aggressive Indent Mode: OFF"))
    ;; If it's currently off, turn it on
    (progn
      (aggressive-indent-mode 1)
      (message "Aggressive Indent Mode: ON"))))

;; Enable aggressive-indent-mode globally by default.
;; You might remove this line if you prefer to start with it off
;; and only enable it manually using M-x my/toggle-aggressive-indent-mode.
(aggressive-indent-mode 1)

;; Provide statement for Emacs' package system

;; ;;; -*- coding: utf-8; lexical-binding: t -*-
;; ;;; Author: ywatanabe
;; ;;; Timestamp: <2025-03-05 22:10:37>
;; ;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/05-code-000-agressive.el

;; (global-aggressive-indent-mode 1)

;; (provide '05-code-000-agressive)

;; (when
;;     (not load-file-name)
;;   (message "05-code-000-agressive.el loaded."
;;            (file-name-nondirectory
;;             (or load-file-name buffer-file-name))))

(provide '05-code-000-agressive)

(when
    (not load-file-name)
  (message "05-code-000-agressive.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))