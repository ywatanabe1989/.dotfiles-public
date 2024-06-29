;; -*- lexical-binding: t -*-
(use-package wgrep
  :ensure t
  :config
  (setq wgrep-enable-key "r")
  (setq wgrep-auto-save-buffer t)
  (setq wgrep-change-readonly-file t))

(defun my/auto-wgrep-enable (&rest _args)
  "Automatically enable `wgrep` mode in `rg-mode` buffers, ignoring any arguments."
  (interactive)
  (set (make-local-variable 'wgrep-auto-save-buffer) t)
  (wgrep-change-to-wgrep-mode))


(require 'rg)

(defun my/rg (query)
  (interactive (list (read-string "Regexp search for: ")))
  (rg-run query "*" (my/get-current-dir) ))


;; (defun my/rg (query)
;;   (interactive (list (read-string "Regexp search for: ")))
;;   (rg-run query "." (projectile-project-root)))




;; (defun my/rg (query files)
;;   (interactive
;;    (list
;;     (read-string "Regexp search for: ")
;;     (read-string "File pattern: " "")
;;   (let dir curent-directory
;;        (rg query files (my/get-current-dir)))))




;; (require 'grep)

;; (defun ripgrep-search (search-term)
;;   "Search using ripgrep"
;;   (interactive "sSearch for: ")
;;   (grep-find (concat "rg --no-heading --line-number --color never -S "
;;                      (shell-quote-argument search-term)
;;                      " .")))

;; (defun my/rg (pattern)
;;   (interactive "sEnter pattern: ")
;;   (rg-run pattern "*" "*"))

;; (advice-add 'rg-run :after #'my/auto-wgrep-enable)



;; (unless (package-installed-p 'rg)
;;   (package-refresh-contents)
;;   (package-install 'rg))

;; (use-package rg
;;   :ensure t
;;   :config
;;   (rg-enable-default-bindings)
;;   (advice-add 'rg-run :after #'my/auto-wgrep-enable)
;;   :bind (("C-S-g" . rg-dwim)))

;; (use-package rg
;;   :ensure t
;;   :config
;; )



;; (global-set-key (kbd "C-S-g") 'ripgrep-search)

;;

;; ;; ;; Set up a global key for invoking ripgrep search
;; ;; (global-set-key (kbd "C-c s") 'rg)

;; ;; Configure rg to always search from the project's root if possible
;; (setq rg-group-result t)
;; (setq rg-show-columns t)

;; ;; Optionally customize the default directory to always be the current buffer's directory
;; (defun rg-search-current-directory (keywords)
;;   "Run ripgrep in the current directory."
;;   (interactive "sEnter keyword: ")
;;   (rg-run keywords "*" default-directory))

;; Bind the custom function to a key
;; (global-set-key (kbd "C-S-g") 'rg-search-current-directory)
(global-set-key (kbd "C-S-g") 'my/rg)


(bind-key* (kbd "C-S-h") 'describe-symbol)


;; ;; (use-package rg
;; ;;   :ensure t
;; ;;   :config
;; ;;   (defun rg-from-current-context (keyword)
;; ;;     "Run `rg` with a keyword from the current context.
;; ;; If called in a file buffer, search only within that file. Otherwise, search in the current directory."
;; ;;     (interactive "sEnter keyword: ") ;; Prompts the user to enter a keyword
;; ;;     (if buffer-file-name
;; ;;         ;; If in a file buffer, search only within the current file
;; ;;         (rg-run keyword "*.*" (file-name-directory buffer-file-name) (list (buffer-file-name)))
;; ;;       ;; Otherwise, search in the current directory
;; ;;       (rg-run keyword "*.*" default-directory)))

;; ;;   ;; Bind C-S-g to the custom `rg` function
;; ;;   (global-set-key (kbd "C-S-g") 'rg-from-current-context))
