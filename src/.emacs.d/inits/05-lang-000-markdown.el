;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2026-01-28 05:50:28>
;;; File: /home/ywatanabe/.dotfiles/src/.emacs.d/inits/05-lang-000-markdown.el

;;; Copyright (C) 2026 Yusuke Watanabe (ywatanabe@scitex.ai)


(use-package markdown-mode
  :mode
  ("\\.md\\'" . gfm-mode)
  :config

  (custom-set-faces
   '(markdown-header-face-1 ((t (:foreground "#ff6666"))))
   '(markdown-header-face-2 ((t (:foreground "#ff9966"))))
   '(markdown-header-face-3 ((t (:foreground "#ffcc66"))))
   '(markdown-header-face-4 ((t (:foreground "#ccff66"))))
   '(markdown-header-face-5 ((t (:foreground "#99ff66"))))
   '(markdown-header-face-6 ((t (:foreground "#66ff66")))))

  (setq markdown-command "/usr/bin/pandoc")
  (setq markdown-open-command "/usr/bin/pandoc")
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))
  (define-key markdown-mode-map (kbd "<f5>")
              (lambda () (interactive) (revert-buffer nil t)))
  (define-key markdown-mode-map (kbd "M-<return>") nil)

  (custom-set-faces
   '(markdown-code-face ((t (:background "gray26")))))

  (setq markdown-indent-on-enter 'indent-and-new-item
        markdown-indent-function 'markdown-indent-line
        markdown-list-indent-width 4
        markdown-asymmetric-header t
        tab-width 4
        markdown-enable-math t
        markdown-fontify-code-blocks-natively t)

  (setq-default tab-width 4
                indent-tabs-mode nil)

  (diff-hl-mode t)
  (add-hook 'before-save-hook #'my/markdown-reformat-table)

  ;; Collapse headers by default (H1 and deeper)
  (defun my/markdown-outline-setup ()
    "Setup outline mode for markdown - fold all headers.
Uses markdown-mode's built-in outline support which is code-block aware."
    ;; Use markdown-mode's header regex (excludes code blocks)
    (setq-local outline-regexp markdown-regex-header)
    (setq-local outline-level #'markdown-outline-level)
    (outline-minor-mode 1)
    ;; Fold all headers initially
    (when (fboundp 'markdown-hide-body)
      (markdown-hide-body)))

  (add-hook 'gfm-mode-hook #'my/markdown-outline-setup)
  (add-hook 'markdown-mode-hook #'my/markdown-outline-setup)

  ;; ;; Helper: check if point is inside a fenced code block by scanning markers
  ;; (defun my/markdown-in-fenced-code-p ()
  ;;   "Return t if point is inside a fenced code block (``` ... ```)."
  ;;   (save-excursion
  ;;     (let ((pos (point))
  ;;           (fence-count 0))
  ;;       (goto-char (point-min))
  ;;       (while (and (re-search-forward "^```" pos t)
  ;;                   (<= (point) pos))
  ;;         (setq fence-count (1+ fence-count)))
  ;;       (= (% fence-count 2) 1))))

  ;; ;; Tab to toggle fold on headers
  ;; (defun my/markdown-outline-toggle ()
  ;;   "Toggle outline visibility at point."
  ;;   (interactive)
  ;;   ;; Respect fenced/inline code: keep Tab for indentation there.
  ;;   (if (or (my/markdown-in-fenced-code-p)
  ;;           (markdown-code-block-at-point-p)
  ;;           (markdown-inline-code-at-point-p)
  ;;           (and (fboundp 'mmm-overlays-at)
  ;;                (mmm-overlays-at (point))))
  ;;       (indent-for-tab-command)
  ;;     (let ((h2+ (save-excursion
  ;;                  (beginning-of-line)
  ;;                  (when (looking-at "^##") (point))))
  ;;           (h1 (save-excursion
  ;;                 (beginning-of-line)
  ;;                 (when (looking-at "^# [^#]") (point)))))
  ;;       (cond
  ;;        ;; On H2+ header - use outline functions (works anywhere on the line)
  ;;        (h2+
  ;;         (save-excursion
  ;;           (goto-char h2+)
  ;;           (if (outline-invisible-p (line-end-position))
  ;;               (outline-show-subtree)
  ;;             (outline-hide-subtree))))
  ;;        ;; On H1 header - hide to next H1 or end of buffer
  ;;        (h1
  ;;         (save-excursion
  ;;           (goto-char h1)
  ;;           (let ((beg (line-end-position))
  ;;                 (end (save-excursion
  ;;                        (forward-line 1)
  ;;                        (if (re-search-forward "^# [^#]" nil t)
  ;;                            (line-beginning-position)
  ;;                          (point-max)))))
  ;;             (if (get-char-property beg 'invisible)
  ;;                 (outline-flag-region beg end nil)
  ;;               (outline-flag-region beg end t)))))
  ;;        ;; Elsewhere - normal tab
  ;;        (t (indent-for-tab-command))))))

  ;; (define-key markdown-mode-map (kbd "<tab>")
  ;;         #'my/markdown-outline-toggle)
  ;; (define-key gfm-mode-map (kbd "<tab>") #'my/markdown-outline-toggle)
  )

(defun my/markdown-reformat-table ()
  "Reformats markdown tables in the buffer."
  (interactive)
  (when (derived-mode-p 'markdown-mode 'gfm-mode)
    (save-excursion
      (goto-char (point-min))
      (while
          (search-forward-regexp "^[[:space:]]*\\(|[-+]+|\\)" nil t)
        (replace-match
         (replace-regexp-in-string "\\+" "|" (match-string 1)) t t)))))

(use-package mmm-mode
  :ensure
  t
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
                       (let
                           ((lang-mode
                             (intern (concat (downcase lang) "-mode"))))
                         (if (fboundp lang-mode) lang-mode
                           'fundamental-mode))))))

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


(provide '05-lang-000-markdown)

(when
    (not load-file-name)
  (message "05-lang-000-markdown.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))