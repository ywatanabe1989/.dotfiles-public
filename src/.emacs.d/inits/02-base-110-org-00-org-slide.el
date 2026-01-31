;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:14>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-110-org-00-org-slide.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-24 17:25:05 (ywatanabe)>
;;; File: ./.dotfiles/.emacs.d/inits/100-editing/110-org/110-org-slide.el

;; -*- lexical-binding: t -*-

(use-package hide-lines)

(defun my/org-display-inline-images ()
  (org-display-inline-images t t))

(defun my/org-show-all ()
  (outline-show-all))

(defun my/scroll-right ()
  (interactive)
  (scroll-right)
  (org-fold-show-all)
  (org-display-inline-images))

(defun my/scroll-left ()
  (interactive)
  (scroll-left)
  (org-fold-show-all)
  (org-display-inline-images))

(defun my/hide-org-tags ()
  "Hide tags in org mode."
  (setq-local org-hide-emphasis-markers t)
  (org-set-tags-command '(""))
  (hide-lines "#\+"))

(defun my/show-org-tags ()
  "Show tags in org mode."
  (setq-local org-hide-emphasis-markers nil)
  (org-set-tags-command nil))

(defun my/hide-export-blocks ()
  "Hide export blocks in org mode during slides."
  (save-excursion
    (goto-char (point-min))
    (while
        (re-search-forward "^#\\+BEGIN_EXPORT\\|^#\\+END_EXPORT" nil t)
      (let
          ((ov
            (make-overlay (line-beginning-position)
                          (1+ (line-end-position)))))
        (overlay-put ov 'invisible t)
        (overlay-put ov 'intangible t)))))

(defun my/show-export-blocks ()
  "Show export blocks in org mode after slides."
  (remove-overlays (point-min) (point-max) 'invisible t))

(use-package org-tree-slide
  :custom
  (org-image-actual-width nil)
  (setq org-startup-indented t)
  (setq org-indent-mode-turns-on-hiding-stars nil)
  (setq org-indent-indentation-per-level 2)
  (setq org-startup-folded "showall")
  (org-startup-folded 'showall)
  (org-startup-with-inline-images t)

  ;; Org Babel Hooks for Inline Images and Visibility
  (progn
    (add-hook 'org-babel-after-execute-hook
              'org-redisplay-inline-images)
    (add-hook 'org-babel-after-execute-hook
              'my/org-display-inline-images)
    ;; Uncomment the following line if you want to automatically expand all sections after execution
    ;; (add-hook 'org-babel-after-execute-hook 'org-fold-show-all)
    )

  ;; Org Tree Slide Hooks for Presentation Mode
  (progn
    ;; Hooks when starting slide mode
    (add-hook 'org-tree-slide-play-hook 'my/org-display-inline-images)
    (add-hook 'org-tree-slide-play-hook 'my/org-show-all)
    (add-hook 'org-tree-slide-play-hook 'org-fold-show-all)
    (add-hook 'org-tree-slide-play-hook 'my/hide-org-tags)
    (add-hook 'org-tree-slide-play-hook 'my/hide-export-blocks)

    ;; Hooks when stopping slide mode
    (add-hook 'org-tree-slide-stop-hook 'my/show-org-tags)
    (add-hook 'org-tree-slide-stop-hook 'my/show-export-blocks))
  ;; Uncomment and adjust these settings as needed
  ;; (org-tree-slide-header nil)
  (org-tree-slide-slide-in-effect nil)
  ;; (org-tree-slide-heading-emphasis nil)
  ;; (org-tree-slide-cursor-init t)
  ;; (org-tree-slide-modeline-display 'outside)
  ;; (org-tree-slide-skip-outline-level 1)
  :config

  (define-key org-mode-map (kbd "<f5>") 'org-tree-slide-mode)
  (define-key org-mode-map (kbd "C-<next>") 'my/scroll-right)
  (define-key org-mode-map (kbd "C-<previous>") 'my/scroll-left)
  (define-key org-mode-map (kbd "C->") 'my/scroll-right)
  (define-key org-mode-map (kbd "C-<") 'my/scroll-left)

  ;; (global-set-key (kbd "<f5>") 'org-tree-slide-mode)
  ;; (global-set-key (kbd "C-<next>") 'my/scroll-right)
  ;; (global-set-key (kbd "C-<previous>") 'my/scroll-left)
  ;; (global-set-key (kbd "C->") 'my/scroll-right)
  ;; (global-set-key (kbd "C-<") 'my/scroll-left)
  (setq org-startup-folded nil))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-110-org-00-org-slide)

(when
    (not load-file-name)
  (message "02-base-110-org-00-org-slide.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))