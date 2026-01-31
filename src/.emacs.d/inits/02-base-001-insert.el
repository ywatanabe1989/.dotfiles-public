;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-07-20 07:59:23>
;;; File: /home/ywatanabe/.emacs.d/inits/02-base-001-insert.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun my/insert-current-datetime ()
  (interactive)
  (insert (format-time-string "%Y%m%d_%H%M%S")))


(provide '02-base-001-insert)

(when
    (not load-file-name)
  (message "02-base-001-insert.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))