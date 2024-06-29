;; Startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (my/maximize)
            (setq inhibit-startup-screen t)
            (my/tab-setup))
          )

;; before-save-hook
(add-hook 'before-save-hook
          (lambda ()
            (unless (derived-mode-p 'markdown-mode)
              (my/delete-trailing-whitespace))))

;; after-save-hook
(defun my/after-save-actions ()
  "Perform custom actions after saving a file."
  (executable-make-buffer-file-executable-if-script-p)
  (my/flash-mode-line "dark green" 2))

(add-hook 'after-save-hook 'my/after-save-actions)

;; prog-mode-hooks
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)




;; (add-hook 'gpt-mode-hook (lambda () (ivy-mode -1)))
;; (add-hook 'gpt-mode-hook (lambda () (auto-composition-mode -1)))
;; (add-hook 'gpt-mode-hook (lambda () (column-number-mode -1)))
;; (add-hook 'gpt-mode-hook (lambda () (counsel-mode -1)))
;; (add-hook 'gpt-mode-hook (lambda () (cua-mode -1)))

;; persp-mode
;; (add-hook 'find-file-hook #'my-persp-add-buffer)
;; (add-hook 'after-change-major-mode-hook #'my-persp-add-buffer)
