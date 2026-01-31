;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:34>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-004-custome-functions-organize-me.el

;; File Management

(defun my/mv
    (new-path)
  "Move/rename the current buffer and the file it's visiting to NEW-PATH."
  (interactive "FNew path: ")
  (let
      ((old-path
        (buffer-file-name)))
    (unless old-path
      (error "Buffer '%s' is not visiting a file!"
             (buffer-name)))
    (if
        (get-buffer new-path)
        (error "A buffer named '%s' already exists!" new-path))
    (rename-file old-path new-path 1)
    (rename-buffer new-path)
    (set-visited-file-name new-path)
    (set-buffer-modified-p nil)
    (message "Moved '%s' to '%s'" old-path new-path)))

;; Buffer Management

(defun my/close-dired-buffers
    ()
  "Close all dired buffers."
  (interactive)
  (mapc
   (lambda
     (buffer)
     (when
         (eq 'dired-mode
             (buffer-local-value 'major-mode buffer))
       (kill-buffer buffer)))
   (buffer-list)))

(defun my/df
    ()
  "Delete the current frame."
  (interactive)
  (delete-frame))

;; Text Operations

(defun my/copy-region-or-buffer
    ()
  "Copy region if active, otherwise copy entire buffer."
  (interactive)
  (if
      (use-region-p)
      (kill-ring-save
       (region-beginning)
       (region-end))
    (kill-ring-save
     (point-min)
     (point-max))))

(defun my/doublequoted-bracket
    ()
  "Wrap region in quoted brackets [\"...\"]."
  (interactive)
  (save-excursion
    (let
        ((start
          (region-beginning))
         (end
          (region-end)))
      (goto-char start)
      (insert "[\"")
      (goto-char
       (+ end 2))
      (insert "\"]"))))

;; 7. Key Bindings
;; ----------------------------------------
(bind-key*
 (kbd "C-S-h")
 'describe-symbol)
                                        ; Bind help key

(provide '01-core-004-custome-functions-organize-me)

(when
    (not load-file-name)
  (message "01-core-004-custome-functions-organize-me.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))