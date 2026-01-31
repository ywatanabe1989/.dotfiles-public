;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-12-18 04:06:43>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-vterm-10-optimize.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;;; Description: Enhanced vterm optimizations based on Claude Code scrolling issue insights

;;; Commentary:
;; This configuration addresses the scrolling issues reported in:
;; https://github.com/anthropics/claude-code/issues/826
;; Key issues addressed:
;; - Terminal jumping to top of scrollback during high-throughput output
;; - Control sequences attempting to clear scrollback
;; - Performance issues with large buffers
;; - Cursor position instability during streaming

(require 'vterm nil t)

;;; Configuration variables

(defgroup my-vterm-optimize nil
  "Optimizations for vterm with high-throughput applications."
  :group 'vterm)

(defcustom my-vterm-truncation-threshold (* 100 1024 1024)
  "Buffer size threshold for truncation (default 10MB)."
  :type 'integer
  :group 'my-vterm-optimize)

(defcustom my-vterm-keep-lines 4096
  "Number of lines to keep when truncating buffer."
  :type 'integer
  :group 'my-vterm-optimize)

(setq my-vterm-keep-lines 99999999)

(defcustom my-vterm-truncation-interval 2
  "Seconds between truncation checks."
  :type 'number
  :group 'my-vterm-optimize)

;;; Buffer-local variables

(defvar-local --my/vterm-truncation-timer nil
  "Buffer-local truncation timer for this vterm buffer.")

(defvar-local --my/vterm-update-timer nil
  "Buffer-local timer for debouncing rapid updates.")

(defvar-local --my/vterm-saved-point nil
  "Saved point position before operations.")

(defvar-local --my/vterm-scroll-lock nil
  "When non-nil, prevent automatic scrolling.")

;;; Core optimization function

(defun my/vterm-optimize-for-high-throughput ()
  "Optimize vterm for handling large outputs with high streaming rates.
Addresses issues from Claude Code and similar high-throughput applications."
  (interactive)

  ;; Process buffer optimization
  (setq read-process-output-max (* 100 1024 1024))  ; 100MB chunks

  ;; Vterm-specific settings for throughput
  (setq vterm-timer-delay 1)              ; Increase delay to reduce flicker
  (setq vterm-max-scrollback 4096)          ; Limit scrollback; 1024 - conservative; 4096 - aggressive
  (setq vterm-disable-bold-font t)
  (setq vterm-disable-underline t)
  (setq vterm-disable-inverse-video t)

  ;; Prevent automatic scrolling issues (critical for the jumping problem)
  (setq-local vterm-disable-autoscroll t)
  (setq-local scroll-step 1)
  (setq-local scroll-conservatively 10000)
  (setq-local scroll-margin 0)
  (setq-local auto-hscroll-mode nil)
  (setq-local hscroll-margin 0)
  (setq-local hscroll-step 1)

  ;; Disable expensive text processing
  (setq-local bidi-display-reordering nil)
  (setq-local bidi-paragraph-direction 'left-to-right)
  (setq-local inhibit-field-text-motion t)
  (setq-local line-move-visual nil)  ; Move by visual lines for wrapped text
  ;; (setq-local track-mouse nil)
  (setq-local track-mouse t)
  (setq-local show-trailing-whitespace nil)

  ;; Cursor stability
  (setq-local cursor-in-non-selected-windows nil)
  (setq-local cursor-type 'box)
  (setq-local visible-cursor nil)  ; Reduce cursor redraw overhead

  ;; Disable visual modes that can cause performance issues
  (when (fboundp 'display-line-numbers-mode)
    (display-line-numbers-mode -1))
  (when (fboundp 'highlight-parentheses-mode)
    (highlight-parentheses-mode -1))
  (electric-indent-mode -1)
  (when (fboundp 'flycheck-mode)
    (flycheck-mode -1))
  (font-lock-mode -1)
  (auto-composition-mode -1)
  (auto-encryption-mode -1)
  (auto-compression-mode -1)

  ;; Window update optimizations
  (setq-local window-point-insertion-type t)
  (setq-local redisplay-skip-fontification-on-input t)
  (setq-local fast-but-imprecise-scrolling t)
  (setq-local jit-lock-defer-time 0.1)
  (setq-local redisplay-dont-pause t)

  ;; Memory management during high throughput
  (setq-local gc-cons-threshold (* 200 1024 1024))  ; 200MB
  (setq-local gc-cons-percentage 0.6)

  ;; Inhibit various hooks during output
  (setq-local inhibit-modification-hooks t)
  (setq-local inhibit-point-motion-hooks t)

  ;; Enable enhanced buffer management
  (my/vterm-enable-enhanced-buffer-management)

  ;; Install control sequence handler
  (my/vterm-install-control-sequence-handler)

  ;; Set up scroll lock toggle
  (my/vterm-setup-scroll-lock)

  ;; ;; Add anti-flicker buffering (MOVED HERE)
  ;; (advice-add 'vterm--filter :before-while
  ;;             #'my/vterm-buffer-multiline-output)
  )

;;; Scrollback control sequence handling

(defun my/vterm-install-control-sequence-handler ()
  "Install handler to prevent unwanted scrollback manipulation."
  ;; Override vterm's clear scrollback if it exists
  (when (fboundp 'vterm--clear-scrollback)
    (advice-add 'vterm--clear-scrollback :around
                #'my/vterm-clear-scrollback-advice))

  ;; Intercept problematic control sequences
  (when (boundp 'vterm-control-seq-regexp)
    (setq-local vterm-control-seq-regexp
                (concat vterm-control-seq-regexp
                        "\\|\\(?:\033\\[3J\\)"))))
                                        ; CSI 3 J - clear scrollback
(defun my/vterm-clear-scrollback-advice (orig-fun &rest args)
  "Advice to optionally ignore scrollback clear attempts."
  (if --my/vterm-scroll-lock
      (message "Blocked scrollback clear (scroll lock active)")
    (apply orig-fun args)))

;;; Enhanced buffer management

(defun my/vterm-enable-enhanced-buffer-management ()
  "Enable enhanced buffer management with automatic truncation."
  (when (eq major-mode 'vterm-mode)
    (my/vterm-start-truncation-timer)
    (my/vterm-install-update-debouncer)))

(defun my/vterm-start-truncation-timer ()
  "Start the buffer truncation timer."
  (when --my/vterm-truncation-timer
    (cancel-timer --my/vterm-truncation-timer))
  (let ((buffer (current-buffer)))
    (setq --my/vterm-truncation-timer
          (run-with-timer
           my-vterm-truncation-interval
           my-vterm-truncation-interval
           (lambda ()
             (when (buffer-live-p buffer)
               (with-current-buffer buffer
                 (my/vterm-truncate-if-needed))))))))

(defun my/vterm-truncate-if-needed ()
  "Truncate buffer if it exceeds threshold, preserving user position."
  (when (and (eq major-mode 'vterm-mode)
             (> (buffer-size) my-vterm-truncation-threshold))
    (let ((inhibit-read-only t)
          (old-point (point))
          (at-bottom (>= (point) (- (point-max) 100))))
      (save-excursion
        (goto-char (point-max))
        (forward-line (- my-vterm-keep-lines))
        (beginning-of-line)
        (let ((truncate-point (point)))
          (when (> truncate-point (point-min))
            (delete-region (point-min) truncate-point))))
      ;; Restore position intelligently
      (cond
       (at-bottom (goto-char (point-max)))
       ((< old-point (point-min)) (goto-char (point-min)))
       (t (goto-char old-point))))))

;;; Update debouncing

(defun my/vterm-install-update-debouncer ()
  "Install debouncer for rapid updates to prevent scrolling issues."
  (add-hook 'after-change-functions
            #'my/vterm-debounce-update nil t))

(defun my/vterm-debounce-update (&rest _)
  "Debounce rapid updates to prevent scrolling issues."
  (when --my/vterm-update-timer
    (cancel-timer --my/vterm-update-timer))
  (setq --my/vterm-update-timer
        (run-with-idle-timer
         0.1 nil
         (lambda (buffer)
           (when (buffer-live-p buffer)
             (with-current-buffer buffer
               (setq --my/vterm-update-timer nil))))
         (current-buffer))))

;;; Scroll lock functionality

(defun my/vterm-setup-scroll-lock ()
  "Set up scroll lock functionality to prevent automatic scrolling."
  (local-set-key (kbd "C-c C-s") #'my/vterm-toggle-scroll-lock)
  (when --my/vterm-scroll-lock
    (message "Scroll lock enabled (C-c C-s to toggle)")))

(defun my/vterm-toggle-scroll-lock ()
  "Toggle scroll lock to prevent automatic scrolling to bottom."
  (interactive)
  (setq --my/vterm-scroll-lock (not --my/vterm-scroll-lock))
  (message "Scroll lock %s"
           (if --my/vterm-scroll-lock "enabled" "disabled"))
  (when (not --my/vterm-scroll-lock)
    (goto-char (point-max))))

;;; Position preservation helpers

(defun my/vterm-save-position ()
  "Save current position in buffer."
  (setq --my/vterm-saved-point (point)))

(defun my/vterm-restore-position ()
  "Restore saved position if valid."
  (when (and --my/vterm-saved-point
             (>= --my/vterm-saved-point (point-min))
             (<= --my/vterm-saved-point (point-max)))
    (goto-char --my/vterm-saved-point)))

;;; Manual commands for user control

(defun my/vterm-clear-and-reset ()
  "Manually clear buffer and reset to a clean state."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (vterm-clear))
  (message "Buffer cleared and reset"))

(defun my/vterm-jump-to-bottom ()
  "Jump to the bottom of the buffer."
  (interactive)
  (goto-char (point-max))
  (recenter -1))

(defun my/vterm-emergency-truncate ()
  "Emergency truncation keeping only last 500 lines."
  (interactive)
  (let ((inhibit-read-only t))
    (save-excursion
      (goto-char (point-max))
      (forward-line -500)
      (beginning-of-line)
      (delete-region (point-min) (point))))
  (message "Emergency truncation completed"))

;;; Cleanup function

(defun my/vterm-cleanup-on-kill ()
  "Clean up timers and resources when buffer is killed."
  (when (and (boundp '--my/vterm-truncation-timer)
             --my/vterm-truncation-timer
             (timerp --my/vterm-truncation-timer))
    (cancel-timer --my/vterm-truncation-timer)
    (setq --my/vterm-truncation-timer nil))
  (when (and (boundp '--my/vterm-update-timer)
             --my/vterm-update-timer
             (timerp --my/vterm-update-timer))
    (cancel-timer --my/vterm-update-timer)
    (setq --my/vterm-update-timer nil)))

;;; Mode-specific key bindings

;; (defun my/vterm-setup-keybindings ()
;;   "Set up additional key bindings for vterm optimization control."
;;   (local-set-key (kbd "C-c C-s") #'my/vterm-toggle-scroll-lock)
;;   (local-set-key (kbd "C-c C-j") #'my/vterm-jump-to-bottom)
;;   (local-set-key (kbd "C-c C-k") #'my/vterm-clear-and-reset)
;;   (local-set-key (kbd "C-c C-t") #'my/vterm-emergency-truncate))

;;; Hook installation

;; (defun my/vterm-install-all-hooks ()
;;   "Install all vterm optimization hooks."
;;   ;; Main optimization hook
;;   (add-hook 'vterm-mode-hook #'my/vterm-optimize-for-high-throughput)

;;   ;; ;; Keybinding setup
;;   ;; (add-hook 'vterm-mode-hook #'my/vterm-setup-keybindings)

;;   ;; Cleanup hook
;;   (add-hook 'kill-buffer-hook #'my/vterm-cleanup-on-kill)

;;   ;; Text scale normalization
;;   (add-hook 'vterm-mode-hook
;;             (lambda ()
;;               (text-scale-set 0)
;;               (setq-local text-scale-mode-amount 0))))

(defun my/vterm-install-all-hooks ()
  "Install all vterm optimization hooks."
  (add-hook 'vterm-mode-hook
            (lambda ()
              (when my/vterm-optimization-enabled
                (my/vterm-optimize-for-high-throughput))))
  (add-hook 'kill-buffer-hook #'my/vterm-cleanup-on-kill)
  (add-hook 'vterm-mode-hook
            (lambda ()
              (text-scale-set 0)
              (setq-local text-scale-mode-amount 0)
              (local-set-key (kbd "C-c C-o")
                             #'my/vterm-toggle-optimization)))

  ;; Add to your hook installation
  (add-hook 'window-size-change-functions
            #'my/vterm-prevent-reflow-during-resize))

;;; Interactive commands for testing

(defun my/vterm-show-optimization-status ()
  "Show current optimization status."
  (interactive)
  (let ((status-items
         `(("Buffer size" . ,(file-size-human-readable (buffer-size)))
           ("Truncation threshold"
            . ,(file-size-human-readable my-vterm-truncation-threshold))
           ("Scroll lock"
            . ,(if --my/vterm-scroll-lock "enabled" "disabled"))
           ("Truncation timer"
            . ,(if --my/vterm-truncation-timer "active" "inactive"))
           ("GC threshold"
            . ,(file-size-human-readable gc-cons-threshold))
           ("Max scrollback" . ,vterm-max-scrollback))))
    (message "vterm optimization status:\n%s"
             (mapconcat (lambda (item)
                          (format "  %s: %s" (car item) (cdr item)))
                        status-items
                        "\n"))))

;;; Simple Toggle

(defvar my/vterm-optimization-enabled t
  "Whether vterm optimizations are enabled.")

(defun my/vterm-toggle-optimization ()
  "Toggle vterm optimization on/off."
  (interactive)
  (setq my/vterm-optimization-enabled
        (not my/vterm-optimization-enabled))
  (if my/vterm-optimization-enabled
      (progn
        (my/vterm-optimize-for-high-throughput)
        (message "vterm optimization enabled"))
    (progn
      (my/vterm-disable-optimization)
      (message "vterm optimization disabled"))))

(defun my/vterm-disable-optimization ()
  "Disable vterm optimizations and restore defaults."
  (when --my/vterm-truncation-timer
    (cancel-timer --my/vterm-truncation-timer)
    (setq --my/vterm-truncation-timer nil))
  (when --my/vterm-update-timer
    (cancel-timer --my/vterm-update-timer)
    (setq --my/vterm-update-timer nil))

  (setq vterm-timer-delay nil)
  (setq vterm-max-scrollback 10000)
  (setq vterm-disable-bold-font nil)
  (setq vterm-disable-underline nil)
  (setq vterm-disable-inverse-video nil)

  (font-lock-mode 1)
  (auto-composition-mode 1))

;;; Per-Buffer Toggle

(defvar-local --my/vterm-buffer-optimized nil
  "Whether this specific vterm buffer is optimized.")

(defun my/vterm-toggle-buffer-optimization ()
  "Toggle optimization for current vterm buffer only."
  (interactive)
  (if --my/vterm-buffer-optimized
      (my/vterm-disable-buffer-optimization)
    (my/vterm-enable-buffer-optimization)))

(defun my/vterm-enable-buffer-optimization ()
  "Enable optimization for current buffer."
  (my/vterm-optimize-for-high-throughput)
  (setq --my/vterm-buffer-optimized t)
  (message "Buffer optimization enabled"))

(defun my/vterm-disable-buffer-optimization ()
  "Disable optimization for current buffer."
  (my/vterm-disable-optimization)
  (setq --my/vterm-buffer-optimized nil)
  (message "Buffer optimization disabled"))

;;; Anti-flicker Multiline Buffering

(defvar-local --my/vterm-multiline-buffer nil
  "Buffer for collecting multiline output sequences.")

(defvar-local --my/vterm-multiline-timer nil
  "Timer for flushing multiline buffer.")

(defun my/vterm-detect-multiline-pattern (output)
  "Detect if OUTPUT looks like Ink input box redraw."
  (or (string-match-p "\033\\[\\([0-9]+\\);\\([0-9]+\\)H" output)  ; Cursor positioning
      (string-match-p "\033\\[K" output)))
                                        ; Clear to end of line
(defun my/vterm-flush-multiline-buffer ()
  "Flush accumulated multiline output."
  (when --my/vterm-multiline-buffer
    (let
        ((accumulated
          (string-join (reverse --my/vterm-multiline-buffer) "")))
      (setq --my/vterm-multiline-buffer nil)
      ;; Process accumulated output
      (vterm--process-output accumulated))))

(defun my/vterm-buffer-multiline-output (output)
  "Buffer multiline output for batched rendering."
  (when (my/vterm-detect-multiline-pattern output)
    (push output --my/vterm-multiline-buffer)

    ;; Cancel existing timer
    (when --my/vterm-multiline-timer
      (cancel-timer --my/vterm-multiline-timer))

    ;; Set new timer (5ms batching window)
    (setq --my/vterm-multiline-timer
          (run-with-timer 0.005 nil #'my/vterm-flush-multiline-buffer))

    ;; Return t to indicate we handled it
    t))

;;; Reflow prevension

(defvar-local --my/vterm-reflow-prevention-active nil
  "Whether reflow prevention is currently active.")

(defun my/vterm-prevent-reflow-during-resize (frame)
  "Temporarily prevent vterm reflow during window resize."
  (when (and (eq major-mode 'vterm-mode)
             (not --my/vterm-reflow-prevention-active))
    (setq --my/vterm-reflow-prevention-active t)

    ;; Use a named function for the advice
    (defun my/vterm--disable-window-adjust (&rest _) nil)

    (advice-add 'vterm--window-adjust-process-window-size
                :override #'my/vterm--disable-window-adjust)

    (run-with-timer 0.2 nil
                    (lambda ()
                      (advice-remove
                       'vterm--window-adjust-process-window-size
                       #'my/vterm--disable-window-adjust)
                      (setq --my/vterm-reflow-prevention-active nil)))))

;;; Initialize everything
(my/vterm-install-all-hooks)


(provide '03-ui-000-vterm-10-optimize)

(when
    (not load-file-name)
  (message "03-ui-000-vterm-10-optimize.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))