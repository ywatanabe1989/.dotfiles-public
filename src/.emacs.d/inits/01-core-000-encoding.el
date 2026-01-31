;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-27 17:03:27>
;;; File: /home/ywatanabe/.emacs.d/inits/01-core-000-encoding.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; 1. Primary Encoding Settings
;; ----------------------------------------

(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; 2. Buffer Encoding Configuration
;; ----------------------------------------

(setq buffer-file-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8-unix)
(setq-default default-buffer-file-coding-system 'utf-8-unix)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)
(setq-default buffer-file-coding-system 'utf-8-unix)

;; 3. Fallback Settings
;; ----------------------------------------

(setq select-safe-coding-system-function
      (lambda
        (&rest _)
        'raw-text))

;; ;;; -*- lexical-binding: t -*-
;; ;;; Author: 2025-01-05 16:07:30
;; ;;; Time-stamp: <2025-01-05 16:07:30 (ywatanabe)>
;; ;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/000-core/000-encoding.el

;; (set-language-environment "UTF-8")
;; (prefer-coding-system 'utf-8)
;; (set-default-coding-systems 'utf-8)
;; (set-terminal-coding-system 'utf-8)
;; (set-keyboard-coding-system 'utf-8)
;; (setq buffer-file-coding-system 'utf-8)

;; (setq-default buffer-file-coding-system 'utf-8-unix)
;; (setq-default default-buffer-file-coding-system 'utf-8-unix)

;; ;; Set default encoding and fallback to raw-text
;; (setq coding-system-for-read 'utf-8)
;; (setq coding-system-for-write 'utf-8)
;; (setq-default buffer-file-coding-system 'utf-8-unix)

;; ;; Auto fallback to raw-text for problematic files
;; (setq select-safe-coding-system-function
;;       (lambda (&rest _) 'raw-text))

;; (when (not load-file-name)
;;   (message "%s loaded." (file-name-nondirectory (or load-file-name buffer-file-name))))


(provide '01-core-000-encoding)

(when
    (not load-file-name)
  (message "01-core-000-encoding.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))