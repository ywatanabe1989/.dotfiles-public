;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:10:58>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/90-mine-copy-code-blocks.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-07 15:16:38>
;;; File: ./.dotfiles/.emacs.d/inits/300-copy-code-blocks.el

(defvar code-block-start-delimiter
  "^\\s-*```\\s-*\\([a-zA-Z0-9_+-]+\\)?\\s-*$"
  "Regex for code block start delimiter.")

(defvar code-block-end-delimiter "^\\s-*```\\s-*$"
  "Regex for code block end delimiter.")

(define-minor-mode code-block-navigation-mode
  "Minor mode for navigating and copying code blocks."
  :lighter " CBN"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "M-n") 'code-block-next)
            (define-key map (kbd "M-p") 'code-block-previous)
            map))

(defun code-block-next ()
  "Navigate to the next code block and copy the content."
  (interactive)
  (end-of-line)
  (when (looking-at-p code-block-end-delimiter)
    (forward-line)
    (beginning-of-line))
  (when (re-search-forward code-block-start-delimiter nil t)
    (let ((start (point)))
      (when (re-search-forward code-block-end-delimiter nil t)
        (let ((end (match-beginning 0)))
          (goto-char end)
          (set-mark (1+ start))
          (activate-mark)
          (kill-ring-save start end)
          (pulse-momentary-highlight-region (1+ start) end)
          (message "Copied."))))
    (deactivate-mark)))

(defun code-block-previous ()
  "Navigate to the previous code block and copy the content."
  (interactive)
  (when (re-search-backward code-block-end-delimiter nil t)
    (backward-char)
    (let ((end (point)))
      (if (re-search-backward code-block-start-delimiter nil t)
          (progn
            (forward-line 1)
            (set-mark end)
            (activate-mark)
            (kill-ring-save (point) end)
            (pulse-momentary-highlight-region (+ (point) 1) end)
            (message "Copied."))
        (deactivate-mark)))))

(defun enable-code-block-navigation-mode ()
  "Enable code-block-navigation-mode for specific major modes."
  (when (memq major-mode '(markdown-mode gfm-mode))
    (code-block-navigation-mode 1)))

(add-hook 'after-change-major-mode-hook
          'enable-code-block-navigation-mode)
(add-hook 'markdown-mode-hook 'enable-code-block-navigation-mode)
(add-hook 'gfm-mode-hook 'enable-code-block-navigation-mode)

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '90-mine-copy-code-blocks)

(when
    (not load-file-name)
  (message "90-mine-copy-code-blocks.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))