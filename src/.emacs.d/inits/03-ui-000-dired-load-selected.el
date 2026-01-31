;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-06 09:06:37>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-dired-load-selected.el

(defun --my/dired-load-selected (arg)
  "Load selected files into Emacs from dired.
ARG is the prefix argument, which affects how files are opened."
  (interactive "P")
  (let ((orig-buffer (current-buffer)))
    (let* ((files (dired-get-marked-files))
           (count (length files)))
      (cond
       ;; No files marked - open file at point
       ((= count 0)
        (let ((file (dired-get-filename nil t)))
          (if file
              (find-file file)
            (message "No file at point"))))
       ;; One file - open normally
       ((= count 1)
        (find-file (car files)))
       ;; Multiple files
       (t
        (dolist (file files)
          (find-file-noselect file))
        (let
            ((buffer (get-buffer (file-name-nondirectory (car files)))))
          (when buffer
            (switch-to-buffer buffer)))
        (message "Loaded %d files" count))))
    (switch-to-buffer orig-buffer)))

(provide '03-ui-000-dired-load-selected)

(when
    (not load-file-name)
  (message "03-ui-000-dired-load-selected.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))