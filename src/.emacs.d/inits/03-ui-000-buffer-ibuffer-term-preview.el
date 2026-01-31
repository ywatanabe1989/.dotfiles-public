;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:52>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-buffer-ibuffer-term-preview.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2025-01-22 19:56:10 (ywatanabe)>
;;; File: .emacs.d/inits/000-buffer-ibuffer-term-preview.el

(eval-and-compile
  (define-ibuffer-column term-preview
    (:name "Preview")
    (when (derived-mode-p 'term-mode)
      (with-current-buffer buffer
        (let* ((proc (get-buffer-process (current-buffer)))
               (mark (and proc (process-mark proc)))
               (content (if mark
                            (buffer-substring-no-properties
                             (max (- mark 1000) (point-min)) mark)
                          (buffer-string)))
               (lines (split-string content "\n" t)))
          (string-join (last lines 3) "\n")))))

  (define-ibuffer-column term-dir
    (:name "Directory")
    (when (derived-mode-p 'term-mode)
      (with-current-buffer buffer
        default-directory)))

  (setq ibuffer-formats
        '((mark modified read-only " "
                (name 18 18 :left :elide)
                " "
                (size 9 -1 :right)
                " "
                (mode 16 16 :left :elide)
                " "
                (term-dir 30 30 :left :elide)
                " "
                (term-preview 40 -1 :left)
                " " filename-and-process))))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '03-ui-000-buffer-ibuffer-term-preview)

(when
    (not load-file-name)
  (message "03-ui-000-buffer-ibuffer-term-preview.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))