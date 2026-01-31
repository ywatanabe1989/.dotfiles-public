;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:52>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-buffer-ibuffer-sorting.el

(defvar my/buffer-ibuffer-sorting-function-list
  (let ((choices '(("t" . "t")
                   ("d" . "d"))))
    (mapcar (lambda (pair)
              (cons (format "%s - %s"
                            (car pair)
                            (if (string= (car pair) "t")
                                "Sort by timestamp"
                              "Reset to default layout"))
                    (cdr pair)))
            choices))
  "Alist of sorting keys and their descriptions for ibuffer.")

;; (defun my/buffer-ibuffer-sort (&optional sort-key)
;;   "Sort ibuffer by specified key.
;; Keys:
;; t - sort by timestamp
;; d - reset to default layout"
;;   (interactive)
;;   (let ((key (or sort-key
;;                  (char-to-string (read-char-exclusive)))))
;;     (cond
;;      ((string= key "t")
;;       (ibuffer-do-sort-by-modification-time))
;;      ((string= key "d")
;;       (ibuffer-switch-to-saved-filter-groups "Default")))))

(defun my/buffer-ibuffer-sort ()
  "Sort ibuffer interactively."
  (interactive)
  (message "Sort: [t]ime [n]ame [s]ize [m]ode [f]ilename")
  (let ((c (read-char-exclusive)))
    (cond
     ((eq c ?t) (ibuffer-do-sort-by-recency))
     ((eq c ?n) (ibuffer-do-sort-by-alphabetic))
     ((eq c ?s) (ibuffer-do-sort-by-size))
     ((eq c ?m) (ibuffer-do-sort-by-major-mode))
     ((eq c ?f) (ibuffer-do-sort-by-filename/process))
     (t (message "Invalid sort key")))))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '03-ui-000-buffer-ibuffer-sorting)

(when
    (not load-file-name)
  (message "03-ui-000-buffer-ibuffer-sorting.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))