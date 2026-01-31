;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-12-20 20:55:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-vterm-00-mouse.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

;; Simple vterm right-click handler:
;; - Count right clicks within 0.5 seconds
;; - 1 click -> send "1"
;; - 2 clicks -> send "2"
;; - 3 clicks -> send "3"
;; - 4 clicks -> send "4"
;; - 5+ clicks -> ignored

(require 'cl-lib)

(defvar my/vterm-mouse-debug nil
  "When non-nil, print debug messages for vterm mouse events.")

(defvar my/vterm-click-count 0)

(defvar my/vterm-click-timer nil)

(defvar my/vterm-click-buffer nil)

(defvar my/vterm-click-window 0.5
  "Time window in seconds to count right clicks.")
(setq my/vterm-click-count 0)  ;; Reset on load

(defun my/vterm-debug-mouse-bindings ()
  "Debug: show current mouse-3 bindings in vterm."
  (interactive)
  (message "======== VTERM MOUSE BINDING DEBUG ========")
  (message "vterm loaded: %s" (featurep 'vterm))
  (message "vterm-mode-map exists: %s" (boundp 'vterm-mode-map))
  (when (boundp 'vterm-mode-map)
    (message "[down-mouse-3] -> %s"
             (lookup-key vterm-mode-map [down-mouse-3]))
    (message "[mouse-3] -> %s" (lookup-key vterm-mode-map [mouse-3]))
    (message "[double-down-mouse-3] -> %s"
             (lookup-key vterm-mode-map [double-down-mouse-3])))
  (message "Current major-mode: %s" major-mode)
  (message "Local [down-mouse-3]: %s"
           (local-key-binding [down-mouse-3]))
  (message "Global [down-mouse-3]: %s"
           (global-key-binding [down-mouse-3]))
  (message "which-key-mode: %s" (bound-and-true-p which-key-mode))
  (message "============================================"))

(defun my/vterm-execute-click ()
  "Execute action based on click count."
  (when my/vterm-mouse-debug
    (message "========================================")
    (message "=== TIMER FIRED: EXECUTE CLICK ===")
    (message "========================================")
    (message "  Final click count: %s" my/vterm-click-count)
    (message "  Buffer: %s (live: %s)"
             my/vterm-click-buffer
             (buffer-live-p my/vterm-click-buffer)))
  (when (buffer-live-p my/vterm-click-buffer)
    (with-current-buffer my/vterm-click-buffer
      (pcase my/vterm-click-count
        (1
         (when my/vterm-mouse-debug (message "  -> Sending '1'"))
         (vterm-send-string "1"))
        (2
         (when my/vterm-mouse-debug (message "  -> Sending '2'"))
         (vterm-send-string "2"))
        (3
         (when my/vterm-mouse-debug (message "  -> Sending '3'"))
         (vterm-send-string "3"))
        (4
         (when my/vterm-mouse-debug (message "  -> Sending '4'"))
         (vterm-send-string "4"))
        (_
         (when my/vterm-mouse-debug
           (message "  -> Ignoring (count >= 5)"))))))
  (when my/vterm-mouse-debug
    (message "  Resetting: count=0, timer=nil, buffer=nil")
    (message "=== EXECUTE DONE ==="))
  (setq my/vterm-click-count 0
        my/vterm-click-timer nil
        my/vterm-click-buffer nil))

(defun my/vterm-right-click ()
  "Handle right-click: count clicks within time window, then execute."
  (interactive)
  (when my/vterm-mouse-debug
    (message "----------------------------------------")
    (message "--- RIGHT-CLICK HANDLER CALLED ---")
    (message "  Count BEFORE: %s" my/vterm-click-count)
    (message "  Timer exists: %s" (if my/vterm-click-timer "YES" "NO")))
  ;; Cancel existing timer
  (when my/vterm-click-timer
    (when my/vterm-mouse-debug
      (message "  -> Cancelling existing timer..."))
    (cancel-timer my/vterm-click-timer)
    (when my/vterm-mouse-debug
      (message "  -> Timer cancelled")))
  ;; Increment count
  (cl-incf my/vterm-click-count)
  (setq my/vterm-click-buffer (current-buffer))
  (when my/vterm-mouse-debug
    (message "  Count AFTER: %s" my/vterm-click-count)
    (message "  Buffer: %s" (buffer-name my/vterm-click-buffer))
    (message "  Setting timer for %.1f seconds..."
	     my/vterm-click-window))
  ;; Set timer for click window
  (setq my/vterm-click-timer
        (run-with-timer my/vterm-click-window nil
                        #'my/vterm-execute-click))
  (when my/vterm-mouse-debug
    (message "  Timer created: %s" my/vterm-click-timer)
    (message "--- RIGHT-CLICK HANDLER EXIT ---")))

;; Bind right-click directly in vterm-mode-map

(defun my/vterm-setup-mouse-bindings ()
  "Setup mouse bindings for vterm. Call this after vterm is loaded."
  (interactive)
                                        ; (message ">>> my/vterm-setup-mouse-bindings called <<<")
                                        ; (message "  vterm-mode-map bound: %s" (boundp 'vterm-mode-map))
  (when (boundp 'vterm-mode-map)
                                        ; (message "  Setting [down-mouse-3] binding...")
    (define-key vterm-mode-map [down-mouse-3] #'my/vterm-right-click)
                                        ; (message "    [down-mouse-3] now: %s"
                                        ;          (lookup-key vterm-mode-map [down-mouse-3]))
    (define-key vterm-mode-map [mouse-3] #'ignore)
                                        ; (message "    [mouse-3] now: %s"
                                        ;          (lookup-key vterm-mode-map [mouse-3]))
    (define-key vterm-mode-map [double-down-mouse-3]
                #'my/vterm-right-click)
    (define-key vterm-mode-map [double-mouse-3] #'ignore)
    (define-key vterm-mode-map [triple-down-mouse-3]
                #'my/vterm-right-click)
    (define-key vterm-mode-map [triple-mouse-3] #'ignore)
                                        ;(message ">>> Mouse bindings setup complete <<<")
    ))

(with-eval-after-load 'vterm
                                        ; (message ">>> with-eval-after-load 'vterm triggered <<<")
  (my/vterm-setup-mouse-bindings))

;; Also try via hook in case with-eval-after-load timing is wrong
(add-hook 'vterm-mode-hook
          (lambda ()
                                        ; (message ">>> vterm-mode-hook triggered <<<")
                                        ; (message "  Local [down-mouse-3] BEFORE: %s"
                                        ;          (local-key-binding [down-mouse-3]))
            ;; Force local binding in this buffer
            (local-set-key [down-mouse-3] #'my/vterm-right-click)
            (local-set-key [mouse-3] #'ignore)
            (local-set-key [double-down-mouse-3]
                           #'my/vterm-right-click)
            (local-set-key [double-mouse-3] #'ignore)
            (local-set-key [triple-down-mouse-3]
                           #'my/vterm-right-click)
            (local-set-key [triple-mouse-3] #'ignore)
                                        ; (message "  Local [down-mouse-3] AFTER: %s"
                                        ;          (local-key-binding [down-mouse-3]))
                                        ; (message ">>> vterm-mode-hook done <<<")
            ))

;; Debug: log all mouse-3 events via pre-command-hook

(defun my/vterm-mouse-debug-hook ()
  "Debug hook to log mouse-3 events."
  (when (and my/vterm-mouse-debug
             (derived-mode-p 'vterm-mode)
             last-input-event
             (listp last-input-event))
    (let ((evt (car last-input-event)))
      (when (and evt (symbolp evt)
                 (string-match-p "mouse-3" (symbol-name evt)))
        (message "!!! PRE-COMMAND: event=%s this-command=%s !!!"
                 evt this-command)))))

(add-hook 'pre-command-hook #'my/vterm-mouse-debug-hook)

;; Mouse side buttons (forward/back):
;; - mouse-9 (forward/next page) -> Tab then Enter
;; - mouse-8 (back/previous page) -> Escape

(defun my/vterm-mouse-forward ()
  "Handle mouse forward button: send Tab, then Enter after short delay."
  (interactive)
  (when my/vterm-mouse-debug
    (message "--- MOUSE FORWARD (next page) -> Tab + Enter ---"))
  (vterm-send-key "<tab>")
  (run-with-timer 0.1 nil
                  (lambda ()
                    (when (derived-mode-p 'vterm-mode)
                      (vterm-send-return)))))

(defun my/vterm-mouse-back ()
  "Handle mouse back button: send Escape."
  (interactive)
  (when my/vterm-mouse-debug
    (message "--- MOUSE BACK (previous page) -> Escape ---"))
  (vterm-send-escape))

(defun my/vterm-setup-side-button-bindings ()
  "Setup mouse side button bindings for vterm."
  (when (boundp 'vterm-mode-map)
    (define-key vterm-mode-map [mouse-9] #'my/vterm-mouse-forward)
    (define-key vterm-mode-map [mouse-8] #'my/vterm-mouse-back)))

(with-eval-after-load 'vterm
  (my/vterm-setup-side-button-bindings))

(add-hook 'vterm-mode-hook
          (lambda ()
            (local-set-key [mouse-9] #'my/vterm-mouse-forward)
            (local-set-key [mouse-8] #'my/vterm-mouse-back)))

(provide '03-ui-000-vterm-00-mouse)

(when
    (not load-file-name)
  (message "03-ui-000-vterm-00-mouse.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))
