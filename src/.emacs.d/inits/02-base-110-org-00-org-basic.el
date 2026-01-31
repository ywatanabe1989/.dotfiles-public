;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:14>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-110-org-00-org-basic.el

;;; -*- lexical-binding: t -*-
;;; Author: 2025-01-05 06:46:08
;;; Time-stamp: <2025-01-05 06:46:08 (ywatanabe)>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/100-editing/110-org/110-org-basic.el

;; -*- lexical-binding: t -*-

(defvar my/org-tags-hidden nil
  "Flag to track whether tags are hidden.")

;; (use-package org-modern
;;   :init (require 'org-tempo)
;;   :hook (org-mode . org-modern-mode)
;;   )

(defun my/org-mode-setup ()
  "Custom 'org-mode' settings to be executed when an org file is opened."
  (interactive)
  (setq org-startup-folded 'showall)
  ;; (setq org-startup-with-inline-images nil)
  (setq org-image-actual-width nil)
  (setq org-return-follows-link t)
  (setq org-startup-with-inline-images t)
  ;; Add any other functions or settings you want to initialize here
  ;; For example, to automatically hide tags when opening org files:
  (my/org-toggle-tags))

(add-hook 'org-mode-hook 'my/org-mode-setup)

(use-package org
  :bind
  (:map org-mode-map
        ("C-c a" . org-agenda)
        ("C-c C-a" . my/org-agenda)
        ("C-c c" . org-capture)
        ("C-c h" . my/org-export-as-html-and-open)
        ;; ("C-c t" . my/org-toggle-tags)
        ("C-c C-t" . my/org-toggle-tags))
  :hook ((org-mode . (lambda ()
                       (org-indent-mode)
                       (message "Org mode activated")))
         (after-save . (lambda ()
                         (when (eq major-mode 'org-mode)
                           ;; (my/org-twice-indent-mode)
                           ;; (my/org-export-as-html-and-open)
                           ))))

  ;; (org-html-export-to-html)))))
  :init
  (setq org-log-done t)
  :custom
  (my/org-mode-setup)
  ;; (org-startup-folded 'showall)
  ;; (org-startup-with-inline-images nil)
  ;; (org-image-actual-width nil)
  :config
  (global-set-key (kbd "<f5>") 'org-tree-slide-mode)
  (define-key org-mode-map (kbd "C-c i") 'org-toggle-inline-images)
  (define-key org-mode-map (kbd "C-c u") 'org-fold-show-all)
  (define-key org-mode-map (kbd "C-c f") 'org-fold-hide-sublevels)
  (define-key org-mode-map (kbd "C-c n") 'my/org-twice-indent-mode)
  ;; (define-key org-mode-map (kbd "C-c h") 'my/org-export-as-html-and-open)
  ;; Variables
  (setq org-startup-truncate nil)
  (setq org-hide-leading-stars t)
  (setq org-hide-emphasis-markers t)
  (setq org-log-done 'time)
  (setq org-startup-with-inline-images nil)
  (setq org-deadline-warning-days 7)
  (setq org-use-fast-todo-selection 't))

;; Functions
;; (defun my/org-twice-indent-mode ()
;;   (interactive)
;;   (org-indent-mode)
;;   (org-indent-mode)
;;   )

(defun my/org-export-as-html-and-open ()
  "Export the current Org buffer to an HTML file and open or reload it in a web browser."
  (interactive)
  (let ((output-file (org-html-export-to-html)))
    (browse-url
     (concat "file://"
             (replace-regexp-in-string "\\.org$" ".html"
                                       (buffer-file-name))))))

(defun my/org-toggle-tags ()
  (interactive)
  (if my/org-tags-hidden
      (progn
        ;; Show all hidden lines and blocks
        (remove-overlays (point-min) (point-max) 'invisible t)
        (hide-lines-show-all)
        (setq my/org-tags-hidden nil))
    (my/org-hide-tags)))

(defun my/org-hide-tags ()
  (hide-blocks-matching "BEGIN_EXPORT html" "END_EXPORT")
  (hide-lines-matching "END_EXPORT")
  (hide-lines-matching "ATTR_HTML")
  (setq my/org-tags-hidden t))

(require 'org)
(require 'ob-core)
(require 'ob-emacs-lisp)

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-110-org-00-org-basic)

(when
    (not load-file-name)
  (message "02-base-110-org-00-org-basic.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))