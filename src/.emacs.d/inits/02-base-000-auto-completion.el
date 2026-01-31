;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:41>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-000-auto-completion.el

;;; Copyright (C) 2024-2025 Yusuke Watanabe (ywatanabe@scitex.ai)

;; (use-package tempel
;;   :ensure t
;;   ;; :bind (("M-+" . tempel-complete)
;;   ;;        ("M-*" . tempel-insert))
;;   :custom
;;   (tempel-trigger-prefix "<"))

;; (use-package hippie-exp
;;   :bind ([remap dabbrev-expand] . hippie-expand)
;;   :commands (hippie-expand)
;;   :custom
;;   (dabbrev-ignored-buffer-regexps '("\\.\\(?:pdf\\|jpe?g\\|png\\)\\'"))
;;   (dabbrev-upcase-means-case-search t)
;;   :config
;;   (setopt hippie-expand-try-functions-list
;;           '(tempel-expand
;;             try-expand-all-abbrevs
;;             try-expand-dabbrev
;;             try-expand-dabbrev-all-buffers
;;             try-expand-dabbrev-from-kill
;;             try-complete-lisp-symbol-partially
;;             try-complete-lisp-symbol
;;             try-complete-file-name-partially
;;             try-complete-file-name)))

;;;; Code Completion

