;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-02 09:47:39>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/_01-core-002-path-00-custom-file.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; 1. Custom File Configuration
;; ----------------------------------------

(setq custom-file (locate-user-emacs-file "lisp/custom.el"))

;; 2. File Operations
;; ----------------------------------------

;; custom file

(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file 'noerror)


(provide '_01-core-002-path-00-custom-file)

(when
    (not load-file-name)
  (message "_01-core-002-path-00-custom-file.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))