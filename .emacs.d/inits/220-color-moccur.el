;; -*- lexical-binding: t -*-

(use-package color-moccur
  :ensure t  ; Ensure the package is installed (optional, requires `use-package` to be configured with package installation support)
  :bind ("M-o" . occur-by-moccur)  ; Global key binding
  :config
  (setq moccur-split-word t)  ; Enable split word searching
  ;; Add patterns to the exclusion list
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$"))



(message "220-color-moccur.el was loaded.")