(use-package corfu
  :disabled
  :ensure t
  ;; Optional customizations
  :custom
  (corfu-cycle t)
                                        ; Allows cycling through candidates
  (corfu-auto t)
                                        ; Enable auto completion
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.1)
  (corfu-popupinfo-delay
   '(0.5 . 0.2))
  (corfu-preview-current 'insert)
                                        ; insert previewed candidate
  (corfu-preselect 'prompt)
  (corfu-on-exact-match nil)
                                        ; Don't auto expand tempel snippets
  ;; Optionally use TAB for cycling, default is `corfu-complete'.
  :bind
  (:map corfu-map
        ("M-SPC"      . corfu-insert-separator)
        ("TAB"        . corfu-next)
        ([tab]
         . corfu-next)
        ("S-TAB"      . corfu-previous)
        ([backtab]
         . corfu-previous)
        ("S-<return>" . corfu-insert)
        ("RET"        . nil))

  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode))

(use-package company)

(global-company-mode 1)

(global-set-key
 (kbd "C-c C-;")
 'company-complete)

(use-package orderless
  :ensure
  t
  :init
  (setq completion-styles
        '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides
        '((file
           (styles .
                   (partial-completion)))
          (command
           (styles .
                   (basic orderless)))
          (variable
           (styles .
                   (basic orderless)))
          (symbol
           (styles .
                   (basic orderless))))
        orderless-component-separator
        #'orderless-escapable-split-on-space
        orderless-matching-styles
        '(orderless-literal
          orderless-prefixes
          orderless-initialism
          orderless-regexp)))

(use-package vertico)

;; (package-install 'vertico "0.29.1")

;; ----------------------------------------
;; CRAFTED
;; ----------------------------------------
;; (use-package vertico)
;; (use-package marginalia)
;; (use-package orderless)
;; (use-package embark)
;; (use-package embark-consult)
;; (use-package corf)
;; (use-package cape)

;; ;;; Vertico
;; (when
;;     (require 'vertico nil :noerror)
;;   (require 'vertico-directory)
;;   ;; Cycle back to top/bottom result when the edge is reached
;;   (customize-set-variable 'vertico-cycle t)

;;   ;; Start Vertico
;;   (vertico-mode 1)

;;   ;; Turn off the built-in fido-vertical-mode and icomplete-vertical-mode, if
;;   ;; they have been turned on by crafted-defaults-config, because they interfere
;;   ;; with this module.
;;   (with-eval-after-load 'crafted-defaults-config
;;     (fido-mode -1)
;;     (fido-vertical-mode -1)
;;     (icomplete-mode -1)
;;     (icomplete-vertical-mode -1)))

;; 
;; ;;; Marginalia
;; (when
;;     (require 'marginalia nil :noerror)
;;   ;; Configure Marginalia
;;   (customize-set-variable 'marginalia-annotators
;;                           '(marginalia-annotators-heavy
;;                             marginalia-annotators-light
;;                             nil))
;;   (marginalia-mode 1))

;; 
;; ;;; Consult
;; ;; Since Consult doesn't need to be required, we assume the user wants these
;; ;; setting if it is installed (regardless of the installation method).
;; (when
;;     (locate-library "consult")
;;   ;; Set some consult bindings
;;   (keymap-global-set "C-s" 'consult-line)
;;   (keymap-set minibuffer-local-map "C-r" 'consult-history)

;;   (setq completion-in-region-function #'consult-completion-in-region))

;; 
;; ;;; Orderless
;; (when
;;     (require 'orderless nil :noerror)
;;   ;; Set up Orderless for better fuzzy matching
;;   (customize-set-variable 'completion-styles
;;                           '(orderless basic))
;;   (customize-set-variable 'completion-category-overrides
;;                           '((file
;;                              (styles .
;;                                      (partial-completion))))))

;; 
;; ;;; Embark
;; (when
;;     (require 'embark nil :noerror)

;;   (keymap-global-set "<remap> <describe-bindings>" #'embark-bindings)
;;   (keymap-global-set "C-." 'embark-act)

;;   ;; Use Embark to show bindings in a key prefix with `C-h`
;;   (setq prefix-help-command #'embark-prefix-help-command)

;;   (when
;;       (require 'embark-consult nil :noerror)
;;     (with-eval-after-load 'embark-consult
;;       (add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode))))

;; 
;; ;;; Corfu
;; (when
;;     (require 'corfu nil :noerror)

;;   (unless
;;       (display-graphic-p)
;;     (when
;;         (require 'corfu-terminal nil :noerror)
;;       (corfu-terminal-mode +1)))

;;   ;; Setup corfu for popup like completion
;;   (customize-set-variable 'corfu-cycle t)
;;                                         ; Allows cycling through candidates
;;   (customize-set-variable 'corfu-auto t)
;;                                         ; Enable auto completion
;;   (customize-set-variable 'corfu-auto-prefix 2)
;;                                         ; Complete with less prefix keys
;;   (global-corfu-mode 1)
;;   (when
;;       (require 'corfu-popupinfo nil :noerror)

;;     (corfu-popupinfo-mode 1)
;;     (eldoc-add-command #'corfu-insert)
;;     (keymap-set corfu-map "M-p" #'corfu-popupinfo-scroll-down)
;;     (keymap-set corfu-map "M-n" #'corfu-popupinfo-scroll-up)
;;     (keymap-set corfu-map "M-d" #'corfu-popupinfo-toggle)))

;; 
;; ;;; Cape

;; (when
;;     (require 'cape nil :noerror)
;;   ;; Setup Cape for better completion-at-point support and more
;;   ;; Add useful defaults completion sources from cape
;;   (add-to-list 'completion-at-point-functions #'cape-file)
;;   (add-to-list 'completion-at-point-functions #'cape-dabbrev)

;;   ;; Silence the pcomplete capf, no errors or messages!
;;   ;; Important for corfu
;;   (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)

;;   ;; Ensure that pcomplete does not write to the buffer
;;   ;; and behaves as a pure `completion-at-point-function'.
;;   (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-purify)

;;   ;; No auto-completion or completion-on-quit in eshell
;;   (defun crafted-completion-corfu-eshell
;;       ()
;;     "Special settings for when using corfu with eshell."
;;     (setq-local corfu-quit-at-boundary t
;;                 corfu-quit-no-match t
;;                 corfu-auto nil)
;;     (corfu-mode))
;;   (add-hook 'eshell-mode-hook #'crafted-completion-corfu-eshell))

;; ;; (add-to-list 'package-selected-packages 'cape)
;; ;; (add-to-list 'package-selected-packages 'consult)
;; ;; (add-to-list 'package-selected-packages 'corfu)
;; ;; (add-to-list 'package-selected-packages 'corfu-terminal)
;; ;; (add-to-list 'package-selected-packages 'embark)
;; ;; (add-to-list 'package-selected-packages 'embark-consult)
;; ;; (add-to-list 'package-selected-packages 'marginalia)
;; ;; (add-to-list 'package-selected-packages 'orderless)
;; ;; (add-to-list 'package-selected-packages 'vertico)

;; ;; - `cape`: Provides Completion At Point Extensions
;; ;; - `consult`: Advanced commands based on the Emacs completion function
;; ;; - `corfu`: Completion Overlay Region FUnction - compact completion popup UI
;; ;; - `corfu-terminal`: Terminal support for Corfu
;; ;; - `embark`: Context-sensitive actions for Emacs
;; ;; - `embark-consult`: Integration between Embark and Consult
;; ;; - `marginalia`: Extra information in minibuffer completions
;; ;; - `orderless`: Flexible completion style that matches in any order
;; ;; - `vertico`: Vertical interactive completion UI

(when
    (not load-file-name)
  (message "02-base-000-auto-completion.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-000-auto-completion)

(when
    (not load-file-name)
  (message "02-base-000-auto-completion.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))