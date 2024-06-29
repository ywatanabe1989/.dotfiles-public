;; Repogitories
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
;; (package-refresh-contents)

;; use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)
; (setq use-package-always-defer t)


(use-package init-loader
  :ensure t ;; Ensure init-loader is installed (optional, requires package.el or similar)
  :init
  ;; Code that runs before init-loader is loaded
  (let ((default-directory (expand-file-name "~/.emacs.d/lisp")))
    (add-to-list 'load-path default-directory)
    (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
        (normal-top-level-add-subdirs-to-load-path)))
  :config
  ;; Code that runs after init-loader is loaded
  (setq init-loader-show-log-after-init nil)
  (setq init-loader-default-regexp "\\(?:^[[:digit:]]\\{2,3\\}\\).*\\.el$")
  (init-loader-load "~/.emacs.d/inits"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(url-http-oauth2 mu4e-oauth2 url-https-oauth2 url-https-oauth url-http-oauth oauth auth-source-xoauth2 oauth2-request oauth2-auto zenburn-theme yasnippet yaml-mode xwidgets-reuse which-key web-server web-mode web w3m visual-regexp-steroids vimish-fold vertico use-package typescript-mode swiper stream spinner slack rg python-isort pyimport persp-mode pdf-tools org-tree-slide org-modern orderless multi-term mmm-mode markdown-mode marginalia magit init-loader highlight-parentheses highlight-indent-guides hide-lines helm flycheck-posframe flycheck-pos-tip ez-query-replace doom-themes doom-modeline diff-hl csv-mode csharp-mode consult company command-log-mode color-moccur blacken all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(show-paren-match ((t (:background "#2F4F4F" :weight normal)))))
