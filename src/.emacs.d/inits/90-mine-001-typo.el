;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-07-27 18:11:13>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/90-mine-001-typo.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defvar my/typo-file
  (expand-file-name
   "~/.dotfiles/.emacs.d/inits/90-mine-001-typo-list.el")
  "The file that contains the list of typo corrections.")

(defvar my/typo-replacements
  nil
  "A list of common typos and their corrections.")

(defun my/load-typo-replacements ()
  "Load the list of typos from `my/typo-file`."
  (when (file-exists-p my/typo-file)
    (load my/typo-file)))

(defun my/typo-fix ()
  "Replace common typos in the current buffer according to `my/typo-replacements`."
  (interactive)
  (when (and buffer-file-name
             (not
              (string= (expand-file-name buffer-file-name)
                       my/typo-file)))
    (let ((inhibit-read-only t)
          (case-fold-search nil))
      (save-excursion
        (goto-char (point-min))
        (dolist (pair my/typo-replacements)
          (goto-char (point-min))
          (while
              (re-search-forward
               (concat "\\b" (regexp-quote (car pair)) "\\b") nil t)
            (replace-match (cdr pair))))))))

(defun my/typo-add (typo correction)
  "Add a new TYPO and its CORRECTION to the list of typos.
If called interactively, use word at point as default TYPO."
  (interactive
   (let ((default-typo (thing-at-point 'word)))
     (list
      (read-string (format "Type the TYPO%s: "
                           (if default-typo
                               (format " (default \"%s\")"
                                       default-typo)
                             ""))
                   nil nil default-typo)
      (read-string "Type the CORRECTION: "))))
  (let ((new-entry (cons typo correction)))
    (if (assoc typo my/typo-replacements)
        (message "The typo '%s' is already in the list." typo)
      (push new-entry my/typo-replacements)
      (my/typo-save-replacements)
      (message "Added typo correction: %s -> %s" typo correction))))

(global-set-key (kbd "C-c a") 'my/typo-add)

(defun my/typo-save-replacements ()
  "Save the current list of typos to the typo file."
  (with-temp-file my/typo-file
    (insert ";; A list of common typos and their corrections.\n")
    (insert "(setq my/typo-replacements '(\n")
    (dolist (entry my/typo-replacements)
      (insert
       (format "    (\"%s\" . \"%s\")\n" (car entry) (cdr entry))))
    (insert "))\n")))

(add-hook 'before-save-hook 'my/typo-fix)

(my/load-typo-replacements)


(provide '90-mine-001-typo)

(when
    (not load-file-name)
  (message "90-mine-001-typo.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))