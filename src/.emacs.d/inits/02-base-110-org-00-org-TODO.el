;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:13>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-110-org-00-org-TODO.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-09 03:10:17 (ywatanabe)>
;;; File: /home/ywatanabe/.emacs.d/inits/100-editing/110-org/110-org-TODO.el

(require 'org)

(setq org-todo-keywords
      '((sequence "TODO(t)" "IN-PROGRESS(p)" "DONE(d)" "CANCELED(c)"
                  "WAITING(w)")))

(defface org-todo-face
  '((t :foreground "#FF6B6B" :weight bold))
                                        ; Soft red
  "Face for TODO tasks in org-mode.")

(defface org-in-progress-face
  '((t :foreground "#4ECDC4" :weight bold))
                                        ; Turquoise
  "Face for IN-PROGRESS tasks in org-mode.")

(defface org-waiting-face
  '((t :foreground "#FFD93D" :weight bold))
                                        ; Warm yellow
  "Face for WAITING tasks in org-mode.")

(defface org-done-face
  '((t :foreground "#95E1D3" :weight bold :strike-through t))
                                        ; Mint green
  "Face for DONE tasks in org-mode.")

(defface org-canceled-face
  '((t :foreground "#A8A8A8" :weight bold :strike-through t))
                                        ; Gray
  "Face for CANCELED tasks in org-mode.")

(setq org-todo-keyword-faces
      '(("TODO" . org-todo-face)
        ("IN-PROGRESS" . org-in-progress-face)
        ("WAITING" . org-waiting-face)
        ("DONE" . org-done-face)
        ("CANCELED" . org-canceled-face)))

(global-set-key (kbd "C-c t") 'org-todo)

;; Quick access bindings

(define-key org-mode-map (kbd "C-c t t")
            (lambda () (interactive) (org-todo "TODO")))

(define-key org-mode-map (kbd "C-c t p")
            (lambda () (interactive) (org-todo "IN-PROGRESS")))

(define-key org-mode-map (kbd "C-c t d")
            (lambda () (interactive) (org-todo "DONE")))

(define-key org-mode-map (kbd "C-c t c")
            (lambda () (interactive) (org-todo "CANCELED")))

(define-key org-mode-map (kbd "C-c t w")
            (lambda () (interactive) (org-todo "WAITING")))

;; (defface org-waiting-face
;;   '((t :foreground "gray"))
;;   "Face for WAITING tasks in org-mode.")

;; (setq org-todo-keyword-faces
;;       '(("TODO" . (:foreground "#FF6B6B" :weight bold))        ; Soft red
;;         ("IN-PROGRESS" . (:foreground "#4ECDC4" :weight bold)) ; Turquoise
;;         ("WAITING" . (:foreground "#FFD93D" :weight bold))     ; Warm yellow
;;         ("DONE" . (:foreground "#95E1D3" :weight bold))        ; Mint green
;;         ("CANCELED" . (:foreground "#A8A8A8" :weight bold :strike-through t)))) ; Gray

;; (setq org-todo-keyword-faces
;;       '(("WAITING" . org-waiting-face)))

;; (setq org-todo-keywords
;;       '((sequence "TODO" "IN-PROGRESS" "WAITING" "|" "DONE" "CANCELED")))

;; (setq org-todo-keyword-faces
;;       '(("TODO" . (:foreground "#FF6B6B" :weight bold))        ; Soft red
;;         ("IN-PROGRESS" . (:foreground "#4ECDC4" :weight bold)) ; Turquoise
;;         ("WAITING" . (:foreground "#FFD93D" :weight bold))     ; Warm yellow
;;         ("DONE" . (:foreground "#95E1D3" :weight bold))        ; Mint green
;;         ("CANCELED" . (:foreground "#A8A8A8" :weight bold :strike-through t)))) ; Gray

;; (custom-set-faces
;;  '(org-done ((t (:foreground "#95E1D3" :weight bold))))        ; Matching DONE color
;;  '(org-todo ((t (:foreground "#FF6B6B" :weight bold)))))       ; Matching TODO color

;; (setq org-todo-keyword-faces
;;       '(("TODO" . (:foreground "#FF4040" :weight bold))
;;         ("IN-PROGRESS" . (:foreground "#FFA500" :weight bold))
;;         ("WAITING" . (:foreground "#FFD700" :weight bold))
;;         ("DONE" . (:foreground "#98FB98" :weight bold))
;;         ("CANCELED" . (:foreground "#A9A9A9" :weight bold :strike-through t))))

;; (custom-set-faces
;;  '(org-done ((t (:foreground "green" :weight bold))))
;;  '(org-todo ((t (:foreground "red" :weight bold)))))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-110-org-00-org-TODO)

(when
    (not load-file-name)
  (message "02-base-110-org-00-org-TODO.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))