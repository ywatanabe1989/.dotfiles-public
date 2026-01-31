;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:52>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-buffer-ibuffer-keybindings.el

;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: 2025-01-22 19:56:01
;;; Timestamp: <2025-01-22 19:56:01>
;;; File: /home/ywatanabe/.emacs.d/inits/03-visu-001-buffer-00-buffer-ibuffer-keybindings.el

(defun my/ibuffer-bind-keys ()
  (define-key ibuffer-mode-map (kbd "M-s") nil)
  (define-key ibuffer-mode-map (kbd "s") nil)
  (define-key ibuffer-mode-map (kbd "s") 'my/buffer-ibuffer-sort))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '03-ui-000-buffer-ibuffer-keybindings)

(when
    (not load-file-name)
  (message "03-ui-000-buffer-ibuffer-keybindings.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))