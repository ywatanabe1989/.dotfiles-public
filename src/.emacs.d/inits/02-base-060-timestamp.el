;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-01 23:49:24>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-060-timestamp.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(setq time-stamp-format "%Y-%02m-%02d %02H:%02M:%02S (%u)")

(defun time ()
  "Show current time in message buffer."
  (interactive)
  (message "%s"
           (format-time-string "%Y-%02m-%02d %02H:%02M:%02S (%a)")))

;; (use-package time-stamp
;;   :ensure t
;;   :config
;;   (setq
;;    time-stamp-active t
;;    time-stamp-line-limit 10
;;    time-stamp-format "%Y-%02m-%02d %02H:%02M:%02S (%u)\n%f"))

;; (use-package autoinsert
;;   :config
;;   (setq auto-insert-query nil)
;;   (auto-insert-mode 1)
;;   )

;; (add-hook 'write-file-hooks 'time-stamp)


(provide '02-base-060-timestamp)

(when
    (not load-file-name)
  (message "02-base-060-timestamp.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))