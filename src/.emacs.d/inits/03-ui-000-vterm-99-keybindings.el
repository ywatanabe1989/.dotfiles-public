;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-12-20 20:58:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-vterm-99-keybindings.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

;; Debug flag
;; ----------------------------------------

(defvar my/vterm-keybindings-debug nil
  "When non-nil, print debug messages for vterm keybinding setup.")

;; Main
;; ----------------------------------------

(defun --my/vterm-bind-keys ()
  "Set up all keybindings for vterm mode."
  (interactive)
  (--my/vterm-bind-keys-global)
  (--my/vterm-bind-keys-core-emacs)
  (--my/vterm-bind-keys-kill-yank)
  (--my/vterm-bind-keys-region)
  ;; (--my/vterm-bind-keys-special)
  (--my/vterm-bind-keys-tab-jumping)
  (--my/vterm-bind-keys-special-jumping)
  (--my/vterm-bind-keys-copy-mode)
  (--my/vterm-bind-keys-buffer-navigation)
  (--my-vterm-bind-keys-advanced)
  (--my/vterm-bind-keys-mouse)
  ;; (--my/vterm-bind-keys-claude)
  )

;; Helpers
;; ----------------------------------------

;; Helper to define keys in both modes

(defun --my/vterm-define-key-in-both-mode-maps (key command)
  "Define KEY to run COMMAND in both `vterm-mode-map` and `vterm-copy-mode-map`."
  (define-key vterm-mode-map (kbd key) command)
  (define-key vterm-copy-mode-map (kbd key) command))

(defun --my/vterm-define-mouse-key-in-both-mode-maps (key command)
  "Define mouse KEY (vector) to run COMMAND in both `vterm-mode-map` and `vterm-copy-mode-map`."
  (when my/vterm-keybindings-debug
    (message "  Binding %s -> %s in both maps" key command))
  (define-key vterm-mode-map key command)
  (define-key vterm-copy-mode-map key command))

