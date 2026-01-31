;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:13>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-100-keyboard.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-07 15:16:33>
;;; File: ./.dotfiles/.emacs.d/inits/100-keyboard.el

;; -*- lexical-binding: t -*-

(defvar key-chatter-delay 0.05
  "Number of seconds to wait before allowing the same key to register again.")
;; [REVISED]
(defvar key-chatter-last-time nil
  "Time of the last key press.")
;; [REVISED]
(defvar key-chatter-last-key nil
  "The last key that was pressed.")
;; [REVISED]
(defun key-chatter-filter ()
  "Filter out key chattering by introducing a delay between key presses."
  ;; [REVISED]
  (let ((time (float-time (current-time)))
        (key last-command-event))
    (if (and (eq key key-chatter-last-key)
             key-chatter-last-time
             (< (- time key-chatter-last-time) key-chatter-delay))
        (setq this-command 'ignore)
      ;; [REVISED]
      (setq key-chatter-last-time time)
      (setq key-chatter-last-key key))))

(add-to-list 'post-self-insert-hook 'key-chatter-filter)

;; Keyboard
(global-unset-key (kbd "C-\\"))
(setq default-input-method nil)
(set-input-method nil)

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-100-keyboard)

(when
    (not load-file-name)
  (message "02-base-100-keyboard.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))