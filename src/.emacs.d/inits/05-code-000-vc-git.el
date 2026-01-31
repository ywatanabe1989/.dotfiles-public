;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:10:38>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/05-code-000-vc-git.el

;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-02-11 18:57:25>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/04-tool-001-git.el
;;; Copyright (C) 2024-2025 Yusuke Watanabe (ywatanabe@scitex.ai)
;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2025-02-11 18:57:25 (ywatanabe)>
;;; File: ./.dotfiles/.emacs.d/inits/710-git.el

(defun my/git-get-root-path
    ()
  "Get git repository root directory."
  (interactive)
  (--my/ssh-path-remove-ssh-prefix
   (magit-toplevel)))
;; (my/git-get-root-path)
(defun my/git-get-project-name
    ()
  "Get git repository project name from root directory."
  (interactive)
  (file-name-nondirectory
   (directory-file-name
    (my/git-get-root-path))))

;; ;; (message (my/git-get-root-path))
;; ;; (message (my/git-get-project-name))

(when
    (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '05-code-000-vc-git)

(when
    (not load-file-name)
  (message "05-code-000-vc-git.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))