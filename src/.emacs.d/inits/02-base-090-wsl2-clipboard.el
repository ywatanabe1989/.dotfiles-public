;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-11-05 11:06:47>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-090-wsl2-clipboard.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; ;;; -*- coding: utf-8; lexical-binding: t -*-
;; ;;; Author: ywatanabe
;; ;;; Timestamp: <2025-11-05 10:52:15>
;; ;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-090-wsl2-clipboard.el

;; ;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

;; ;;; wsl-clipboard.el --- WSL-Windows clipboard integration with reconnection
;; ;;; Commentary:
;; ;; This package provides robust clipboard integration between WSL Emacs and Windows.
;; ;; It handles the common issue where clipboard connection breaks during the session.
;; ;;
;; ;; The clipboard can break due to:
;; ;; 1. WSLg/X11 server issues with PRIMARY selection
;; ;; 2. Race conditions in clipboard synchronization
;; ;; 3. Windows clipboard service interruptions
;; ;;
;; ;; Usage:
;; ;;   (require 'wsl-clipboard)
;; ;;   (wsl-clipboard-enable)
;; ;;
;; ;; To manually reconnect clipboard: M-x wsl-clipboard-reconnect

;; ;;; Code:

;; ;; ============================================================================
;; ;; Configuration Variables
;; ;; ============================================================================

;; (defvar wsl-clipboard-use-timer t
;;   "If non-nil, periodically check clipboard connection health.")

;; (defvar wsl-clipboard-timer-interval 30
;;   "Seconds between clipboard health checks (when timer is enabled).")

;; (defvar wsl-clipboard-debug nil
;;   "If non-nil, print debug messages.")

;; ;; ============================================================================
;; ;; Core Clipboard Functions
;; ;; ============================================================================

;; (defun wsl-copy-region-to-clipboard (start end)
;;   "Copy region from START to END to Windows clipboard using clip.exe."
;;   (interactive "r")
;;   (let ((text (buffer-substring-no-properties start end)))
;;     (when wsl-clipboard-debug
;;       (message "WSL: Copying %d chars to Windows clipboard"
;;                (length text)))
;;     (with-temp-buffer
;;       (insert text)
;;       ;; Use call-process-region for reliability
;;       (call-process-region (point-min) (point-max) "clip.exe" nil 0))
;;     (message "Copied to Windows clipboard")))

;; (defun wsl-paste-from-clipboard ()
;;   "Paste from Windows clipboard using PowerShell Get-Clipboard."
;;   (interactive)
;;   (let* ((coding-system-for-read 'dos)
;;          (clip (shell-command-to-string
;;                 "powershell.exe -NoProfile -Command Get-Clipboard 2>/dev/null")))
;;     ;; Remove trailing newline added by PowerShell
;;     (when (string-suffix-p "\n" clip)
;;       (setq clip (substring clip 0 -1)))
;;     (when (and clip (> (length clip) 0))
;;       (when wsl-clipboard-debug
;;         (message "WSL: Pasting %d chars from Windows clipboard"
;;                  (length clip)))
;;       (insert clip)
;;       clip)))

;; ;; ============================================================================
;; ;; Automatic Integration Functions
;; ;; ============================================================================

;; (defun wsl-copy-to-clipboard-advice (&rest _args)
;;   "Automatically copy kill-ring to Windows clipboard.
;; This is used as :after advice on kill-new."
;;   (when (and (fboundp 'wsl-running-p) (wsl-running-p))
;;     (condition-case err
;;         (let ((text (current-kill 0 t)))
;;           (when (and text (> (length text) 0))
;;             (with-temp-buffer
;;               (insert text)
;;               (call-process-region (point-min) (point-max)
;;                                    "clip.exe" nil 0))))
;;       (error
;;        (when wsl-clipboard-debug
;;          (message "WSL clipboard sync failed: %s" err))))))

;; ;; ============================================================================
;; ;; Clipboard Health Check and Reconnection
;; ;; ============================================================================

;; (defun wsl-clipboard-test ()
;;   "Test if clipboard connection is working.
;; Returns t if working, nil otherwise."
;;   (condition-case err
;;       (let ((test-string "wsl-clipboard-test-string"))
;;         ;; Try to write to clipboard
;;         (with-temp-buffer
;;           (insert test-string)
;;           (call-process-region (point-min) (point-max)
;;                                "clip.exe" nil 0))
;;         ;; Try to read from clipboard
;;         (let* ((coding-system-for-read 'dos)
;;                (result (shell-command-to-string
;;                         "powershell.exe -NoProfile -Command Get-Clipboard 2>/dev/null")))
;;           (string-match-p test-string result)))
;;     (error
;;      (when wsl-clipboard-debug
;;        (message "Clipboard test failed: %s" err))
;;      nil)))

;; (defun wsl-clipboard-reconnect ()
;;   "Attempt to reconnect/reset the WSL-Windows clipboard connection.
;; This function tries multiple approaches to restore clipboard functionality."
;;   (interactive)
;;   (message "Reconnecting WSL clipboard...")

;;   (condition-case err
;;       (progn
;;         ;; Method 1: Reset selections (fixes WSLg PRIMARY selection bug)
;;         (when (fboundp 'gui-set-selection)
;;           (gui-set-selection 'PRIMARY nil)
;;           (gui-set-selection 'CLIPBOARD nil))

;;         ;; Method 2: Re-enable clipboard settings
;;         (setq select-enable-clipboard t)
;;         (setq select-enable-primary nil)
;;         (setq select-active-regions nil)  ; Prevents WSLg PRIMARY bug

;;         ;; Method 3: Reset interprogram functions
;;         (setq interprogram-cut-function #'gui-select-text)
;;         (setq interprogram-paste-function #'gui-selection-value)

;;         ;; Method 4: Kill and restart clipboard-related processes (if GUI)
;;         (when (display-graphic-p)
;;           ;; This is a no-op but forces Emacs to re-establish connection
;;           (ignore-errors
;;             (x-change-window-property "_NET_WM_STATE" nil nil nil nil
;;                                       nil)))

;;         ;; Test the connection
;;         (if (wsl-clipboard-test)
;;             (message "WSL clipboard reconnected successfully!")
;;           (message
;;            "Clipboard reconnection attempted. Try: M-x wsl-clipboard-manual-fix")))
;;     (error
;;      (message "Error reconnecting clipboard: %s" err))))

;; (defun wsl-clipboard-manual-fix ()
;;   "Interactive guide for manual clipboard fixes.
;; Shows common issues and solutions."
;;   (interactive)
;;   (with-output-to-temp-buffer "*WSL Clipboard Help*"
;;     (princ "WSL-Emacs Clipboard Troubleshooting Guide\n")
;;     (princ "=========================================\n\n")
;;     (princ "If automatic reconnection didn't work, try these:\n\n")
;;     (princ "1. RESTART WSLG (from Windows PowerShell):\n")
;;     (princ "   wsl.exe --shutdown\n")
;;     (princ "   (Then restart your WSL session)\n\n")
;;     (princ "2. CHECK CLIPBOARD COMMANDS:\n")
;;     (princ "   Try manually: echo test | clip.exe\n")
;;     (princ "   Then in Windows: Ctrl+V\n\n")
;;     (princ "3. VERIFY WSLG IS RUNNING:\n")
;;     (princ "   ps aux | grep wslg\n\n")
;;     (princ "4. UPDATE WSL:\n")
;;     (princ "   wsl.exe --update (in Windows PowerShell)\n\n")
;;     (princ "5. TEMPORARY WORKAROUND:\n")
;;     (princ "   Use: M-x wsl-copy-region-to-clipboard\n")
;;     (princ "   And: M-x wsl-paste-from-clipboard\n\n")
;;     (princ "6. RESTART EMACS:\n")
;;     (princ "   If all else fails, save and restart Emacs\n\n")
;;     (princ "Current Status:\n")
;;     (princ (format "  Clipboard test: %s\n"
;;                    (if (wsl-clipboard-test) "WORKING" "FAILED")))
;;     (princ (format "  Display: %s\n"
;;                    (if (display-graphic-p) "GUI" "Terminal")))
;;     (princ
;;      (format "  select-enable-clipboard: %s\n" select-enable-clipboard))
;;     (princ
;;      (format "  select-active-regions: %s\n" select-active-regions))))

;; ;; ============================================================================
;; ;; Timer-based Health Monitoring
;; ;; ============================================================================

;; (defvar wsl-clipboard-timer nil
;;   "Timer for periodic clipboard health checks.")

;; (defvar wsl-clipboard-last-check-time nil
;;   "Time of last clipboard health check.")

;; (defvar wsl-clipboard-failure-count 0
;;   "Number of consecutive clipboard test failures.")

;; (defun wsl-clipboard-health-check ()
;;   "Periodically check clipboard health and auto-reconnect if needed."
;;   (when (and (fboundp 'wsl-running-p) (wsl-running-p))
;;     (setq wsl-clipboard-last-check-time (current-time))
;;     (unless (wsl-clipboard-test)
;;       (setq wsl-clipboard-failure-count
;;             (1+ wsl-clipboard-failure-count))
;;       (when (>= wsl-clipboard-failure-count 2)
;;         (when wsl-clipboard-debug
;;           (message
;;            "Clipboard health check failed, attempting reconnection..."))
;;         (wsl-clipboard-reconnect)
;;         (setq wsl-clipboard-failure-count 0)))
;;     ;; Reset counter on success
;;     (when (and (wsl-clipboard-test) (> wsl-clipboard-failure-count 0))
;;       (setq wsl-clipboard-failure-count 0))))

;; (defun wsl-clipboard-start-timer ()
;;   "Start periodic clipboard health monitoring."
;;   (interactive)
;;   (when wsl-clipboard-timer
;;     (cancel-timer wsl-clipboard-timer))
;;   (setq wsl-clipboard-timer
;;         (run-with-timer wsl-clipboard-timer-interval
;;                         wsl-clipboard-timer-interval
;;                         #'wsl-clipboard-health-check))
;;   (message "WSL clipboard health monitoring started (every %ds)"
;;            wsl-clipboard-timer-interval))

;; (defun wsl-clipboard-stop-timer ()
;;   "Stop periodic clipboard health monitoring."
;;   (interactive)
;;   (when wsl-clipboard-timer
;;     (cancel-timer wsl-clipboard-timer)
;;     (setq wsl-clipboard-timer nil)
;;     (message "WSL clipboard health monitoring stopped")))

;; ;; ============================================================================
;; ;; WSL Detection
;; ;; ============================================================================

;; (defun wsl-running-p ()
;;   "Return t if running under WSL."
;;   (and (eq system-type 'gnu/linux)
;;        (or (getenv "WSL_DISTRO_NAME")
;;            (getenv "WSLENV")
;;            (string-match-p "microsoft"
;;                            (shell-command-to-string "uname -r")))))

;; ;; ============================================================================
;; ;; Enable/Disable Functions
;; ;; ============================================================================

;; (defun wsl-clipboard-enable ()
;;   "Enable WSL-Windows clipboard integration with auto-reconnect."
;;   (interactive)
;;   (when (wsl-running-p)
;;     (message "Enabling WSL clipboard integration...")

;;     ;; Fix WSLg PRIMARY selection bug
;;     (setq select-active-regions nil)
;;     (setq select-enable-clipboard t)
;;     (setq select-enable-primary nil)

;;     ;; Add automatic clipboard sync on kill
;;     (advice-add 'kill-new :after #'wsl-copy-to-clipboard-advice)

;;     ;; Set up key bindings
;;     (global-set-key (kbd "C-c w c") #'wsl-copy-region-to-clipboard)
;;     (global-set-key (kbd "C-c w v") #'wsl-paste-from-clipboard)
;;     (global-set-key (kbd "C-c w r") #'wsl-clipboard-reconnect)
;;     (global-set-key (kbd "C-c w h") #'wsl-clipboard-manual-fix)

;;     ;; Start health monitoring if enabled
;;     (when wsl-clipboard-use-timer
;;       (wsl-clipboard-start-timer))

;;     (message
;;      "WSL clipboard enabled. Use 'C-c w r' to reconnect if needed.")))

;; (defun wsl-clipboard-disable ()
;;   "Disable WSL-Windows clipboard integration."
;;   (interactive)
;;   (when (wsl-running-p)
;;     ;; Stop health monitoring
;;     (wsl-clipboard-stop-timer)

;;     ;; Remove advice
;;     (advice-remove 'kill-new #'wsl-copy-to-clipboard-advice)

;;     ;; Remove key bindings
;;     (global-unset-key (kbd "C-c w c"))
;;     (global-unset-key (kbd "C-c w v"))
;;     (global-unset-key (kbd "C-c w r"))
;;     (global-unset-key (kbd "C-c w h"))

;;     (message "WSL clipboard integration disabled")))

;; ;; ============================================================================
;; ;; Status Display
;; ;; ============================================================================

;; (defun wsl-clipboard-status ()
;;   "Display current WSL clipboard status."
;;   (interactive)
;;   (message
;;    "WSL Clipboard Status: %s | Health Monitor: %s | Last Check: %s"
;;    (if (wsl-clipboard-test) "OK" "FAILED")
;;    (if wsl-clipboard-timer "ACTIVE" "INACTIVE")
;;    (if wsl-clipboard-last-check-time
;;        (format-time-string "%H:%M:%S"
;;                            wsl-clipboard-last-check-time)
;;      "Never")))

;; ;; ============================================================================
;; ;; Auto-enable if running under WSL
;; ;; ============================================================================

;; ;; Uncomment the following line to auto-enable on startup:
;; (when (wsl-running-p) (wsl-clipboard-enable))

;; ;;; wsl-clipboard.el ends here

;; ;; (global-set-key (kbd "C-c C-y") 'wsl-paste-from-clipboard)

;; (provide '02-base-090-wsl2-clipboard)

;; (when
;;     (not load-file-name)
;;   (message "02-base-090-wsl2-clipboard.el loaded."
;;            (file-name-nondirectory
;;             (or load-file-name buffer-file-name))))


(provide '02-base-090-wsl2-clipboard)

(when
    (not load-file-name)
  (message "02-base-090-wsl2-clipboard.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))