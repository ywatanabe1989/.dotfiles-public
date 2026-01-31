;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2026-01-02 13:27:57>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-000-emacs-server.el

;;; Copyright (C) 2026 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun my/server-get-file ()
  "Get the current server file location."
  (interactive)
  (let
      ((server-path (expand-file-name server-name server-socket-dir)))
    (message "Current Emacs server is here: %s" server-path)
    (message
     "Try emacsclient --socket-name=\"%s\" --eval '(message \"Test connection\")'"
     server-path)
    server-path))

(setq server-socket-dir (getenv "EMACS_SOCKET_DIR"))

;; /home/ywatanabe/.emacs.d/server
(server-start)

;; DISPLAY=:0 && /opt/emacs-30.1/bin/emacsclient -Q -cn -s /home/ywatanabe/.emacs.d/server/server


(provide '01-core-000-emacs-server)

(when
    (not load-file-name)
  (message "01-core-000-emacs-server.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))