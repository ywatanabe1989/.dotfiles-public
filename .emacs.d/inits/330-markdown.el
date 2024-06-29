(use-package markdown-mode
  :mode ("\\.md\\'" . gfm-mode)
  :config
  (setq markdown-command "/usr/bin/pandoc")
  (setq markdown-open-command "/usr/bin/pandoc")
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))
  ;; (unbind-key "C-c C-a" markdown-mode-map))
  (define-key markdown-mode-map (kbd "C-t") 'my/org-agenda)

  ;; Set 4 spaces for indentation
  (setq markdown-indent-on-enter 'indent-and-new-item)
  (setq markdown-indent-function 'markdown-indent-line)
  (setq markdown-list-indent-width 4)
  (setq markdown-asymmetric-header t)

  ;; Set tab width to 4
  (setq tab-width 4)
  (setq-default tab-width 4)

  ;; Use spaces instead of tabs
  (setq-default indent-tabs-mode nil))

;; (use-package markdown-mode
;;   :mode ("\\.md\\'" . gfm-mode)
;;   :config
;;   (setq markdown-command "/usr/bin/pandoc")
;;   (setq markdown-open-command "/usr/bin/pandoc")
;;   (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
;;   (add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))
;;   (define-key markdown-mode-map (kbd "C-t") 'my/org-agenda))

(use-package mmm-mode
  :ensure t
  :config
  (mmm-add-classes
   '((markdown-code
      :submode nil
      :face mmm-code-submode-face
      :front "^```\\([^[:space:]]+\\)?\\s-*\n"
      :back "^```\\s-*$"
      :save-matches 1
      :insert ((?c markdown-code nil @ "```" @ "\n" _ "\n```" @))
      :delimiter-mode nil
      :match-submode (lambda (lang)
                       (let ((lang-mode (intern (concat (downcase lang) "-mode"))))
                         (if (fboundp lang-mode) lang-mode 'fundamental-mode))))))

  (setq mmm-global-mode 'maybe)
  (mmm-add-mode-ext-class 'markdown-mode nil 'markdown-code)

  (defun my/markdown-code-block-mode ()
    (interactive)
    (when (and (boundp 'mmm-current-submode) mmm-current-submode)
      (funcall mmm-current-submode)))

  (add-hook 'markdown-mode-hook 'my/markdown-code-block-mode))


(defun my/markdown-live-preview-buffer (newwindow)
  "Toggle Markdown live preview in a separate buffer."
  (interactive "P")
  (if newwindow
      (markdown-live-preview-window)
    (markdown-live-preview-mode)))

(remove-hook 'markdown-mode-hook #'enable-trailing-whitespace)
(remove-hook 'gfm-mode-hook #'enable-trailing-whitespace)

(setq markdown-fontify-code-blocks-natively t)
