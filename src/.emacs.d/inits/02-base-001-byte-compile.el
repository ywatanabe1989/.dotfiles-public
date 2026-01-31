;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:44>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-001-byte-compile.el

;; 1. Main Compilation Functions
;; ----------------------------------------

(defun my/el-compile-recompile-all ()
  (interactive)
  (my/el-compile-delete-all)
  (my/el-compile-all))

(defun my/el-compile-all ()
  "Byte-compile all .el files in the ~/.emacs.d directory."
  (interactive)
  (dolist (file (directory-files-recursively "~/.emacs.d" "\\.el\\'"))
    (byte-compile-file file)))

;; 2. Core Functions
;; ----------------------------------------

(defun my/el-compile-buffer ()
  "Automatically compile Emacs Lisp files upon saving."
  (when (and (stringp buffer-file-name)
             (string-match "\\.el\\'" buffer-file-name))
    (let ((elc-file (concat buffer-file-name "c")))
      (condition-case err
          (progn
            (emacs-lisp-byte-compile)
            (if (file-exists-p elc-file)
                (message "Compilation successful! .elc updated at %s"
                         elc-file)
              (message
               "Compilation successful, but no .elc file found!")))
        (error
         (message "Compilation failed: %s" (error-message-string err)))))))

(defun my/el-compile-delete-all ()
  "Delete all .elc files in the ~/.emacs.d directory."
  (interactive)
  (let ((deleted-count 0))
    (dolist
        (file (directory-files-recursively "~/.emacs.d" "\\.elc\\'"))
      (delete-file file)
      (setq deleted-count (1+ deleted-count)))
    (message "Deleted %d .elc files." deleted-count)))

;; 3. Keybindings and Initialization
;; ----------------------------------------

(define-key global-map (kbd "C-c e") 'emacs-lisp-byte-compile)

;; ;; Byte compile
;; (define-key global-map (kbd "C-c e") 'emacs-lisp-byte-compile)
;; ;; (defun my/auto-compile-elisp-files ()
;; ;;   "Automatically compile Emacs Lisp files upon saving."
;; ;;   (when (and (stringp buffer-file-name)
;; ;;              (string-match "\\.el\\'" buffer-file-name))
;; ;;     (emacs-lisp-byte-compile)))
;; (defun my/el-compile-buffer ()
;;   "Automatically compile Emacs Lisp files upon saving."
;;   (when (and (stringp buffer-file-name)
;;              (string-match "\\.el\\'" buffer-file-name))
;;     (let ((elc-file (concat buffer-file-name "c")))
;;       (condition-case err
;;           (progn
;;             (emacs-lisp-byte-compile)
;;             (if (file-exists-p elc-file)
;;                 (message "Compilation successful! .elc updated at %s" elc-file)
;;               (message "Compilation successful, but no .elc file found!")))
;;         (error
;;          (message "Compilation failed: %s" (error-message-string err)))))))
;; ;; (add-hook 'emacs-lisp-mode-hook
;; ;;           (lambda ()
;; ;;             (add-hook 'after-save-hook 'my/el-compile-buffer nil t)))
;; (defun my/el-compile-delete-all ()
;;   "Delete all .elc files in the ~/.emacs.d directory."
;;   (interactive)
;;   (let ((deleted-count 0))
;;     (dolist (file (directory-files-recursively "~/.emacs.d" "\\.elc\\'"))
;;       (delete-file file)
;;       (setq deleted-count (1+ deleted-count)))
;;     (message "Deleted %d .elc files." deleted-count)))
;; (defun my/el-compile-all ()
;;   "Byte-compile all .el files in the ~/.emacs.d directory."
;;   (interactive)
;;   (dolist (file (directory-files-recursively "~/.emacs.d" "\\.el\\'"))
;;     (byte-compile-file file)))
;; (defun my/el-compile-recompile-all ()
;;   (interactive)
;;   (my/el-compile-delete-all)
;;   (my/el-compile-all)
;;   )
;; ;; find ~/.emacs.d/ -name '*.elc' | xargs rm
;; ;; find ~/.emacs.d/ -name '*.el' | xargs emacs -batch -f batch-byte-compile
;; (when (not load-file-name)
;;   (message "%s loaded." (file-name-nondirectory (or load-file-name buffer-file-name))))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-001-byte-compile)

(when
    (not load-file-name)
  (message "02-base-001-byte-compile.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))