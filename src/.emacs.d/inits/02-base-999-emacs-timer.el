;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-04-05 18:31:54>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-999-emacs-timer.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

;; Variables
;; ----------------------------------------

(defvar --emacs-timer-list (make-hash-table :test 'equal)
  "Hash table of registered timers, keyed by timer name.")

;; Core
;; ----------------------------------------

(defmacro emacs-timer-set (name interval function &rest args)
  "Wrapper to create and register a timer with NAME that runs FUNCTION with ARGS every INTERVAL seconds."
  `(emacs-timer-reset ,name ,interval ,function ,@args))

(defmacro emacs-timer-set-once (name delay function &rest args)
  "Wrapper to create and register a one-shot timer with NAME that runs FUNCTION with ARGS after DELAY seconds."
  `(progn
     (emacs-timer-cancel ,name)
     (let ((timer (run-with-timer ,delay nil ,function ,@args)))
       (--emacs-timer-register ,name timer)
       timer)))

(defmacro emacs-timer-set-idle (name idle-seconds function &rest args)
  "Wrapper to create and register an idle timer with NAME that runs FUNCTION with ARGS when Emacs is idle for IDLE-SECONDS."
  `(progn
     (emacs-timer-cancel ,name)
     (let
         ((timer
           (run-with-idle-timer ,idle-seconds nil ,function ,@args)))
       (--emacs-timer-register ,name timer)
       timer)))

(defun emacs-timer-cancel (name)
  "Cancel timer registered with NAME."
  (interactive "sTimer name: ")
  (let ((timer (gethash name --emacs-timer-list)))
    (if timer
        (progn
          (cancel-timer timer)
          (remhash name --emacs-timer-list)
          (message "Timer '%s' canceled." name))
      (message "No timer registered as '%s'." name))))

(defun emacs-timer-reset (name interval function &rest args)
  "Reset (or create) timer NAME to run FUNCTION with ARGS every INTERVAL seconds."
  (emacs-timer-cancel name)
  (let ((timer (apply #'run-with-timer 0 interval function args)))
    (--emacs-timer-register name timer)
    timer))

(defun emacs-timer-list ()
  "Display all registered timers."
  (interactive)
  (with-output-to-temp-buffer "*Registered Timers*"
    (princ "Registered timers:\n\n")
    (if (= (hash-table-count --emacs-timer-list) 0)
        (princ "No registered timers.")
      (maphash
       (lambda (name timer)
         (princ (format "Name: %s\n" name))
         (princ (format "  Timer: %S\n" timer))
         (princ (format "  Time: %s\n" (timer--time timer)))
         (princ (format "  Repeat: %s\n" (timer--repeat-delay timer)))
         (princ (format "  Function: %s\n" (timer--function timer)))
         (princ (format "  Args: %S\n\n" (timer--args timer))))
       --emacs-timer-list))))

(defun emacs-timer-cancel-all ()
  "Cancel all registered timers."
  (interactive)
  (let ((count (hash-table-count --emacs-timer-list)))
    (maphash (lambda (name timer)
               (cancel-timer timer)
               (remhash name --emacs-timer-list))
             --emacs-timer-list)
    (message "%d timer(s) canceled." count)))

(defun emacs-timer-active-p (name)
  "Return t if timer with NAME is active."
  (if (gethash name --emacs-timer-list) t nil))

;; Helper
;; ----------------------------------------

(defun --emacs-timer-register (name timer)
  "Register TIMER with NAME for later management."
  (puthash name timer --emacs-timer-list))

;; (global-set-key (kbd "C-c t l") 'emacs-timer-list)

;; (global-set-key (kbd "C-c t c") 'emacs-timer-cancel)

;; (global-set-key (kbd "C-c t a") 'emacs-timer-cancel-all)

(defalias 'run-with-named-timer 'emacs-timer-set)

(defalias 'run-with-named-idle-timer 'emacs-timer-set-idle)

(defalias 'run-with-named-one-time-timer 'emacs-timer-set-once)

(defalias 'cancel-named-timer 'emacs-timer-cancel)

(defalias 'list-named-timers 'emacs-timer-list)

(defalias 'cancel-all-named-timers 'emacs-timer-cancel-all)

(defalias 'named-timer-active-p 'emacs-timer-active-p)

(provide '02-base-999-emacs-timer)

(when
    (not load-file-name)
  (message "02-base-999-emacs-timer.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))