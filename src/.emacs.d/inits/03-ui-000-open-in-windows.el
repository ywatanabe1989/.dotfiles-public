;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:09:06>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-open-in-windows.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-07 15:16:28>
;;; File: ./.dotfiles/.emacs.d/inits/002-open-in-windows.el

(defun my/open-in-windows (file)
  "Open FILE using the default Windows application, supporting TRAMP paths."
  (interactive)
  (let* ((filename (file-name-nondirectory file))
         (win-downloads "/win/downloads")
         (temp-file (expand-file-name filename win-downloads)))
    (if (file-remote-p file)
        (with-temp-buffer
          (insert-file-contents-literally file)
          (write-region (point-min) (point-max) temp-file))
      (copy-file file temp-file t))
    (set-file-modes temp-file #o644)
    (let*
        ((windows-temp-file
          (string-trim
           (shell-command-to-string
            (format "wslpath -w \"%s\"" temp-file))))
         (process (start-process "open-windows-file" nil
                                 "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
                                 "-Command"
                                 (format
                                  "Start-Process '%s' -WindowStyle Hidden"
                                  windows-temp-file))))
      (set-process-sentinel
       process
       (lambda (proc event)
         (when (string= event "finished\n")
           (message "File opened successfully")))))))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '03-ui-000-open-in-windows)

(when
    (not load-file-name)
  (message "03-ui-000-open-in-windows.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))