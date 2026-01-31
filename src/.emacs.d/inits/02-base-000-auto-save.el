;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:41>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-000-auto-save.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-08 11:27:21 (ywatanabe)>
;;; File: ./.dotfiles/.emacs.d/inits/000-auto-save.el

;; Disables autosave
(setq auto-save-default nil)

;; Auto save
(setq auto-save-timeout 5)
(setq auto-save-interval 60)

(defun my/mv-or-write-file (tgt)
  "Move or write file based on the directory.

If tgt is in the same directory, move the file.
Otherwise, write the file to the new target."
  (interactive "FMove or write file to: ")
  (let ((current-file (buffer-file-name)))
    (if (not current-file)
        (error "Buffer is not visiting a file"))
    (let ((current-dir (file-name-directory current-file))
          (target-dir (file-name-directory tgt)))
      (if (string= current-dir target-dir)
          (let
              ((new-file
                (concat current-dir (file-name-nondirectory tgt))))
            (rename-file current-file new-file)
            (set-visited-file-name new-file)
            (set-buffer-modified-p nil)
            (message "File moved to %s" new-file))
        (write-file tgt)
        (message "File written to %s" tgt)))))

(global-set-key (kbd "C-x C-w") 'my/mv-or-write-file)

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

;; ;; Auto Saving Dir
;; (setq auto-save-file-name-transforms
;;       `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))
;; Disables autosave
(setq auto-save-default nil)
;; Auto save
(setq auto-save-timeout 5)
(setq auto-save-interval 60)

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-000-auto-save)

(when
    (not load-file-name)
  (message "02-base-000-auto-save.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))