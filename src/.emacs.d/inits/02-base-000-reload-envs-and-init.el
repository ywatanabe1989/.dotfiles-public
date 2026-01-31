;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-11-29 20:50:27>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-000-reload-envs-and-init.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; 1. Main Functions
;; ----------------------------------------

(defun my/reload-envs-and-init-el
    ()
  (interactive)
  (--my/reload-envs)
  (load-file "~/.emacs.d/init.el"))

(defun my/reload-package (package-name)
  (interactive "sPackage name: ")
  (unload-feature (intern package-name) t)
  (require (intern package-name)))

;; 2. Core Functions
;; ----------------------------------------

(defun --my/reload-envs
    ()
  "Reload environment variables from ~/.bashrc"
  (interactive)
  (let
      ((bash-output
        (shell-command-to-string "source ~/.bashrc && env")))
    (dolist
        (line
         (split-string bash-output "\n"))
      (when
          (string-match "\\`\\([^=]+\\)=\\(.*\\)\\'" line)
        (setenv
         (match-string 1 line)
         (match-string 2 line))))
    (setq exec-path
          (split-string
           (getenv "PATH")
           path-separator))))

;; 3. Utility Functions
;; ----------------------------------------

(defun load-directory
    (directory)
  "Load all .el files in DIRECTORY."
  (dolist
      (file
       (directory-files directory t "\\.el$"))
    (load file)))

(--my/reload-envs)

(global-set-key
 (kbd "C-S-r")
 'my/reload-envs-and-init-el)


(provide '02-base-000-reload-envs-and-init)

(when
    (not load-file-name)
  (message "02-base-000-reload-envs-and-init.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))