;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-12-18 04:06:09>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-vterm-10-navigation.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; Position
;; ----------------------------------------

(defun my/vterm-goto-max ()
  "Simplified auto-scroll function for vterm."
  (interactive)
  (when (eq major-mode 'vterm-mode)
    (goto-char (point-max))))

;; (advice-add 'vterm--flush :after #'--my/vterm-simple-auto-scroll)

(defun my/vterm-jump-to-last ()
  "Jump to the most recently used vterm buffer."
  (interactive)
  (let ((buffers (--filter
                  (with-current-buffer it (eq major-mode 'vterm-mode))
                  (buffer-list))))
    (when buffers
      (switch-to-buffer (car buffers)))))

;; Buffer Tracking
;; ----------------------------------------

(defvar my/vterm-buffer-alist nil
  "Alist of (buffer . creation-time) for vterm buffers.")

(defun my/vterm-track-buffer ()
  "Add current vterm buffer to tracking alist."
  (when (eq major-mode 'vterm-mode)
    (let ((current-buf (current-buffer)))
      (unless (assq current-buf my/vterm-buffer-alist)
        (push (cons current-buf (float-time)) my/vterm-buffer-alist)))))

(add-hook 'vterm-mode-hook #'my/vterm-track-buffer)

(defun my/vterm-cleanup-buffer-list ()
  "Remove killed buffers from the vterm buffer alist."
  (setq my/vterm-buffer-alist
        (--filter (buffer-live-p (car it)) my/vterm-buffer-alist)))

(defun --my/vterm-next ()
  "Switch to the next vterm buffer."
  (interactive)
  (my/vterm-cleanup-buffer-list)
  (when my/vterm-buffer-alist
    (let*
        ((sorted-list
          (--sort (< (cdr it) (cdr other)) my/vterm-buffer-alist))
         (current-buf (current-buffer))
         (pos (--find-index (eq (car it) current-buf) sorted-list))
         (next-pos (if
                       (or (null pos)
                           (= pos (1- (length sorted-list))))
                       0
                     (1+ pos)))
         (next-buf (car (nth next-pos sorted-list))))
      (switch-to-buffer next-buf)
      (message "vterm %d/%d: %s"
               (1+ next-pos)
               (length sorted-list)
               (buffer-name next-buf)))))

(defun --my/vterm-prev ()
  "Switch to the previous vterm buffer."
  (interactive)
  (my/vterm-cleanup-buffer-list)
  (when my/vterm-buffer-alist
    (let*
        ((sorted-list
          (--sort (< (cdr it) (cdr other)) my/vterm-buffer-alist))
         (current-buf (current-buffer))
         (pos (--find-index (eq (car it) current-buf) sorted-list))
         (prev-pos (if (or (null pos) (= pos 0))
                       (1- (length sorted-list))
                     (1- pos)))
         (prev-buf (car (nth prev-pos sorted-list))))
      (switch-to-buffer prev-buf)
      (message "vterm %d/%d: %s"
               (1+ prev-pos)
               (length sorted-list)
               (buffer-name prev-buf)))))

(defun etm-navigation-jump-by-index (index)
  "Jump to the vterm buffer at INDEX."
  (interactive "nEnter vterm buffer index: ")
  (let ((buffers (--filter
                  (with-current-buffer it (eq major-mode 'vterm-mode))
                  (buffer-list))))
    (when (and buffers (> (length buffers) 0))
      (let ((target-buf (if (<= index (length buffers))
                            (nth (1- index) buffers)
                          (car buffers))))
        (switch-to-buffer target-buf)))))

(defun --my/vterm-jump-by-buffer-type (type)
  "Jump to a vterm buffer based on TYPE."
  (interactive)
  (let ((buffers (--filter
                  (with-current-buffer it (eq major-mode 'vterm-mode))
                  (buffer-list))))
    (when buffers
      ;; Simple implementation that just goes to first buffer for now
      ;; This could be enhanced to actually recognize buffer types
      (switch-to-buffer (car buffers)))))

;; Prompt
;; ----------------------------------------

(defcustom my/vterm-prompt-expressions '(" $ " "Apptainer> " "> ")
  ;; Added "> " as another example
  "A list of strings or regexps representing possible vterm prompts."
  :type '(repeat string)
  :group 'vterm)

(defun my/vterm--get-prompt-regexp ()
  "Return a compiled regexp matching any of `my/vterm-prompt-expressions`."
  (regexp-opt my/vterm-prompt-expressions t))

(defun my/vterm-jump-to-prev-ps1 ()
  "Jump to the beginning of the line containing the previous prompt based on `my/vterm-prompt-expressions`."
  (interactive)
  (let ((prompt-regexp (my/vterm--get-prompt-regexp)))
    ;; Ensure we are in vterm-mode
    (unless (derived-mode-p 'vterm-mode)
      (error "Not in a vterm buffer"))
    ;; Ensure copy mode
    (unless (and (boundp 'vterm-copy-mode) vterm-copy-mode)
      (vterm-copy-mode))
    ;; Search backward for any prompt pattern
    ;; search-backward-regexp leaves point at the beginning of the match
    (when (search-backward-regexp prompt-regexp nil t)
      ;; Allow for consective calls
      (backward-char (length prompt-regexp))
      ;; Go to the beginning of that line
      (beginning-of-line))))

(defun my/vterm-jump-to-next-ps1 ()
  "Jump to the beginning of the line containing the next prompt based on `my/vterm-prompt-expressions`."
  (interactive)
  (let ((prompt-regexp (my/vterm--get-prompt-regexp)))
    ;; Ensure we are in vterm-mode
    (unless (derived-mode-p 'vterm-mode)
      (error "Not in a vterm buffer"))
    ;; Ensure copy mode
    (unless (and (boundp 'vterm-copy-mode) vterm-copy-mode)
      (vterm-copy-mode))
    ;; Search forward for any prompt pattern
    ;; search-forward-regexp leaves point at the end of the match
    (next-line)
    (if (search-forward-regexp prompt-regexp nil t)
        (progn
          ;; Move point to the beginning of the matched prompt text
          (goto-char (match-beginning 0))
          ;; Go to the beginning of that line
          (beginning-of-line))
      (progn
        (previous-line)
        (end-of-line)))))


(provide '03-ui-000-vterm-10-navigation)

(when
    (not load-file-name)
  (message "03-ui-000-vterm-10-navigation.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))