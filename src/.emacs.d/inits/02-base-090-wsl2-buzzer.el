;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-14 05:28:12>
;;; File: /home/ywatanabe/.emacs.d/inits/02-base-090-wsl2-buzzer.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

;;; Implement WSL2-compatible buzzer function

(defvar my/wsl2-powershell-buzzer-script
  "[console]::beep(750,300); [console]::beep(750,300); [console]::beep(750,300)"
  "PowerShell script that makes beep sounds on Windows host.")

(defun my/wsl2-powershell-beep ()
  "Play a beep sound on Windows host system through PowerShell."
  (interactive)
  (call-process "powershell.exe" nil nil nil
                "-Command" my/wsl2-powershell-buzzer-script))

(defun my/vterm-beep-function ()
  "Play beep sound when in vterm, otherwise respect visual bell settings."
  (when (and (boundp 'vterm-mode) (derived-mode-p 'vterm-mode))
    (my/wsl2-powershell-beep)))

;; Set the beep function globally
(setq vterm-bell-function 'my/vterm-beep-function)

;; Create a custom command to replace buzzer.sh inside vterm

(defun my/vterm-buzzer-command (msg)
  "Send a buzzer command that works in vterm with the specified MSG."
  (interactive "sMessage: ")
  (when (derived-mode-p 'vterm-mode)
    (my/wsl2-powershell-beep)
    (vterm-send-string
     (format "echo -e '\\033[1;31m%s\\033[0m'\n" msg))))

;; ;; Add to vterm mode
;; (with-eval-after-load 'vterm
;;   (defun my/setup-vterm-buzzer ()
;;     "Setup a working buzzer in vterm."
;;     ;; Add an alias for the wsl2-buzzer.sh script
;;     (vterm-send-string "
;; # Add alias for the WSL2 buzzer script
;; if [ -f \"$HOME/.bin/utils/wsl2-buzzer.sh\" ]; then
;;   alias buzzer=\"$HOME/.bin/utils/wsl2-buzzer.sh\"
;; fi
;; "))

;;   ;; Add the setup hook to vterm
;;   (add-hook 'vterm-mode-hook 'my/setup-vterm-buzzer))

;; Custom buzzer test function

(defun my/test-wsl2-buzzer ()
  "Test if the buzzer works in the current vterm buffer."
  (interactive)
  (if (derived-mode-p 'vterm-mode)
      (progn
        (my/wsl2-powershell-beep)
        (vterm-send-string
         "echo -e '\\033[1;31mBuzzer test successful\\033[0m'\n"))
    (message "This command only works in vterm buffers")))

;; ;; Optional: Add key binding for testing
;; (with-eval-after-load 'vterm
;;   (define-key vterm-mode-map (kbd "C-c C-b") 'my/test-wsl2-buzzer))

(provide '02-base-090-wsl2-buzzer)

(when
    (not load-file-name)
  (message "02-base-090-wsl2-buzzer.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))
