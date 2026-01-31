;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-06 10:51:54>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-230-wgrep-ripgrep.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)


;;; 02-base-230-wgrep-ripgrep.el - Working remote ripgrep with wgrep

(use-package wgrep
  :ensure
  t
  :config
  (setq wgrep-enable-key "w")
  (setq wgrep-auto-save-buffer t)
  (setq wgrep-change-readonly-file t))

(use-package rg
  :ensure
  t
  :config
  (rg-enable-default-bindings))

(defun my/rg-search (query)
  "Search with ripgrep, handling both local and remote directories."
  (interactive "sSearch: ")

  ;; Get the correct directory
  (let* ((search-directory
          (or (and (eq major-mode 'dired-mode)
                   (file-remote-p default-directory)
                   default-directory)
                                        ; Use default-directory if
              already remote
              (and (eq major-mode 'dired-mode)
                   (fboundp 'my/path-get-path)
                   (my/path-get-path))
              (and (eq major-mode 'dired-mode)
                   (dired-current-directory))
              default-directory)))

    (if (file-remote-p search-directory)
        ;; Use standard rg.el for remote - TRAMP handles it automatically
        (let ((default-directory search-directory)
              (rg-command-line-flags
               '("--no-ignore"
                 "--glob=!**/*undo-tree*"
                 "--glob=!**/.old/**"
                 "--glob=!**/*.log"
                 "--glob=!**/RUNNING/**"
                 "--glob=!**/FINISHED_SUCCESS/**"
                 "--glob=!**/FINISHED/**")))
          ;; rg.el handles TRAMP paths correctly when using rg-project
          (rg-project query "*"))
      ;; Local search
      (let ((default-directory search-directory))
        (rg-project query "*")))))

;; Enable wgrep in rg-mode buffers
(add-hook 'rg-mode-hook
          (lambda ()
            (when (fboundp 'wgrep-setup)
              (wgrep-setup))
            ;; Ensure keybindings work
            (local-set-key (kbd "w") 'wgrep-change-to-wgrep-mode)
            (local-set-key (kbd "C-c C-c") 'wgrep-finish-edit)
            (local-set-key (kbd "C-c C-k") 'wgrep-abort-changes)
            (local-set-key (kbd "RET") 'compile-goto-error)))

(global-set-key (kbd "C-S-g") 'my/rg-search)


(provide '02-base-230-wgrep-ripgrep)

(when
    (not load-file-name)
  (message "02-base-230-wgrep-ripgrep.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))