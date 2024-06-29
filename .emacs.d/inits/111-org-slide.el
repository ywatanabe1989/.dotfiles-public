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
  (org-display-inline-images)
  )

(defun my/scroll-left ()
  (interactive)
  (scroll-left)
  (org-fold-show-all)
  (org-display-inline-images)
  )

(defun my/hide-org-tags ()
  "Hide tags in org mode."
  (setq-local org-hide-emphasis-markers t)
  (org-set-tags-command '(""))  ; This hides tags by setting them to an empty string temporarily
  (hide-lines "#\+")
  )

(defun my/show-org-tags ()
  "Show tags in org mode."
  (setq-local org-hide-emphasis-markers nil)
  (org-set-tags-command nil)  ; Reset tags visibility
  )

(defun my/hide-export-blocks ()
  "Hide export blocks in org mode during slides."
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^#\\+BEGIN_EXPORT\\|^#\\+END_EXPORT" nil t)
      (let ((ov (make-overlay (line-beginning-position) (1+ (line-end-position)))))
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
    (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)
    (add-hook 'org-babel-after-execute-hook 'my/org-display-inline-images)
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
    (add-hook 'org-tree-slide-stop-hook 'my/show-export-blocks)
    )
  ;; Uncomment and adjust these settings as needed
  ;; (org-tree-slide-header nil)
  (org-tree-slide-slide-in-effect nil)
  ;; (org-tree-slide-heading-emphasis nil)
  ;; (org-tree-slide-cursor-init t)
  ;; (org-tree-slide-modeline-display 'outside)
  ;; (org-tree-slide-skip-outline-level 1)
  :config
  (global-set-key (kbd "<f5>") 'org-tree-slide-mode)
  (global-set-key (kbd "C-<next>") 'my/scroll-right)
  (global-set-key (kbd "C-<previous>") 'my/scroll-left)
  (global-set-key (kbd "C->") 'my/scroll-right)
  (global-set-key (kbd "C-<") 'my/scroll-left)    
  (setq org-startup-folded nil))


