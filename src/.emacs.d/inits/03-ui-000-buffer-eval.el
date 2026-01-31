;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:51>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-buffer-eval.el

(defun my/eval-region-or-buffer
    ()
  "Evaluate region if active, otherwise evaluate buffer and jump to first error."
  (interactive)
  (condition-case err
      (if
          (use-region-p)
          (eval-region
           (region-beginning)
           (region-end))
        (eval-buffer))
    (error
     (message "Caught an error: %s"
              (error-message-string err))
     (when-let
         ((line-number
           (my/get-line-number-from-error
            (error-message-string err))))
       (goto-line line-number)))))

(defalias 'ev 'my/eval-region-or-buffer)

(defalias 'er 'my/eval-region-or-buffer)

(defalias 'eb 'eval-buffer)

(defun my/get-line-number-from-error
    (error-message)
  "Extract line number from the error message, if present."
  (when
      (string-match "at line \\([0-9]+\\)" error-message)
    (string-to-number
     (match-string 1 error-message))))

(when
    (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '03-ui-000-buffer-eval)

(when
    (not load-file-name)
  (message "03-ui-000-buffer-eval.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))
