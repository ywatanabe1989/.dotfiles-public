;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2026-01-27 08:55:43>
;;; File: /home/ywatanabe/.dotfiles/src/.emacs.d/inits/03-ui-000-dired-keybindings-hooks.el

;;; Copyright (C) 2026 Yusuke Watanabe (ywatanabe@scitex.ai)


;; Fixed dired-do-relsymlink that uses file-truename
;; ----------------------------------------
;; The built-in dired-do-relsymlink calculates relative paths using logical
;; paths (through symlinks), but the OS resolves symlinks using physical paths.
;; This causes broken symlinks when the current directory is itself a symlink.

;; (defun my/dired-do-relsymlink (&optional arg)
;;   "Make relative symbolic links using physical paths (file-truename).
;; This fixes the issue where relative symlinks break when the current
;; directory is accessed through a symlink.
;; Prompts for target directory like the original `dired-do-relsymlink'."
;;   (interactive "P")
;;   (let* ((files (dired-get-marked-files nil arg))
;;          (num-files (length files))
;;          (default-target (dired-dwim-target-directory))
;;          (target-input (read-directory-name
;;                         (format "Relative symlink %d file(s) to: "
;; 				num-files)
;;                         default-target default-target))
;;          target-dir created skipped)
;;     ;; Validate input is a directory
;;     (setq target-input (expand-file-name target-input))
;;     (unless (file-directory-p target-input)
;;       (user-error "Not a directory: %s" target-input))
;;     (setq target-dir (file-truename target-input))
;;     (setq created 0)
;;     (setq skipped 0)
;;     ;; Confirm before proceeding
;;     (when (yes-or-no-p
;;            (format "Create %d relative symlink(s) in %s? "
;;                    num-files target-dir))
;;       (dolist (file files)
;;         (let* ((file-true (file-truename file))
;;                (source-dir (file-truename (file-name-directory file)))
;;                (link-name (file-name-nondirectory file))
;;                (link-path (expand-file-name link-name target-dir)))
;;           ;; Skip if source and target would be the same (prevents recursive symlink)
;;           (if (string= source-dir target-dir)
;;               (progn
;;                 (message
;;                  "Skipping %s: source and target directory are the same"
;;                  link-name)
;;                 (cl-incf skipped))
;;             (let
;; 		((relative-path
;; 		  (file-relative-name file-true target-dir)))
;;               (make-symbolic-link relative-path link-path t)
;;               (cl-incf created)))))
;;       (message "Created %d symlink(s), skipped %d" created skipped)
;;       (revert-buffer))))

;; Key Bindings
;; ----------------------------------------

(defun my/dired-bindkeys ()
  "Set up my custom keybindings for dired mode."
  (define-key dired-mode-map (kbd "T") 'my/dired-touch)
  (define-key dired-mode-map (kbd "C-c C-p")
              'my/dired-copy-the-selected-file)
  (define-key dired-mode-map (kbd "C-S-g") 'my/rg-search)
  (define-key dired-mode-map (kbd "C-c v") #'my/dired-im2vid)
  (define-key dired-mode-map (kbd "RET")
              'dired-find-file-revert-buffer)
  (define-key dired-mode-map (kbd "R") 'dired-do-rename)
  (define-key dired-mode-map (kbd "C-c C-t")
              'epc-nav-cycle-source-test-examples)
  (define-key dired-mode-map (kbd "C-c z") #'my/dired-zip)
  (define-key dired-mode-map (kbd "C-c c") #'dcc-run)
  (define-key dired-mode-map (kbd "C-c C-a") nil)
  (define-key dired-mode-map (kbd "S") 'dired-do-relsymlink)
  (define-key dired-mode-map (kbd "h") 'my/dired-toggle-details)
  (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
  (define-key dired-mode-map (kbd "C-t") 'other-window)
  (define-key dired-mode-map (kbd "C-i")
              'image-dired-dired-toggle-marked-thumbs)
  (define-key dired-mode-map (kbd "S-s") 'dired-do-relsymlink)
  (define-key dired-mode-map (kbd "C-c 1") 'etm-jump-to-home-1)
  (define-key dired-mode-map (kbd "C-c 2") 'etm-jump-to-home-2)
  (define-key dired-mode-map (kbd "C-c 3") 'etm-jump-to-home-3)
  (define-key dired-mode-map (kbd "C-c 4") 'etm-jump-to-home-4)
  (define-key dired-mode-map (kbd "C-c 5") 'etm-jump-to-home-5)
  (define-key dired-mode-map (kbd "C-c 6") 'etm-jump-to-home-6)
  (define-key dired-mode-map (kbd "C-c 7") 'etm-jump-to-home-7)
  (define-key dired-mode-map (kbd "C-c 8") 'etm-jump-to-home-8)
  (define-key dired-mode-map (kbd "C-c 9") 'etm-jump-to-home-9)
  (define-key dired-mode-map (kbd "C-c r") 'my/copy-to-win-downloads)
  (define-key dired-mode-map (kbd "C-c p") #'my/dired-apply-pim)
  (define-key dired-mode-map (kbd "C-M-p") #'--my/vterm-prev)
  (define-key dired-mode-map (kbd "C-M-n") #'--my/vterm-next)
  (define-key dired-mode-map (kbd "C-c e") #'my/dired-open-in-explorer)
  (define-key dired-mode-map (kbd "M-1") #'etm-navigation-jump-to-1)
  (define-key dired-mode-map (kbd "M-2") #'etm-navigation-jump-to-2)
  (define-key dired-mode-map (kbd "M-3") #'etm-navigation-jump-to-3)
  (define-key dired-mode-map (kbd "M-4") #'etm-navigation-jump-to-4)
  (define-key dired-mode-map (kbd "M-5") #'etm-navigation-jump-to-5)
  (define-key dired-mode-map (kbd "M-6") #'etm-navigation-jump-to-6)
  (define-key dired-mode-map (kbd "M-7") #'etm-navigation-jump-to-7)
  (define-key dired-mode-map (kbd "M-8") #'etm-navigation-jump-to-8)
  (define-key dired-mode-map (kbd "M-9") #'etm-navigation-jump-to-9))

;; Hooks
;; ----------------------------------------
(add-hook 'dired-mode-hook
          (lambda
            ()
            (dired-omit-mode t)
            (dired-hide-details-mode t)
            (setq truncate-lines t))
          (my/dired-bindkeys))


(provide '03-ui-000-dired-keybindings-hooks)

(when
    (not load-file-name)
  (message "03-ui-000-dired-keybindings-hooks.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))