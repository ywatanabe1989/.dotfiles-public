;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-27 17:03:29>
;;; File: /home/ywatanabe/.emacs.d/inits/01-core-001-buffer-reload.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;;; Time-stamp: <2024-11-24 17:22:35 (ywatanabe)>

;;; Time-stamp: <2024-11-18 11:43:01 (ywatanabe)>

(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive)
  (revert-buffer :ignore-auto :noconfirm))

;; (global-set-key [f5] 'revert-buffer-no-confirm)

(global-set-key [f5] 'revert-buffer-quick)


(provide '01-core-001-buffer-reload)

(when
    (not load-file-name)
  (message "01-core-001-buffer-reload.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))