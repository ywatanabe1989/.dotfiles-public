;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-10-07 22:57:38>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/05-code-000-vc-magit.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(when
    (executable-find "git")
  (require 'magit nil t))

(setq projectile-mode-line "Projectile")

(setq remote-file-name-inhibit-cache nil)

(setq vc-ignore-dir-regexp
      (format "%s\\|%s"
              vc-ignore-dir-regexp
              tramp-file-name-regexp))

(setq tramp-verbose 1)

;; (setkey ("C-o") magit-diff-visit-file-other-window)

(define-key magit-mode-map (kbd "C-o")
            'magit-diff-visit-file-other-window)

(define-key magit-mode-map (kbd "o")
            'magit-diff-visit-file-other-window)

;; Customize Magit diff colors with transparency
(custom-set-faces
 '(magit-diff-added
   ((t
     (:background "#335533" :foreground "#ddffdd"))))
 '(magit-diff-added-highlight
   ((t
     (:background "#336633" :foreground "#eeffee"))))
 '(magit-diff-removed
   ((t
     (:background "#553333" :foreground "#ffdddd"))))
 '(magit-diff-removed-highlight
   ((t
     (:background "#663333" :foreground "#ffeeff"))))
 '(magit-diff-hunk-heading
   ((t
     (:background "#444444" :foreground "#999999"))))
 '(magit-diff-hunk-heading-highlight
   ((t
     (:background "#555555" :foreground "#aaaaaa")))))

(defun my/magit-insert-unmerged-section ()
  "Insert section showing only unmerged files."
  (when (magit-anything-unmerged-p)
    (magit-insert-section (unmerged-files)
      (magit-insert-heading "Conflicting files:")
      (let ((files (magit-unmerged-files)))
        (dolist (file files)
          (magit-insert-section (file file)
            (insert
             (propertize (concat "  " file) 'face 'magit-filename))
            (insert "\n"))))
      (insert "\n"))))

