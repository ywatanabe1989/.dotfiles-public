;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:45>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-001-cua.el

;; 1. CUA Mode Configuration
;; ----------------------------------------

(setq cua-enable-cua-keys nil)
(setq cua-keep-region-after-copy t)

;; 2. Core Functions
;; ----------------------------------------

(defun my/cua-vertical-yank
    ()
  "Yank text to each line in the rectangular region when in CUA mode."
  (interactive)
  (if
      (not cua-mode)
      (message "CUA mode is not active")
    (let*
        ((delete-selection-was-on delete-selection-mode)
         (start
          (region-beginning))
         (end
          (region-end))
         (start-col
          (save-excursion
            (goto-char start)
            (current-column)))
         (clipboard-text
          (current-kill 0)))
      (delete-selection-mode -1)
      (unwind-protect
          (when
              (and start end)
            (cua-delete-region)
            (string-rectangle start end
                              (concat
                               (make-string start-col ?\s)
                               clipboard-text)))
        (delete-selection-mode
         (if delete-selection-was-on 1 -1))))))

(defun my/cua-vertical-yank
    ()
  "Yank text to each line in the rectangular region when in CUA mode."
  (interactive)
  (if
      (not cua-mode)
      (message "CUA mode is not active")
    (let*
        ((start
          (region-beginning))
         (end
          (region-end))
         (start-col
          (save-excursion
            (goto-char start)
            (current-column)))
         (clipboard-text
          (current-kill 0)))
      (when
          (and start end)
        (string-rectangle start end
                          (concat
                           (make-string start-col ?\s)
                           clipboard-text))))))

;; 3. Keybindings and Initialization
;; ----------------------------------------

(define-key cua--rectangle-keymap
            (kbd "M-y")
            'my/cua-vertical-yank)

(provide '02-base-001-cua)

(when
    (not load-file-name)
  (message "02-base-001-cua.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))