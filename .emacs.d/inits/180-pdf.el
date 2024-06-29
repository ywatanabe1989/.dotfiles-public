;; -*- lexical-binding: t -*-

;; https://tam5917.hatenablog.com/entry/2021/12/28/140732

;; Setup pdf-tools with continuous view mode
(use-package pdf-tools
  :ensure t
  :config
  (setq pdf-view-continuous t)
  (add-hook 'after-init-hook 'pdf-tools-install))

(add-hook 'pdf-view-mode-hook (lambda () (display-line-numbers-mode -1)))

;; Keybindings for PDF view scaling

(defun my/pdf-view-scale-reset ()
  (interactive)
  (pdf-view-scale-reset)
  (pdf-view-fit-width-to-window)
  )

(defun my/pdf-view-shrink ()
  (interactive)
  (pdf-view-shrink 1.1)
  (pdf-view-fit-width-to-window)
  )

(defun my/pdf-view-enlarge ()
  (interactive)
  (pdf-view-enlarge 1.1)
  (pdf-view-fit-width-to-window)
  )

(define-key pdf-view-mode-map (kbd "r") 'pdf-view-reload)
(define-key pdf-view-mode-map (kbd "f") 'pdf-view-fit-width-to-window)

(define-key pdf-view-mode-map (kbd "C-0") 'my/pdf-view-scale-reset)
(define-key pdf-view-mode-map (kbd "C--") 'my/pdf-view-shrink)
(define-key pdf-view-mode-map (kbd "C-+") 'my/pdf-view-enlarge)

(defun my/pdf-view-toggle-midnight-mode ()
  "Toggle midnight mode in PDF View with custom colors."
  (interactive)
  (if (eq pdf-view-midnight-minor-mode nil)
      (progn
        ;; (setq pdf-view-midnight-colors '("#ffffff" . "#333333")) ; light grey on black
        (setq pdf-view-midnight-colors '("#000000" . "#777777")) ; light grey on black        
        (pdf-view-midnight-minor-mode 1))
    (progn
      (setq pdf-view-midnight-colors '("#000000" . "#ffffff")) ; back to normal
      (pdf-view-midnight-minor-mode -1))))

(define-key pdf-view-mode-map (kbd "C-d") 'my/pdf-view-toggle-midnight-mode)
;; (define-key pdf-view-mode-map (kbd "C-d") 'my/pdf-toggle-dark-mode)

;; (define-key pdf-view-mode-map (kbd "C-d") 'pdf-view-midnight-minor-mode)

;; (define-key pdf-view-mode-map (kbd "C-d") 'my/toggle-dark-mode)

;; C-c C-r m – or M-x pdf-view-midnight-minor-mode

;; ;; (require 'pdf-tools)
;; ;; (setq pdf-view-continuous t)
;; (use-package pdf-tools
;;   :config
;;   (setq pdf-view-continuous t)
;;   )

;; ;; sudo apt install libpng-dev zlib1g-dev
;; ;; sudo apt install libpoppler-glib-dev
;; ;; sudo apt install libpoppler-private-dev

;; ;; (exec-path-from-shell-initialize)
;; ;; (exec-path-from-shell-copy-env "PATH")
;; (add-hook 'after-init-hook
;;           (lambda ()
;;             (pdf-tools-install)))



;; C-0 original size
;; C--
;; C-+
