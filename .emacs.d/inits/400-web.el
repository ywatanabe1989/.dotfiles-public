(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(setq web-mode-content-types-alist
  '(("jsx" . "\\.tsx\\'")))

(message "400-web.el was loaded.")
