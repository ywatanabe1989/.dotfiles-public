;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-17 12:26:51>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/_03-ui-000-vterm-10-kill.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

(require 'vterm)

(defun --my/vterm-kill-region (beg end)
  "Kill text between BEG and END in vterm, with proper terminal handling."
  (interactive "r")
  ;; (message "Copy mode")
  (--my/vterm-with-copy-mode
   ;; (message "--my/vterm-kill-region called with beg=%d end=%d" beg
   ;;          end)
   ;; (message "Current buffer: %s, vterm-copy-mode=%s" (current-buffer)
   ;;          vterm-copy-mode)
   (if (use-region-p)
       (progn
         ;; (message "Region is active")
         ;; (message "Inside copy mode block")
         (let ((inhibit-read-only t)
               (region-text (buffer-substring-no-properties beg end)))
           ;; (message "Region text: %s" region-text)
           ;; Save the text to kill-ring first
           (kill-new region-text)
           ;; (message
           ;;  (format "Text added to kill-ring:\nContents:%s"
           ;;          region-text))
           ))
     (progn
       ;; (message "No active region")
       (let ((inhibit-read-only t)
             (region-text
              (buffer-substring-no-properties (point)
                                              (line-end-position))))
         ;; (message "Using line as region: %s" region-text)
         (kill-new region-text)
         ;; (message "Line text added to kill-ring")
         ;; (delete-region (point) (line-end-position))
         ;; (message "Line deleted")
         )))
   (if (region-active-p)
       (deactivate-mark))))

(defun --my/vterm-kill-line ()
  "Kill text from point to end of line in vterm."
  (interactive)
  (if (and (eq major-mode 'vterm-mode)
           (not vterm-copy-mode))
      (progn
        ;; First switch to copy mode to be able to get text
        (vterm-copy-mode 1)
        ;; Get the text we want to kill
        (let* ((start (point))
               (end (vterm--get-end-of-line))
               (text (buffer-substring-no-properties start end)))
          ;; Add it to kill ring
          (kill-new text)
          ;; Return to char mode
          (vterm-copy-mode 0)
          ;; Send delete-to-end-of-line key sequence
          (vterm-send-key "k" nil nil t))
        ;; Clear any selection that might have been made
        (deactivate-mark))
    ;; If already in copy mode, use normal kill-line behavior
    (kill-line)))

(provide '_03-ui-000-vterm-10-kill)

(when
    (not load-file-name)
  (message "_03-ui-000-vterm-10-kill.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))