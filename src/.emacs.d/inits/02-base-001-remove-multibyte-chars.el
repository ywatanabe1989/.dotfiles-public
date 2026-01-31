;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:48>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-001-remove-multibyte-chars.el

(defun my/remove-multibyte-characters
    ()
  "Remove all multibyte characters from the current buffer."
  (interactive)
  (save-excursion
    (goto-char
     (point-min))
    (while
        (not
         (eobp))
      (let
          ((char
            (char-after)))
        (if
            (>
             (string-bytes
              (string char))
             1)
            (delete-char 1)
          (forward-char 1))))))

;; (add-hook 'before-save-hook 'remove-multibyte-characters)

(when
    (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-001-remove-multibyte-chars)

(when
    (not load-file-name)
  (message "02-base-001-remove-multibyte-chars.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))