;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-25 23:34:50>
;;; File: /home/ywatanabe/.emacs.d/inits/03-ui-000-dired-git-info.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

(use-package dired-git-info
  :bind
  (:map dired-mode-map
        (")" . dired-git-info-mode)))

(defun my/dired-show-git-branch ()
  "Show git branch in dired header."
  (when (and (derived-mode-p 'dired-mode)
             (vc-git-root default-directory))
    (let ((branch (magit-get-current-branch)))
      (when branch
        (setq header-line-format
              (format "Branch: %s | %s" branch default-directory))))))

(add-hook 'dired-mode-hook 'my/dired-show-git-branch)

(use-package dired-sidebar
  :config
  (setq dired-sidebar-display-alist
        '((side . left)
          (slot . -1)
          (window-width . 25))))


(provide '03-ui-000-dired-git-info)

(when
    (not load-file-name)
  (message "03-ui-000-dired-git-info.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))