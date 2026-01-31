;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-14 14:19:00>
;;; File: /home/ywatanabe/.emacs.d/inits/02-base-999-my-timers.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

(defun my/timers-list ()
  "Show list of active timers in a special buffer with keybindings to cancel them."
  (interactive)
  (with-current-buffer (get-buffer-create "*Timers List*")
    (let ((inhibit-read-only t))
      (erase-buffer)
      (special-mode) ; Base mode for read-only buffers with special commands

      ;; Set up key bindings
      (local-set-key (kbd "c") 'my/timers-cancel-at-point)
      (local-set-key (kbd "d") 'my/timers-cancel-at-point) ; alias for consistency
      (local-set-key (kbd "g") 'my/timers-refresh)
      (local-set-key (kbd "q") 'quit-window)

      ;; Display header
      (insert "Active Timers:\n")
      (insert "=============\n\n")
      (insert "Press 'c' or 'd' to cancel timer at point\n")
      (insert "Press 'g' to refresh the list\n")
      (insert "Press 'q' to quit\n\n")

      ;; List all timers with properties
      (dolist (timer timer-list)
        (let ((start-pos (point)))
          (insert (format "Timer: %S\n" timer))
          (insert (format "  Function: %S\n" (timer--function timer)))
          (insert (format "  Args: %S\n" (timer--args timer)))
          (insert (format "  Idle: %S\n" (timer--idle-delay timer)))
          (insert
           (format "  Repeat: %S\n" (timer--repeat-delay timer)))
          (insert "\n")
          ;; Add timer object as a text property for the whole entry
          (put-text-property start-pos (point) 'timer timer)))

      (goto-char (point-min))
      (message
       "Press 'c' or 'd' to cancel timer at point, 'g' to refresh, 'q' to quit")))
  (switch-to-buffer "*Timers List*"))

(defun my/timers-cancel-at-point ()
  "Cancel the timer at point in the timers list buffer."
  (interactive)
  (let ((timer (get-text-property (point) 'timer)))
    (if timer
        (progn
          (cancel-timer timer)
          (message "Timer cancelled: %S" (timer--function timer))
          (my/timers-refresh))
      (message "No timer at point"))))

(defun my/timers-refresh ()
  "Refresh the timers list."
  (interactive)
  (when (string= (buffer-name) "*Timers List*")
    (let ((inhibit-read-only t)
          (pos (point)))
      (erase-buffer)
      (my/timers-list)
      (goto-char (min pos (point-max))))))


(provide '02-base-999-my-timers)

(when
    (not load-file-name)
  (message "02-base-999-my-timers.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))