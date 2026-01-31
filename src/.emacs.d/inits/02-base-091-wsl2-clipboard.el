;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-12-20 08:11:04>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-091-wsl2-clipboard.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;;; Commentary:
;; WSL2-specific clipboard functions that bypass gui-get-selection.
;; This avoids timeout issues with X11/Wayland clipboard in WSL2.
;;
;; Usage:
;;   (wsl-get-clipboard)     ; Get clipboard content as string
;;   (wsl-yank)              ; Insert clipboard content at point
;;
;; Integration with ecc:
;;   (setq ecc-clipboard-function #'wsl-get-clipboard)

;;; Code:

(defgroup wsl-clipboard nil
  "WSL2 clipboard integration via PowerShell."
  :group 'convenience
  :prefix "wsl-clipboard-")

(defcustom wsl-clipboard-timeout 5
  "Timeout in seconds for PowerShell clipboard operations."
  :type 'integer
  :group 'wsl-clipboard)

(defcustom wsl-clipboard-debug nil
  "When non-nil, show debug messages for clipboard operations."
  :type 'boolean
  :group 'wsl-clipboard)

;; (defun wsl-get-clipboard ()
;;   "Get text from Windows clipboard via PowerShell.
;; Bypasses gui-get-selection to avoid timeout issues in WSL2.
;; Returns clipboard content as string, or nil if empty/error."
;;   (condition-case err
;;       (let* ((cmd "powershell.exe -NoProfile -Command 'Get-Clipboard' 2>/dev/null")
;;              (content (with-timeout (wsl-clipboard-timeout nil)
;;                         (shell-command-to-string cmd))))
;;         (when (and content (> (length content) 0))
;;           ;; Clean up Windows line endings
;;           (setq content (replace-regexp-in-string "\r" "" content))
;;           ;; Remove trailing newline
;;           (when (string-suffix-p "\n" content)
;;             (setq content (substring content 0 -1)))
;;           (when wsl-clipboard-debug
;;             (message "wsl-get-clipboard: got %d chars" (length content)))
;;           content))
;;     (error
;;      (when wsl-clipboard-debug
;;        (message "wsl-get-clipboard error: %s" (error-message-string err)))
;;      nil)))

(defun wsl-get-clipboard ()
  "Get Windows clipboard content via powershell (for WSL).
Uses process buffer with timeout to avoid hanging.
Handles Japanese and other Unicode characters via UTF-8 encoding."
  (when (file-exists-p "/proc/sys/fs/binfmt_misc/WSLInterop")
    (let ((buf (generate-new-buffer " *clipboard*")))
      (unwind-protect
          (progn
            (let* ((coding-system-for-read 'utf-8)
                   (proc (start-process "get-clipboard" buf
                                        "powershell.exe" "-NoProfile"
                                        "-Command"
                                        "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; Get-Clipboard")))
              (accept-process-output proc 2)
              (when (process-live-p proc)
                (kill-process proc)))
            (with-current-buffer buf
              (let ((content (string-trim (buffer-string))))
                (unless (string-empty-p content)
                  content))))
        (kill-buffer buf)))))

;; ;; Japanese not handled
;; (defun wsl-get-clipboard ()
;;   "Get Windows clipboard content via powershell (for WSL).
;; Uses process buffer with timeout to avoid hanging."
;;   (when (file-exists-p "/proc/sys/fs/binfmt_misc/WSLInterop")
;;     (let ((buf (generate-new-buffer " *clipboard*")))
;;       (unwind-protect
;;           (progn
;;             (let ((proc (start-process "get-clipboard" buf
;;                                        "powershell.exe" "-NoProfile"
;;                                        "-Command"
;;                                        "Get-Clipboard")))
;;               (accept-process-output proc 2)
;;               (when (process-live-p proc)
;;                 (kill-process proc)))
;;             (with-current-buffer buf
;;               (let ((content (string-trim (buffer-string))))
;;                 (unless (string-empty-p content)
;;                   content))))
;;         (kill-buffer buf)))))

(defun wsl-yank ()
  "Yank text from Windows clipboard at point.
Uses PowerShell to bypass gui-get-selection timeout issues."
  (interactive)
  (let ((content (wsl-get-clipboard)))
    (if content
        (progn
          (insert content)
          (message "Yanked %d chars from Windows clipboard"
                   (length content)))
      (message "Windows clipboard is empty or unavailable"))))

(defun wsl-clipboard-to-kill-ring ()
  "Copy Windows clipboard content to Emacs kill-ring.
Useful for syncing Windows clipboard to Emacs."
  (interactive)
  (let ((content (wsl-get-clipboard)))
    (if content
        (progn
          (kill-new content)
          (message "Copied %d chars to kill-ring" (length content)))
      (message "Windows clipboard is empty or unavailable"))))

(defun wsl-get-latest-content ()
  "Get the most recently copied content from Windows clipboard or kill-ring.
If Windows clipboard differs from kill-ring, Windows clipboard is newer.
Otherwise use kill-ring (faster, and they're in sync)."
  (let ((win-clip (wsl-get-clipboard))
        (emacs-kill (car kill-ring)))
    (cond
     ;; Windows clipboard has different content = externally copied
     ((and win-clip emacs-kill (not (string= win-clip emacs-kill)))
      (when wsl-clipboard-debug
        (message
         "wsl: using Windows clipboard (differs from kill-ring)"))
      win-clip)
     ;; Kill-ring has content
     (emacs-kill
      (when wsl-clipboard-debug
        (message "wsl: using kill-ring"))
      emacs-kill)
     ;; Fallback to Windows clipboard
     (win-clip
      (when wsl-clipboard-debug
        (message "wsl: using Windows clipboard (kill-ring empty)"))
      win-clip))))

;; Integration with ecc-clipboard-function
(with-eval-after-load 'ecc-vterm-yank-as-file
  (setq ecc-clipboard-function #'wsl-get-latest-content))


(provide '02-base-091-wsl2-clipboard)

(when
    (not load-file-name)
  (message "02-base-091-wsl2-clipboard.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))