;; better candidate filtering
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(message "240-orderless.el was loaded.")
