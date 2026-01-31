;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:43>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-000-remove-dos.el

;; 2. Special Character Handling Functions
;; ----------------------------------------

(defun my/replace-nnbsp-with-space
    ()
  (interactive)
  "Replace narrow no-break spaces with regular spaces."
  (save-excursion
    (goto-char
     (point-min))
    (while
        (search-forward "\u202F" nil t)
      (replace-match " "))))

(defun my/remove-dos-eol
    ()
  "Remove dos end of line (^M) in the buffer before saving."
  (interactive)
  (save-excursion
    (goto-char
     (point-min))
    (while
        (search-forward "\r" nil t)
      (replace-match ""))))

(add-hook 'before-save-hook 'my/remove-dos-eol)

;; ;; 1. Main Whitespace Management Functions
;; ;; ----------------------------------------

;; (defun my/delete-trailing-whitespace-and-comments ()
;;   "Delete trailing whitespace and trailing comments, then notify in the minibuffer."
;;   (interactive)
;;   (save-excursion
;;     (goto-char (point-min))
;;     (while (not (eobp))
;;       (end-of-line)
;;       (delete-horizontal-space)
;;       (let ((syntax (syntax-ppss)))
;;         (when (nth 4 syntax)
;;           (goto-char (nth 8 syntax))
;;           (skip-syntax-backward " ")
;;           (when (not (bolp))
;;             (delete-region (point) (progn (end-of-line) (point))))))
;;       (forward-line 1))
;;     (message "Trailing whitespaces and comments are deleted.")))

;; (defun my/delete-trailing-whitespace ()
;;   "Delete trailing whitespace and notify in the minibuffer."
;;   (interactive)
;;   (delete-trailing-whitespace)
;;   (message "Trailing whitespaces are deleted."))

;; ;; 2. Special Character Handling Functions
;; ;; ----------------------------------------

;; (defun my/replace-nnbsp-with-space ()
;;   (interactive)
;;   "Replace narrow no-break spaces with regular spaces."
;;   (save-excursion
;;     (goto-char (point-min))
;;     (while (search-forward "\u202F" nil t)
;;       (replace-match " "))))

;; (defun my/remove-dos-eol ()
;;   "Remove dos end of line (^M) in the buffer before saving."
;;   (interactive)
;;   (save-excursion
;;     (goto-char (point-min))
;;     (while (search-forward "\r" nil t) (replace-match ""))))

;; ;; 3. Hooks and Keybindings
;; ;; ----------------------------------------

;; (bind-key* (kbd "C-M-d") 'my/delete-trailing-whitespace-and-comments)

;; (dolist (hook '(prog-mode-hook shell-script-mode-hook))
;;   (add-hook hook
;;             (lambda ()
;;               (add-hook 'before-save-hook #'my/delete-trailing-whitespace nil t))))

;; (add-hook 'before-save-hook 'my/remove-dos-eol)

;; (when (not load-file-name)
;;   (message "%s loaded." (file-name-nondirectory (or load-file-name buffer-file-name))))

;; ;; (defun my/delete-trailing-whitespace-and-comments ()
;; ;;   "Delete trailing whitespace and trailing comments, then notify in the minibuffer."
;; ;;   (interactive)
;; ;;   (save-excursion
;; ;;     (goto-char (point-min))
;; ;;     (while (not (eobp))
;; ;;       (end-of-line)
;; ;;       (delete-horizontal-space)
;; ;;       (let ((syntax (syntax-ppss)))
;; ;;         (when (nth 4 syntax)
;; ;;           (goto-char (nth 8 syntax))
;; ;;           (skip-syntax-backward " ")
;; ;;           (when (not (bolp))
;; ;;             (delete-region (point) (progn (end-of-line) (point))))))
;; ;;       (forward-line 1))
;; ;;     (message "Trailing whitespaces and comments are deleted.")))

;; ;; (bind-key* (kbd "C-M-d") 'my/delete-trailing-whitespace-and-comments)

;; ;; (defun my/delete-trailing-whitespace ()
;; ;;   "Delete trailing whitespace and notify in the minibuffer."
;; ;;   (interactive)
;; ;;   (delete-trailing-whitespace)
;; ;;   (message "Trailing whitespaces are deleted."))
;; ;; (dolist (hook '(prog-mode-hook shell-script-mode-hook))
;; ;;   (add-hook hook
;; ;;             (lambda ()
;; ;;               (add-hook 'before-save-hook #'my/delete-trailing-whitespace nil t))))

;; ;; (defun my/replace-nnbsp-with-space ()
;; ;;   (interactive)
;; ;;   "Replace narrow no-break spaces with regular spaces."
;; ;;   (save-excursion
;; ;;     (goto-char (point-min))
;; ;;     (while (search-forward "\u202F" nil t)
;; ;;       (replace-match " "))))

;; ;; ;; (add-hook 'find-file-hook 'my/replace-nnbsp-with-space)

;; ;; (defun my/remove-dos-eol ()
;; ;;   "Remove dos end of line (^M) in the buffer before saving."
;; ;;   (interactive)
;; ;;   (save-excursion
;; ;;     (goto-char (point-min))
;; ;;     (while (search-forward "\r" nil t) (replace-match ""))))

;; ;; (add-hook 'before-save-hook 'my/remove-dos-eol)

(when
    (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-000-remove-dos)

(when
    (not load-file-name)
  (message "02-base-000-remove-dos.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))