;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-27 17:03:28>
;;; File: /home/ywatanabe/.emacs.d/inits/01-core-000-error.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(setq debug-on-error nil)


(provide '01-core-000-error)

(when
    (not load-file-name)
  (message "01-core-000-error.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))