;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-07-01 04:21:54>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-701-change-host.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; (defun my/change-host (hostname)
;;   "Connect to a given hostname via SSH, or operate locally if 'localhost' is selected."
;;   (interactive (list (--my/ssh-select-host)))
;;   (if (equal hostname "localhost")
;;       (find-file (my/path-get-path))
;;     (let* ((host-info (--my/get-host-info hostname))
;;            (username (car host-info))
;;            (final-path (--my/ssh-rename-username
;;                         (concat "/ssh:" username "@" hostname ":" (my/path-get-path))
;;                         hostname)))
;;       (message final-path)
;;       (find-file final-path))))

;; (defun my/change-host (hostname)
;;   "Connect to a given hostname via SSH, or operate locally if hostname is in --my/local-host-names."
;;   (interactive (list (--my/ssh-select-host)))
;;   (if (or (equal hostname "localhost")
;;           (member hostname --my/local-host-names))
;;       (find-file (my/path-get-path))
;;     (let* ((host-info (--my/get-host-info hostname))
;;            (username (car host-info))
;;            (final-path (--my/ssh-rename-username
;;                         (concat "/ssh:" username "@" hostname ":" (my/path-get-path))
;;                         hostname)))
;;       (message final-path)
;;       (find-file final-path))))

(defun my/change-host (hostname)
  "Connect to a given hostname via SSH, or operate locally if hostname is in --my/local-host-names."
  (interactive (list (--my/ssh-select-host)))
  (message "Selected hostname: %s" hostname)
  (message "Local host names: %s" --my/local-host-names)
  (if (or (equal hostname "localhost")
          (member hostname --my/local-host-names))
      (progn
        (message "Using local path: %s" (my/path-get-path))
        (find-file (my/path-get-path)))
    (let* ((host-info (--my/get-host-info hostname))
           (username (car host-info))
           (path (my/path-get-path))
           (final-path (--my/ssh-rename-username
                        (concat "/ssh:" username "@" hostname ":" path)
                        hostname)))
      (message "Host info: %s" host-info)
      (message "Username: %s" username)
      (message "Path: %s" path)
      (message "Final path: %s" final-path)
      (find-file final-path))))

(defun --my/ssh-select-host ()
  "Select an SSH host from the SSH configuration files in ~/.ssh/conf.d and ~/.ssh/config, with an option for localhost."
  (interactive)
  (let*
      ((command
        "rg 'Host' ~/.ssh/conf.d/*.conf ~/.ssh/config | grep -v 'HostName' | awk -F' ' '!/^#/ && !seen[$NF]++ {print $NF}' 2> /dev/null")
       (hosts
        (split-string (shell-command-to-string command) "\n" t))
       (host-list (cons "localhost" hosts)))
    (if host-list
        (completing-read "Choose host: " host-list)
      (progn
        (message "No hosts found")
        nil))))

(defun --my/get-host-info (hostname)
  (interactive)
  "Get username and hostname for the given host from SSH config files."
  (let*
      ((command
        (format
         "awk '/^Host.*%s$/,/^$/ {if ($1 == \"User\") print $2; if ($1 == \"HostName\") print $2}' ~/.ssh/config ~/.ssh/conf.d/*.conf 2>/dev/null"
         hostname))
       (output (string-trim (shell-command-to-string command)))
       (lines (split-string output "\n" t))
       (username (if (> (length lines) 0) (car lines) "ywatanabe"))
       (hostname (if (> (length lines) 1) (cadr lines) hostname)))
    (cons username hostname)))

(global-set-key (kbd "C-M-h") 'my/change-host)


(provide '02-base-701-change-host)

(when
    (not load-file-name)
  (message "02-base-701-change-host.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))