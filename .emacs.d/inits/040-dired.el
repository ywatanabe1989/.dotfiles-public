;; -*- lexical-binding: t -*-

(require 'dired-x)

(add-hook 'dired-mode-hook (lambda ()
                             (dired-omit-mode t)
                             (setq truncate-lines t)
                             ))
;;   ;;
;;   ;; (add-hook 'dired-mode-hook (lambda () (setq truncate-lines t)))


(setq dired-listing-switches "-alh"
      dired-omit-files "^\\...+$"
      dired-omit-files-p t
      dired-recursive-copies 'always
      dired-recursive-deletes 'always
      dired-dwim-target t
      dired-clean-confirm-killing-deleted-buffers nil
      truncate-lines t
      )

;; Custom function to open files/directories
(defun my/dired-find-alternate-file ()
  "Open the file or directory at point without killing the dired buffer if it is 'home' or 'semi-home'."
  (interactive)
  (let ((file-name (dired-get-file-for-visit)))
    (if (or (my/tab-is-any-buffer "home")
            (my/tab-is-any-buffer "semi-home"))
        (dired-find-file)
      (dired-find-alternate-file))))

(defun my/dired-find-alternate-file-if-directory ()
  "Open files or directories in accordance with their type."
  (interactive)
  ;; (let ((file (my/clean-ssh-path (dired-get-file-for-visit))))  ; Get filename, allow for error if none under point
  (let ((file (dired-get-file-for-visit)))
    (if (file-directory-p file)
        (dired-find-alternate-file)
      ;; (dired-find-file))))
      (find-file file))))

