;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:51>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-buffer-ibuffer-hooks.el

(add-hook 'ibuffer-mode-hook
          (lambda ()
            (nerd-icons-ibuffer-mode 1)
            (setq ibuffer-show-empty-filter-groups nil)
            (ibuffer-auto-mode 1)
            (ibuffer-switch-to-saved-filter-groups "Default")
            (define-key ibuffer-mode-map (kbd "M-s") nil)
            (define-key ibuffer-mode-map (kbd "s")
                        'my/buffer-ibuffer-sort)))

;; (add-hook 'ibuffer-mode-hook
;;           (lambda ()
;;             (nerd-icons-ibuffer-mode 1)
;;             (setq ibuffer-show-empty-filter-groups nil)
;;             (ibuffer-auto-mode 1)
;;             (ibuffer-switch-to-saved-filter-groups "Default")
;;             ;; (ibuffer-do-sort-by-recency)
;;             ;; (my/ibuffer-bind-keys)
;;             (define-key ibuffer-mode-map (kbd "M-s") nil)
;;             (define-key ibuffer-mode-map (kbd "s") nil)
;;             (define-key ibuffer-mode-map (kbd "s") 'my/buffer-ibuffer-sort)
;;             ))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '03-ui-000-buffer-ibuffer-hooks)

(when
    (not load-file-name)
  (message "03-ui-000-buffer-ibuffer-hooks.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))