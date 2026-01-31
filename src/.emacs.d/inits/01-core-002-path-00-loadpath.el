;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:31>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-002-path-00-loadpath.el

;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-02-13 12:51:18>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-002-path-00-loadpath.el
;;; Copyright (C) 2024-2025 Yusuke Watanabe (ywatanabe@scitex.ai)

(defun my/add-to-load-path
    ()
  "Configure load-path for Emacs Lisp files and directories."

  (defun --list-dirs
      (dir)
    "List directories in DIR"
    (cl-remove-if-not #'file-directory-p
                      (directory-files dir t "^[^.]")))

  ;; Sets up the base lisp directory
  (setq --base-lisp-dir
        (expand-file-name "~/.emacs.d/lisp/"))

  ;; Lists all directories under the base lisp dir
  (setq --lisp-dirs
        (--list-dirs --base-lisp-dir))

  ;; ~/.emacs.d/lisp itself (depth=0)
  (add-to-list 'load-path --base-lisp-dir)

  ;; Directories in lisp dir (depth=1)
  (dolist
      (--lisp-dir --lisp-dirs)
    (add-to-list 'load-path --lisp-dir))

  ;; Special
  (add-to-list 'load-path "/opt/mu-1.12.6/share/emacs/site-lisp/mu4e/"))

;; Add paths on startup
(my/add-to-load-path)

(provide '01-core-002-path-00-loadpath)

(when
    (not load-file-name)
  (message "01-core-002-path-00-loadpath.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))