(defun --my/vterm-bind-keys-core-emacs ()
  "Setup core Emacs keybindings for vterm."
  ;; NOTE: Mouse unbinding/rebinding is handled entirely by --my/vterm-bind-keys-mouse
  ;; C-l: Clear screen (fixes half-cleared issue by using vterm-clear)
  (--my/vterm-define-key-in-both-mode-maps "C-l" #'vterm-clear)
  ;; TAB: Ensure tab completion works (esp. for IPython)
  (--my/vterm-define-key-in-both-mode-maps "TAB" #'vterm-send-tab)
  (--my/vterm-define-key-in-both-mode-maps "<tab>" #'vterm-send-tab)
  (--my/vterm-define-key-in-both-mode-maps "M-x" nil)
  (--my/vterm-define-key-in-both-mode-maps "M-RET" nil)
  (--my/vterm-define-key-in-both-mode-maps "M-RET" 'whisper-live-run)
  (--my/vterm-define-key-in-both-mode-maps "M-p" nil)
  (--my/vterm-define-key-in-both-mode-maps "C-x" nil)
  (--my/vterm-define-key-in-both-mode-maps "<f7>" nil)
  (--my/vterm-define-key-in-both-mode-maps "<f8>" nil)
  (--my/vterm-define-key-in-both-mode-maps "<f9>" nil)
  (--my/vterm-define-key-in-both-mode-maps "<f10>" nil)
  (--my/vterm-define-key-in-both-mode-maps "<escape>"
                                           `vterm-send-escape)
  (--my/vterm-define-key-in-both-mode-maps "M-<left>" nil)
  (--my/vterm-define-key-in-both-mode-maps "M-<right>" nil)
  (--my/vterm-define-key-in-both-mode-maps "M-<up>" nil)
  (--my/vterm-define-key-in-both-mode-maps "M-<down>" nil)

  ;; C-c is often used as a prefix or interrupt, handle specifically
  ;; (define-key vterm-mode-map (kbd "C-c") nil) ;; Pass C-c through if needed
  (--my/vterm-define-key-in-both-mode-maps "C-M-g" nil)
  (--my/vterm-define-key-in-both-mode-maps "C-t" nil)
  (--my/vterm-define-key-in-both-mode-maps "M-t" nil)
  ;; M-w and C-w are often copy/kill region, handled below
  (--my/vterm-define-key-in-both-mode-maps "M-w" nil)
  ;; M-p and M-n are rebound for prompt jumping
  (--my/vterm-define-key-in-both-mode-maps "M-p"
                                           #'my/vterm-jump-to-prev-ps1)
  (--my/vterm-define-key-in-both-mode-maps "M-n"
                                           #'my/vterm-jump-to-next-ps1)
  (--my/vterm-define-key-in-both-mode-maps "C-c C-k"
                                           #'my/vterm-clear-buffer)
  (--my/vterm-define-key-in-both-mode-maps "C-c C-l"
                                           #'my/vterm-goto-max)
  (--my/vterm-define-key-in-both-mode-maps "C-c C-y"
                                           'ecc-vterm-yank-as-file)
  (--my/vterm-define-key-in-both-mode-maps "C-c C-b"
                                           '--my/vterm-yank-as-file-both-text-and-image)

  (--my/vterm-define-key-in-both-mode-maps "C-S-p" '--my/vterm-prev)
  (--my/vterm-define-key-in-both-mode-maps "C-S-n" '--my/vterm-next)
  (--my/vterm-define-key-in-both-mode-maps "C-c C-a"
                                           'ecc-auto-toggle)
  (--my/vterm-define-key-in-both-mode-maps "M-1" nil)
  (--my/vterm-define-key-in-both-mode-maps "M-2" nil)
  (--my/vterm-define-key-in-both-mode-maps "M-3" nil)
  (--my/vterm-define-key-in-both-mode-maps "M-4" nil)
  (--my/vterm-define-key-in-both-mode-maps "M-5" nil)
  (--my/vterm-define-key-in-both-mode-maps "M-6" nil)
  (--my/vterm-define-key-in-both-mode-maps "M-7" nil)
  (--my/vterm-define-key-in-both-mode-maps "M-8" nil)
  (--my/vterm-define-key-in-both-mode-maps "M-9" nil)
  (--my/vterm-define-key-in-both-mode-maps "M-o" nil))

(defun --my/vterm-bind-keys-global ()
  "Setup core Emacs keybindings for vterm."
  (global-set-key (kbd "C-c p") '--my/vterm-prev)
  (global-set-key (kbd "C-c n") '--my/vterm-next)
  (global-set-key (kbd "C-S-m") '--my/vterm-new-there)
  (global-set-key (kbd "C-S-a") '--my/vterm-new))

(defun --my/vterm-bind-keys-kill-yank ()
  "Setup kill and yank functionality in vterm."
  (--my/vterm-define-key-in-both-mode-maps "C-k"
                                           #'--my/vterm-kill-line)
  (--my/vterm-define-key-in-both-mode-maps "C-y" #'--my/vterm-yank))

(defun --my/vterm-bind-keys-region ()
  "Setup region operations and mode toggling in vterm."
  ;; C-SPC (set-mark-command) only makes sense in copy mode
  ;; (define-key vterm-mode-map (kbd "C-SPC") #'--my/vterm-set-mark-command) ;; If custom logic needed for vterm-mode
  (define-key vterm-copy-mode-map (kbd "C-SPC") #'set-mark-command)
  ;; C-; toggles between copy mode and regular vterm mode
  (--my/vterm-define-key-in-both-mode-maps "C-;"
                                           #'--my/vterm-toggle-mode))

(defun --my/vterm-bind-keys-tab-jumping ()
  "Setup tab jumping keys in vterm using etm."
  (define-key vterm-mode-map (kbd "C-c 1") 'etm-jump-to-home-1)
  (define-key vterm-mode-map (kbd "C-c 2") 'etm-jump-to-home-2)
  (define-key vterm-mode-map (kbd "C-c 3") 'etm-jump-to-home-3)
  (define-key vterm-mode-map (kbd "C-c 4") 'etm-jump-to-home-4)
  (define-key vterm-mode-map (kbd "C-c 5") 'etm-jump-to-home-5)
  (define-key vterm-mode-map (kbd "C-c 6") 'etm-jump-to-home-6)
  (define-key vterm-mode-map (kbd "C-c 7") 'etm-jump-to-home-7)
  (define-key vterm-mode-map (kbd "C-c 8") 'etm-jump-to-home-8)
  (define-key vterm-mode-map (kbd "C-c 9") 'etm-jump-to-home-9)
  (define-key vterm-mode-map (kbd "M-1") #'etm-navigation-jump-to-1)
  (define-key vterm-mode-map (kbd "M-2") #'etm-navigation-jump-to-2)
  (define-key vterm-mode-map (kbd "M-3") #'etm-navigation-jump-to-3)
  (define-key vterm-mode-map (kbd "M-4") #'etm-navigation-jump-to-4)
  (define-key vterm-mode-map (kbd "M-5") #'etm-navigation-jump-to-5)
  (define-key vterm-mode-map (kbd "M-6") #'etm-navigation-jump-to-6)
  (define-key vterm-mode-map (kbd "M-7") #'etm-navigation-jump-to-7)
  (define-key vterm-mode-map (kbd "M-8") #'etm-navigation-jump-to-8)
  (define-key vterm-mode-map (kbd "M-9") #'etm-navigation-jump-to-9))

(defun --my/vterm-bind-keys-special-jumping ()
  "Setup special jumping keys in vterm."
  (define-key vterm-mode-map (kbd "M-h")
              (lambda () (interactive)
                (--my/vterm-jump-by-buffer-type "home")))
  (define-key vterm-mode-map (kbd "M-s")
              (lambda () (interactive)
                (--my/vterm-jump-by-buffer-type "semi-home")))
  (define-key vterm-mode-map (kbd "M-r")
              (lambda () (interactive)
                (--my/vterm-jump-by-buffer-type "results"))))

(defun --my/vterm-bind-keys-copy-mode ()
  "Setup copy mode specific bindings."
  (define-key vterm-copy-mode-map (kbd "C-SPC") #'set-mark-command)
  (define-key vterm-copy-mode-map (kbd "C-;")
              #'--my/vterm-toggle-mode))

(defun --my/vterm-bind-keys-buffer-navigation ()
  "Setup buffer navigation bindings."
  ;; Vterm Buffer
  (--my/vterm-define-key-in-both-mode-maps "C-M-p"
                                           #'--my/vterm-prev)
  (--my/vterm-define-key-in-both-mode-maps "C-M-n"
                                           #'--my/vterm-next)

  ;; PS1
  (--my/vterm-define-key-in-both-mode-maps "M-p"
                                           #'my/vterm-jump-to-prev-ps1)
  (--my/vterm-define-key-in-both-mode-maps "M-n"
                                           #'my/vterm-jump-to-next-ps1))

(defun --my-vterm-bind-keys-advanced ()
  "Set up advanced keybindings for vterm mode."
  (define-key vterm-mode-map (kbd "M-o")
              #'my/vterm-toggle-optimization))

(defun --my/vterm-bind-keys-mouse ()
  "Set up mouse keybindings for vterm mode.
Uses `my/vterm-right-click' from 03-ui-000-vterm-00-mouse.el for click counting."
  ;; (message ">>> --my/vterm-bind-keys-mouse called <<<")
  ;; (message "  my/vterm-right-click defined: %s" (fboundp 'my/vterm-right-click))
  ;; Disable context-menu-mode locally in vterm
  (when (bound-and-true-p context-menu-mode)
    ;; (message "  Disabling context-menu-mode locally")
    (setq-local context-menu-mode nil))
  ;; Set mouse bindings in both maps
  (--my/vterm-define-mouse-key-in-both-mode-maps [mouse-3] #'ignore)
  (--my/vterm-define-mouse-key-in-both-mode-maps [down-mouse-3]
                                                 #'my/vterm-right-click)
  (--my/vterm-define-mouse-key-in-both-mode-maps [double-mouse-3]
                                                 #'ignore)
  (--my/vterm-define-mouse-key-in-both-mode-maps [double-down-mouse-3]
                                                 #'my/vterm-right-click)
  (--my/vterm-define-mouse-key-in-both-mode-maps [triple-mouse-3]
                                                 #'ignore)
  (--my/vterm-define-mouse-key-in-both-mode-maps [triple-down-mouse-3]
                                                 #'my/vterm-right-click)
  (--my/vterm-define-mouse-key-in-both-mode-maps [menu] nil)
  (--my/vterm-define-mouse-key-in-both-mode-maps [context-menu] nil)
  ;; (message "  [down-mouse-3] now bound to: %s" (lookup-key vterm-mode-map [down-mouse-3]))
  ;; (message ">>> --my/vterm-bind-keys-mouse done <<<")
  )

;; (defun --my/vterm-bind-keys-claude ()
;;   "Set up keybindings for Claude vterm mode."
;;   (when (fboundp 'ecc-term-claude-mode)
;;     ;; Apply all the standard vterm bindings to Claude vterm mode
;;     (let ((vterm-mode-map ecc-term-claude-mode-map))
;;       (--my/vterm-bind-keys-core-emacs)
;;       (--my/vterm-bind-keys-kill-yank)
;;       (--my/vterm-bind-keys-region)
;;       (--my/vterm-bind-keys-tab-jumping)
;;       (--my/vterm-bind-keys-special-jumping)
;;       (--my/vterm-bind-keys-copy-mode)
;;       (--my/vterm-bind-keys-buffer-navigation))

;;     ;; Add any Claude-specific bindings
;;     (define-key ecc-term-claude-mode-map (kbd "C-c a")
;;                 'emacs-claude-code-toggle)
;;     ;; Any other Claude-specific keybindings
;;     ))

;; Add hook for Claude mode
(with-eval-after-load 'ecc-term-claude-mode
  (add-hook 'ecc-term-claude-mode-hook #'--my/vterm-bind-keys))

;; Setup bindings after vterm is loaded
(with-eval-after-load 'vterm
  (when my/vterm-keybindings-debug
    (message
     ">>> with-eval-after-load 'vterm: setting up keybindings <<<"))
  ;; Set bindings immediately
  (--my/vterm-bind-keys)
  ;; Set bindings when vterm-mode is entered
  (add-hook 'vterm-mode-hook #'--my/vterm-bind-keys)
  ;; Set bindings when vterm-copy-mode is entered/exited
  (add-hook 'vterm-copy-mode-hook #'--my/vterm-bind-keys-mouse)
  (when my/vterm-keybindings-debug
    (message
     ">>> Hooks added: vterm-mode-hook, vterm-copy-mode-hook <<<")))

(provide '03-ui-000-vterm-99-keybindings)

(when
    (not load-file-name)
  (message "03-ui-000-vterm-99-keybindings.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))
