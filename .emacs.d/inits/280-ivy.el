(use-package ivy
  :ensure t
  :demand t
  :diminish ivy-mode
  :config
  ;; (ivy-mode 1)
  ;; (counsel-mode nil)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-use-selectable-prompt t)
  ;; (setq ivy-ignore-buffers '(\\` " "\\`\\*magit"))
  (setq ivy-re-builders-alist '(
                                (t . ivy--regex-ignore-order)
                                ))
  (setq ivy-height 10)
  ;; (setq counsel-find-file-at-point t)
  (setq ivy-count-format "(%d/%d) ")
  )

;; too slow
;; (with-eval-after-load 'counsel
;;   (counsel-mode -1))
;; (counsel-mode nil)

;; (package-delete 'counsel)

(define-key global-map (kbd "C-c C-c") 'completion-at-point)





;; (use-package counsel
;;   :ensure t
;;   :bind (
;;          ;; ("C-x C-b" . ivy-switch-buffer)
;;          ("C-x b" . ivy-switch-buffer)
;;          ("M-r" . counsel-ag)
;;          ("C-x C-d" . counsel-dired)
;;          ("C-x d" . counsel-dired)
;;          )
;;   :diminish
;;   :config
;;   (global-set-key [remap org-set-tags-command] #'counsel-org-tag))

;; (use-package swiper
;;   :ensure t
;;   :bind(("M-C-s" . swiper)))

;; (use-package ivy-hydra)
