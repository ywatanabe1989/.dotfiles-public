;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:16>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-270-consult.el

;; consult - preview everything

(use-package consult
  :bind
  (("C-x b" . consult-buffer)
   ("M-g g" . consult-goto-line)
   ("M-g o" . consult-outline)))
;; ("M-s f" . consult-find)
;; ("M-s l" . consult-line)  ;; key word
;; ("M-s g" . consult-grep)))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-270-consult)

(when
    (not load-file-name)
  (message "02-base-270-consult.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))