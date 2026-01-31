;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-30 18:32:28>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/05-lang-000-latex.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(use-package tex
  :ensure
  auctex
  :mode ("\\.tex\\'" . LaTeX-mode)
  :config
  (setq TeX-auto-save t
        TeX-parse-self t)
  (with-eval-after-load 'latex
    (when (boundp 'LaTeX-mode-map)
      (define-key LaTeX-mode-map (kbd "C-c p")
                  #'latex-preview-pane-mode)
      (define-key LaTeX-mode-map (kbd "C-c c") #'my/pdflatex))))

(use-package latex-preview-pane
  :ensure
  t
  :after auctex)

(defun my/pdflatex ()
  "Compile current LaTeX file using custom pdflatex script."
  (interactive)
  (let* ((texfile (file-name-nondirectory buffer-file-name))
         (texname (file-name-sans-extension texfile))
         (default-directory (file-name-directory buffer-file-name))
         (output-buffer (get-buffer-create "*pdflatex*"))
         (script-path (expand-file-name "~/.bin/my-pdflatex")))
    (save-buffer)
    (with-current-buffer output-buffer
      (erase-buffer)
      (insert (format "Current directory: %s\n" default-directory))
      (insert "Directory contents:\n")
      (call-process-shell-command "ls -la" nil (current-buffer) t)
      (insert
       (format "\nRunning command: bash %s %s\n\n" script-path texfile))
      (call-process-shell-command
       (format "bash %s %s" script-path texfile)
       nil (current-buffer) t)
      (insert "\nCommand execution finished."))
    (if (file-exists-p (concat texname ".pdf"))
        (progn
          (kill-buffer output-buffer)
          (message "%s.pdf was created at %s" texname
                   default-directory))
      (message
       "LaTeX compilation failed. Check *pdflatex* buffer for details.")
      (display-buffer output-buffer))))

(defun my/latex-count-words-in-region (start end)
  "Count words in the current region using TeXcount."
  (interactive "r")
  (let ((tempfile (make-temp-file "texcount")))
    (unwind-protect
        (progn
          (write-region start end tempfile)
          (shell-command-on-region start end
                                   (concat "texcount " tempfile) nil t))
      (delete-file tempfile))))

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (flycheck-mode -1)))


(provide '05-lang-000-latex)

(when
    (not load-file-name)
  (message "05-lang-000-latex.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))