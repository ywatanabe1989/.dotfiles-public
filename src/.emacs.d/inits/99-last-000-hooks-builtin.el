;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-10-29 06:28:14>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/99-last-000-hooks-builtin.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; Hook Definitions
;; ----------------------------------------

(defun my/before-init-hook
    ()
  "Hook run before init.el is loaded.")

(defun my/after-init-hook
    ()
  "Hook run after init.el is loaded."
  (global-flycheck-mode)
  (cua-selection-mode -1)
  (cua-mode 1)
  (delete-selection-mode 1)
  (global-set-key (kbd "<f10>") 'toggle-frame-fullscreen)
  (global-set-key (kbd "C-M-n") 'next-buffer)
  (global-set-key (kbd "C-M-p") 'previous-buffer))

(defun my/emacs-startup-hook
    ()
  "Hook run after command line processing."
  (setq inhibit-startup-screen t)
  (--my/reload-envs)
  (global-set-key (kbd "<f10>") 'toggle-frame-fullscreen))

(defun my/after-change-major-mode-hook
    ()
  "Hook run after major mode is changed.")

(defun my/window-setup-hook
    ()
  "Hook run after frame creation."
  ;; (toggle-frame-maximized)
  (require 'etm)
  ;; (etm-init)
  (etm-startup-layouts)
  ;; (etm-startup-layouts)
  )

;; Buffer Lifecycle

(defun my/find-file-hook
    ()
  ;; Auto-apply colors when opening log files
  (recentf-add-file (buffer-file-name))
  (my/ansi-colors-apply-if-match)
  "Hook run after finding a file.")

(defun my/after-save-hook
    ()
  "Hook run after saving buffer."
  (executable-make-buffer-file-executable-if-script-p)
  (--my/flash-mode-line "dark green" 2))

(defun my/kill-buffer-hook
    ()
  "Hook run before killing buffer.")

(defun my/kill-emacs-hook
    ()
  "Hook run before exiting Emacs.")

;; Window/Frame

(defun my/window-configuration-change-hook
    ()
  "Hook run when window configuration changes.")

(defun my/focus-in-hook
    ()
  "Hook run when frame gains focus.")

(defun my/focus-out-hook
    ()
  "Hook run when frame loses focus.")

;; Mode Specific

(defun my/prog-mode-hook
    ()
  "Hook run for programming modes."
  (highlight-indent-guides-mode t))

(defun my/text-mode-hook
    ()
  "Hook run for text modes.")

(defun my/conf-mode-hook
    ()
  "Hook run for configuration file modes.")

;; Special

(defun my/pre-command-hook
    ()
  "Hook run before each command.")

(defun my/post-command-hook
    ()
  "Hook run after each command.")

(defun my/minibuffer-setup-hook
    ()
  "Hook run when entering minibuffer.")

(defun my/minibuffer-exit-hook
    ()
  "Hook run when exiting minibuffer.")

;; Writing

(defun my/write-file-hook
    ()
  "Hook fix this docstring..."
  ;; (timestamp)
  )

;; Dired

(defun my/dired-mode-hook
    ()
  "Hook run when dired mode enabled"
  (recentf-add-file default-directory)
  (define-key dired-mode-map
              (kbd "C-c C-t")
              #'epc-nav-cycle-source-test-examples)
  (define-key dired-mode-map (kbd "C-M-n") 'next-buffer)
  (define-key dired-mode-map (kbd "C-M-p") 'previous-buffer)
  (define-key dired-mode-map (kbd "C-c !")
              'my/dired-shell-execute-command))

(defun my/image-mode-hook ()
  "Hook for image-mode to add enhanced viewing capabilities."
  ;; Enable mouse wheel zoom
  (local-set-key (kbd "<C-wheel-up>") 'image-increase-size)
  (local-set-key (kbd "<C-wheel-down>") 'image-decrease-size)

  ;; Additional navigation keys
  (local-set-key (kbd "n") 'image-next-file)
  (local-set-key (kbd "p") 'image-previous-file)
  (local-set-key (kbd "r") 'image-rotate)

  ;; Auto-fit to window
  (image-transform-fit-to-window)
  (recentf-add-file default-directory)

  ;; Auto revert
  (auto-revert-mode t)

  ;; Read only
  (read-only-mode t))

(defun my/project-swtich-hook
    ()
  "Hook when .git detected."
  (my/switch-project-recentf))

;; Add hooks
;; ----------------------------------------

;; Add hooks programmatically
(let
    ((hooks
      '(before-init-hook
        after-init-hook
        emacs-startup-hook
        after-change-major-mode-hook
        window-setup-hook
        find-file-hook
        after-save-hook
        kill-buffer-hook
        kill-emacs-hook
        window-configuration-change-hook
        focus-in-hook
        focus-out-hook
        prog-mode-hook
        text-mode-hook
        conf-mode-hook
        pre-command-hook
        post-command-hook
        minibuffer-setup-hook
        minibuffer-exit-hook
        dired-mode-hook
        image-mode-hook
        project-swtich-hook)))
  (dolist
      (hook hooks)
    (add-hook hook
              (intern
               (concat "my/"
                       (symbol-name hook))))))

;; ## Emacs Lifecycle Hooks
;; (In execution order)

;; - `before-init-hook` - Before init.el
;; - `after-init-hook` - After init.el
;; - `emacs-startup-hook` - After command line processing
;; - `after-change-major-mode-hook`
;; - `window-setup-hook` - After frame creation

;; ## Buffer Lifecycle
;; - `find-file-hook` - After finding a file
;; - `after-save-hook` - After saving buffer
;; - `kill-buffer-hook` - Before killing buffer
;; - `kill-emacs-hook` - Before exiting Emacs

;; ## Window/Frame
;; - `window-configuration-change-hook`
;; - `focus-in-hook` - Frame gains focus
;; - `focus-out-hook` - Frame loses focus

;; ## Mode Specific
;; - `prog-mode-hook` - Programming modes
;; - `text-mode-hook` - Text modes
;; - `conf-mode-hook` - Config file modes

;; ## Special
;; - `pre-command-hook` - Before each command
;; - `post-command-hook` - After each command
;; - `minibuffer-setup-hook` - Entering minibuffer
;; - `minibuffer-exit-hook` - Exiting minibuffer

;; Emacs Lifecycle


(provide '99-last-000-hooks-builtin)

(when
    (not load-file-name)
  (message "99-last-000-hooks-builtin.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))