(defun my/magit-status-setup ()
  "Custom setup for magit-status buffer."
  (magit-add-section-hook 'magit-status-sections-hook
                          'my/magit-insert-unmerged-section
                          'magit-insert-staged-changes
                          'append))

(defun my/magit-highlight-conflict-section ()
  "Customize Magit to highlight the unmerged (conflict) section more prominently."
  (interactive)
  ;; Show unmerged section by default
  (add-to-list 'magit-section-initial-visibility-alist
               '(unmerged . show))

  ;; Add custom face for highlighting unmerged files
  (defface my/magit-conflict-file
    '((t :inherit magit-filename
         :foreground "red"
         :weight bold
         :underline t))
    "Face for highlighting conflicting files in Magit status buffer.")

  ;; Function to apply custom face to unmerged files
  (defun my/highlight-unmerged-files ()
    (when (derived-mode-p 'magit-status-mode)
      (save-excursion
        (goto-char (point-min))
        (when (re-search-forward "^Unmerged into" nil t)
          (let ((section-end (save-excursion
                               (if
                                   (re-search-forward "^[[:alpha:]]"
                                                      nil t)
                                   (match-beginning 0)
                                 (point-max)))))
            (while
                (re-search-forward
                 "\\([[:space:]]+\\)\\([^[:space:]]+\\)$" section-end
                 t)
              (overlay-put
               (make-overlay (match-beginning 2) (match-end 2))
               'face 'my/magit-conflict-file)))))))

  ;; Add hook to run when magit-status is displayed
  (add-hook 'magit-status-mode-hook 'my/highlight-unmerged-files)

  ;; Add a keybinding to jump directly to unmerged section
  (define-key magit-status-mode-map (kbd "C-c u")
              (lambda ()
                (interactive)
                (goto-char (point-min))
                (when (re-search-forward "^Unmerged into" nil t)
                  (recenter 1)))))

(my/magit-highlight-conflict-section)

(add-hook 'magit-mode-hook 'my/magit-status-setup)

(defface my/magit-conflict-file
  '((t :inherit magit-filename :foreground "red" :weight bold))
  "Face for highlighting conflicting files in Magit.")
;; (set-face-attribute 'magit-diff-added nil
;;                     :background
;;                     (color-darken-name "green" 40)
;;                     :foreground
;;                     (color-lighten-name "green" 80))
;; (set-face-attribute 'magit-diff-removed nil
;;                     :background
;;                     (color-darken-name "red" 40)
;;                     :foreground
;;                     (color-lighten-name "red" 80))

;; ;; smerge-mode
;; ;; Modeline color for conflicts
;; (defun my/check-conflicts ()
;;   "Check if conflicts remain in buffer."
;;   (save-excursion
;;     (goto-char (point-min))
;;     (if (re-search-forward "^<<<<<<< " nil t)
;;         (set-face-background 'mode-line "darkred")
;;       (set-face-background 'mode-line (face-background 'mode-line-inactive)))))

;; (defun my/smerge-mode-hook ()
;;   (if smerge-mode
;;       (progn
;;         (my/check-conflicts)
;;         (add-hook 'post-command-hook #'my/check-conflicts nil t))
;;     (remove-hook 'post-command-hook #'my/check-conflicts t)
;;     (set-face-background 'mode-line (face-background 'mode-line-inactive))))

;; (add-hook 'smerge-mode-hook 'my/smerge-mode-hook)

;; (defun my/smerge-mode-maybe ()
;;   "Enable `smerge-mode' if the buffer contains conflict markers."
;;   (save-excursion
;;     (goto-char (point-min))
;;     (when (re-search-forward "^<<<<<<< " nil t)
;;       (smerge-mode 1))))

;; (add-hook 'find-file-hook 'my/smerge-mode-maybe)

;; ;; Volume merging
;; (defun my/smerge-keep-all-lower ()
;;   "Keep lower version for all conflicts in buffer or region."
;;   (interactive)
;;   (save-excursion
;;     (goto-char (if (use-region-p) (region-beginning) (point-min)))
;;     (while (re-search-forward "^<<<<<<< " (if (use-region-p) (region-end) (point-max)) t)
;;       (smerge-keep-lower))))

;; (defun my/smerge-keep-all-upper ()
;;   "Keep upper version for all conflicts in buffer or region."
;;   (interactive)
;;   (save-excursion
;;     (goto-char (if (use-region-p) (region-beginning) (point-min)))
;;     (while (re-search-forward "^<<<<<<< " (if (use-region-p) (region-end) (point-max)) t)
;;       (smerge-keep-upper))))

;; (defun my/smerge-keep-all-newer ()
;;   "Keep newer version for all conflicts in buffer or region."
;;   (interactive)
;;   (save-excursion
;;     (goto-char (if (use-region-p) (region-beginning) (point-min)))
;;     (while (re-search-forward "^<<<<<<< " (if (use-region-p) (region-end) (point-max)) t)
;;       (smerge-keep-newer))))

;; (defun my/smerge-keep-all-older ()
;;   "Keep older version for all conflicts in buffer or region."
;;   (interactive)
;;   (save-excursion
;;     (goto-char (if (use-region-p) (region-beginning) (point-min)))
;;     (while (re-search-forward "^<<<<<<< " (if (use-region-p) (region-end) (point-max)) t)
;;       (smerge-keep-older))))

;; (define-key smerge-mode-map (kbd "C-c L") 'my/smerge-keep-all-lower)
;; (define-key smerge-mode-map (kbd "C-c U") 'my/smerge-keep-all-upper)
;; (define-key smerge-mode-map (kbd "C-c N") 'my/smerge-keep-all-newer)
;; (define-key smerge-mode-map (kbd "C-c O") 'my/smerge-keep-all-older)

;; (define-key smerge-mode-map (kbd "M-n") 'smerge-next)
;; (define-key smerge-mode-map (kbd "M-p") 'smerge-prev)

;; (define-key smerge-mode-map (kbd "C-c l") 'smerge-keep-lower)
;; (define-key smerge-mode-map (kbd "C-c u") 'smerge-keep-upper)

;; (define-key smerge-mode-map (kbd "C-c n") 'smerge-keep-newer)
;; (define-key smerge-mode-map (kbd "C-c o") 'smerge-keep-older)

;;


(provide '05-code-000-vc-magit)

(when
    (not load-file-name)
  (message "05-code-000-vc-magit.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))