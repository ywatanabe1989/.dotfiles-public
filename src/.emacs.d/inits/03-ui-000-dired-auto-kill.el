;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-06-02 13:51:13>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-dired-auto-kill.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; ;;; -*- coding: utf-8; lexical-binding: t -*-
;; ;;; Author: ywatanabe
;; ;;; Timestamp: <2025-05-29 05:03:00>
;; ;;; File: /home/ywatanabe/.emacs.d/inits/03-ui-000-dired-auto-refresh.el

;; ;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

;; (defvar --my/dired-buffer-timers (make-hash-table :test 'equal)
;;   "Hash table storing timers for dired buffers.")

;; (defun --my/dired-schedule-auto-kill (buffer)
;;   "Schedule BUFFER to be killed after 5 minutes if not visited."
;;   (let ((timer (gethash buffer --my/dired-buffer-timers)))
;;     (when timer
;;       (cancel-timer timer))
;;     (puthash buffer
;;              (run-with-timer 300 nil
;;                              (lambda (buf)
;;                                (when (and (buffer-live-p buf)
;;                                           (eq
;;                                            (buffer-local-value
;;                                             'major-mode buf)
;;                                            'dired-mode))
;;                                  (kill-buffer buf)
;;                                  (remhash buf --my/dired-buffer-timers)))
;;                              buffer)
;;              --my/dired-buffer-timers)))

;; (defun --my/dired-cancel-auto-kill (buffer)
;;   "Cancel auto-kill timer for BUFFER."
;;   (let ((timer (gethash buffer --my/dired-buffer-timers)))
;;     (when timer
;;       (cancel-timer timer)
;;       (remhash buffer --my/dired-buffer-timers))))

;; (add-hook 'dired-mode-hook
;;           (lambda ()
;;             (--my/dired-schedule-auto-kill (current-buffer))))

;; (add-hook 'buffer-list-update-hook
;;           (lambda ()
;;             (when (and (eq major-mode 'dired-mode)
;;                        (eq (current-buffer)
;;                            (window-buffer (selected-window))))
;;               (--my/dired-cancel-auto-kill (current-buffer))
;;               (--my/dired-schedule-auto-kill (current-buffer)))))

;; (provide '03-ui-000-dired-auto-refresh)

;; (when
;;     (not load-file-name)
;;   (message "03-ui-000-dired-auto-refresh.el loaded."
;;            (file-name-nondirectory
;;             (or load-file-name buffer-file-name))))


(provide '03-ui-000-dired-auto-kill)

(when
    (not load-file-name)
  (message "03-ui-000-dired-auto-kill.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))