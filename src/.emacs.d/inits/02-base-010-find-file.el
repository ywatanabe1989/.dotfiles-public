;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:50>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-010-find-file.el

(defun my/find-file ()
  "Open a file with the default minibuffer input being the current file's path without its extension."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if filename
        (find-file
         (read-file-name "Open file: " nil
                         (file-name-sans-extension filename) t))
      (find-file (read-file-name "Open file: ")))))

(defun my/open-extension-removed-directory ()
  (interactive)
  (when (buffer-file-name)
    (let* ((current-path (buffer-file-name))
           (base-name (file-name-sans-extension current-path))
           (results-dir (concat base-name)))
      (if (file-exists-p results-dir)
          (dired results-dir)
        (message "Directory does not exist: %s" results-dir)))))

(bind-key* (kbd "C-c C-o") 'my/open-extension-removed-directory)

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-010-find-file)

(when
    (not load-file-name)
  (message "02-base-010-find-file.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))