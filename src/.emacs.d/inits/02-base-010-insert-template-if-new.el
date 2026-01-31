;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:11>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-010-insert-template-if-new.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-07 20:32:38>
;;; File: ./.dotfiles/.emacs.d/inits/010-insert-template-if-new.el

;; ;;; -*- lexical-binding: t -*-
;; ;;; Author: ywatanabe
;; ;;; Time-stamp: <2024-11-07 15:41:37>
;; ;;; File: ./.dotfiles/.emacs.d/inits/010-insert-template-if-new.el

;; (defun my/insert-template-if-new-file ()
;;   "Insert a template for new files based on the file extension."
;;   (interactive)
;;   (when (my/is-new-file)
;;     (let ((extension (my/path-get-extension)))
;;       (cond
;;        ((and (string= extension "py")
;;              (string= (my/path-get-filename) "__init__.py"))
;;         (insert my/py-init-template))
;;        ((string= extension "py")
;;         (insert my/py-script-template))
;;        ((string= extension "sh")
;;         (insert my/shell-template))
;;        ;; ((string= extension "el")
;;        ;;  (my/elisp-new-file-template "el"))
;;        ))))

;; (add-hook 'find-file-hook #'my/insert-template-if-new-file)
;; (remove-hook 'find-file-hook #'my/insert-template-if-new-file)

;;

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-010-insert-template-if-new)

(when
    (not load-file-name)
  (message "02-base-010-insert-template-if-new.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))