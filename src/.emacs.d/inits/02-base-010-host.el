;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:11>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-010-host.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-07 15:16:30>
;;; File: ./.dotfiles/.emacs.d/inits/010-host.el

;; (defun --my/find-host-file-dired ()
;;   "Return the host name of the current buffer."
;;   (interactive)
;;   (let* ((default-directory (or (buffer-file-name) default-directory))
;;          (remote-host (when (file-remote-p default-directory)
;;                         (tramp-file-name-host (tramp-dissect-file-name default-directory))))
;;          (host (or remote-host (system-name))))
;;     (format "%s" host)))

;; (defun my/find-host ()
;;   (interactive)
;;   "Find host based on mode."
;;   (let ((host (if (eq major-mode 'term-mode)
;;                   (--my/term-estimate-remote-host)
;;                 (--my/find-host-file-dired))))
;;     ;; (message host)
;;     host))

;; ;; (defun my/find-host-file-dired ()
;; ;;   "Return the host name of the current buffer."
;; ;;   (interactive)
;; ;;   (let* ((default-directory (or (buffer-file-name) default-directory))
;; ;;         (remote-host (when (file-remote-p default-directory)
;; ;;                        (tramp-file-name-host (tramp-dissect-file-name default-directory))))
;; ;;         (host (or remote-host (system-name))))
;; ;;     (format "%s" host)))

;; ;; (defun my/find-host ()
;; ;;   if termmode:
;; ;;   let host my/term-estimate-remote-host
;; ;;   else:
;; ;;   let host my/find-host-file-dired
;; ;;   message host
;; ;;   return host
;; ;;   )

;; ;; (defun my/find-host ()
;; ;;   "Return the host name of the current buffer."
;; ;;   (interactive)
;; ;;   (cond
;; ;;    ((eq major-mode 'term-mode)
;; ;;     (message (my/term-estimate-remote-host))
;; ;;     (my/term-estimate-remote-host))
;; ;;    (t
;; ;;     (let* ((default-directory (or (buffer-file-name) default-directory))
;; ;;            (remote-host (when (file-remote-p default-directory)
;; ;;                           (file-remote-p default-directory 'host)))
;; ;;            (host (or remote-host (system-name))))
;; ;;       (message host)
;; ;;       host))))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-010-host)

(when
    (not load-file-name)
  (message "02-base-010-host.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))