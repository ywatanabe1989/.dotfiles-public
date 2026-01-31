;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:33>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-002-path-04-bins.el

;; 1. System Path Settings
;; ----------------------------------------

(add-to-list 'exec-path "/bin/bash")
(add-to-list 'exec-path "/usr/bin")
(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "/opt/local/bin")

;; 2. User Path Settings
;; ----------------------------------------

(add-to-list 'exec-path "/home/ywatanabe/.bin")
(add-to-list 'exec-path "/home/yusukew/.bin")
(add-to-list 'exec-path "/home/ywatanabe/.dotfiles/.bin")
(add-to-list 'exec-path "/home/yusukew/.dotfiles/.bin")
(add-to-list 'exec-path (expand-file-name "~/.venv/bin"))

;; ;;; -*- coding: utf-8; lexical-binding: t -*-
;; ;;; Author: 2025-01-22 21:57:37
;; ;;; Timestamp: <2025-01-22 21:57:37>
;; ;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-002-path-00-bins.el

;; (add-to-list 'exec-path "/bin/bash")
;; (add-to-list 'exec-path "/usr/bin")
;; (add-to-list 'exec-path "/usr/local/bin")
;; (add-to-list 'exec-path "/opt/local/bin")
;; (add-to-list 'exec-path "/home/ywatanabe/.bin")
;; (add-to-list 'exec-path "/home/yusukew/.bin")
;; (add-to-list 'exec-path "/home/ywatanabe/.dotfiles/.bin")
;; (add-to-list 'exec-path "/home/yusukew/.dotfiles/.bin")
;; (add-to-list 'exec-path (expand-file-name "~/.venv/bin"))

;; (when (not load-file-name)
;;   (message "%s loaded." (file-name-nondirectory (or load-file-name buffer-file-name))))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '01-core-002-path-04-bins)

(when
    (not load-file-name)
  (message "01-core-002-path-04-bins.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))