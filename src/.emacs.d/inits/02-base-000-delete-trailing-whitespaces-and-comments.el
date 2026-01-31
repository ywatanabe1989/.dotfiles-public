;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-14 18:28:08>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-000-delete-trailing-whitespaces-and-comments.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

;; 1. Main Whitespace Management Functions
;; ----------------------------------------

(defun --my/delete-trailing-whitespace-and-comments
    ()
  "Delete trailing whitespace and trailing comments, then notify in the minibuffer."
  (interactive)
  (save-excursion
    (goto-char
     (point-min))
    (while
        (not
         (eobp))
      (end-of-line)
      (delete-horizontal-space)
      (let
          ((syntax
            (syntax-ppss)))
        (when
            (nth 4 syntax)
          (goto-char
           (nth 8 syntax))
          (skip-syntax-backward " ")
          (when
              (not
               (bolp))
            (delete-region
             (point)
             (progn
               (end-of-line)
               (point))))))
      (forward-line 1))
    (message "Trailing whitespaces and comments are deleted.")))

;; (defun my/delete-trailing-whitespace
;;     ()
;;   "Delete trailing whitespace and notify in the minibuffer."
;;   (interactive)
;;   (delete-trailing-whitespace)
;;   (message "Trailing whitespaces are deleted."))

;; Key Binding
;; ----------------------------------------

(bind-key*
 (kbd "C-M-d")
 #'--my/delete-trailing-whitespace-and-comments)

;; (dolist
;;     (hook
;;      '(prog-mode-hook shell-script-mode-hook))
;;   (add-hook hook
;;             (lambda
;;               ()
;;               (add-hook 'before-save-hook
;;                         #'--my/delete-trailing-whitespace-and-comments
;;                         nil t))))

(dolist
    (hook
     '(prog-mode-hook shell-script-mode-hook))
  (add-hook hook
            (lambda
              ()
              (add-hook 'before-save-hook
                        #'delete-trailing-whitespace
                        nil t))))

(provide '02-base-000-delete-trailing-whitespaces-and-comments)

(when
    (not load-file-name)
  (message "02-base-000-delete-trailing-whitespaces-and-comments.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))