(defun my/copy-to-relay-point ()
  "Copy marked files in Dired mode, or the current buffer file to the relay point directory.
If in Dired mode and files are marked, copy all marked files.
If in Dired mode and on a directory with no marks, copy the directory recursively.
Otherwise, copy the current buffer file."
  (interactive)
  (let ((files (if (eq major-mode 'dired-mode)
                   (dired-get-marked-files)
                 (list (buffer-file-name))))
        (destination-dir "/home/ywatanabe/onedrive/relay_point/"))
    (dolist (source files)
      (let ((destination (concat destination-dir (file-name-nondirectory source))))
        (message "Copying '%s' to '%s'" source destination)
        (if (file-directory-p source)
            (copy-directory source destination t t t)
          (copy-file source destination t))
        (message "Copied '%s' to '%s'" source destination)))))

;; Keybindings
(define-key dired-mode-map (kbd "C-m") #'my/dired-find-alternate-file)
(define-key dired-mode-map (kbd "RET") 'dired-find-file)
(define-key dired-mode-map (kbd "C-c C-a") nil)
(define-key dired-mode-map (kbd "S") 'dired-do-relsymlink)
(define-key dired-mode-map (kbd "h") 'dired-hide-details-mode)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
(define-key dired-mode-map (kbd "C-t") 'other-window)
(define-key dired-mode-map (kbd "C-i") 'image-dired-dired-toggle-marked-thumbs)
(define-key dired-mode-map (kbd "S-s") 'dired-do-relsymlink)
(define-key dired-mode-map (kbd "M-h") (lambda () (interactive) (my/tab-jump-to-buffer "home")))
(define-key dired-mode-map (kbd "M-H") (lambda () (interactive) (my/tab-set-buffer "home")))
(define-key dired-mode-map (kbd "M-s") (lambda () (interactive) (my/tab-jump-to-buffer "semi-home")))
(define-key dired-mode-map (kbd "M-S") (lambda () (interactive) (my/tab-set-buffer "semi-home")))
(define-key dired-mode-map (kbd "C-C C-r") 'my/copy-to-relay-point)

;; (use-package dired
;;   :ensure nil
;;   :config
;;   (setq dired-listing-switches "-alh"
;;         dired-omit-files "^\\...+$"
;;         dired-omit-files-p t
;;         dired-recursive-copies 'always
;;         dired-recursive-deletes 'always
;;         dired-dwim-target t
;;         dired-clean-confirm-killing-deleted-buffers nil
;;         truncate-lines t
;;         )

;;   ;; (add-hook 'dired-mode-hook (lambda () (dired-omit-mode t)))
;;   ;; (add-hook 'dired-mode-hook (lambda () (setq truncate-lines t)))

;;   ;; Custom function to open files/directories
;;   (defun my/dired-find-alternate-file ()
;;   "Open the file or directory at point without killing the dired buffer if it is 'home' or 'semi-home'."
;;   (interactive)
;;   (let ((file-name (dired-get-file-for-visit)))
;;     (if (or (my/tab-is-any-buffer "home")
;;             (my/tab-is-any-buffer "semi-home"))
;;         (dired-find-file)
;;       (dired-find-alternate-file))))

;;   ;; (defun my/dired-find-alternate-file-if-directory ()
;;   ;;   "Open files or directories in accordance with their type."
;;   ;;   (interactive)
;;   ;;   (message file) ; for debugging
;;   ;;   (let ((file (dired-get-filename nil t)))  ; Get filename, allow for error if none under point
;;   ;;     (if (file-directory-p file)
;;   ;;         (dired-find-alternate-file)
;;   ;;       (dired-find-file file))))

;;   ;; (defun my/dired-find-alternate-file-if-directory ()
;;   ;;   (interactive)
;;   ;;   (let ((file (dired-get-filename)))
;;   ;;     (if (file-directory-p file)
;;   ;;         (dired-find-alternate-file)
;;   ;;       (dired-find-file)))) ; this might be better to be fixed for image files

;;   (defun my/copy-to-relay-point ()
;;     "Copy marked files in Dired mode, or the current buffer file to the relay point directory.
;;   If in Dired mode and files are marked, copy all marked files.
;;   If in Dired mode and on a directory with no marks, copy the directory recursively.
;;   Otherwise, copy the current buffer file."
;;     (interactive)
;;     (let ((files (if (eq major-mode 'dired-mode)
;;                      (dired-get-marked-files)
;;                    (list (buffer-file-name))))
;;           (destination-dir "/home/ywatanabe/onedrive/relay_point/"))
;;       (dolist (source files)
;;         (let ((destination (concat destination-dir (file-name-nondirectory source))))
;;           (message "Copying '%s' to '%s'" source destination)
;;           (if (file-directory-p source)
;;               (copy-directory source destination t t t)
;;             (copy-file source destination t))
;;           (message "Copied '%s' to '%s'" source destination)))))

;;   ;; Keybindings
;;   ;; (define-key dired-mode-map (kbd "RET") #'my/dired-find-alternate-file-if-directory)
;;   (define-key dired-mode-map (kbd "RET") 'dired-find-file)
;;   (define-key dired-mode-map (kbd "C-m") #'my/dired-find-alternate-file)
;;   (define-key dired-mode-map (kbd "C-c C-a") nil)
;;   (define-key dired-mode-map (kbd "S") 'dired-do-relsymlink)
;;   (define-key dired-mode-map (kbd "h") 'dired-hide-details-mode)
;;   (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
;;   (define-key dired-mode-map (kbd "C-t") 'other-window)
;;   (define-key dired-mode-map (kbd "C-i") 'image-dired-dired-toggle-marked-thumbs)
;;   (define-key dired-mode-map (kbd "S-s") 'dired-do-relsymlink)
;;   (define-key dired-mode-map (kbd "M-h") (lambda () (interactive) (my/tab-jump-to-buffer "home")))
;;   (define-key dired-mode-map (kbd "M-H") (lambda () (interactive) (my/tab-set-buffer "home")))
;;   (define-key dired-mode-map (kbd "M-s") (lambda () (interactive) (my/tab-jump-to-buffer "semi-home")))
;;   (define-key dired-mode-map (kbd "M-S") (lambda () (interactive) (my/tab-set-buffer "semi-home")))
;;   (define-key dired-mode-map (kbd "C-C C-r") 'my/copy-to-relay-point)
;;   )

;; Global keybindings
(global-set-key (kbd "C-x C-b") 'ibuffer)


(message "040-dired.el was loaded.")
