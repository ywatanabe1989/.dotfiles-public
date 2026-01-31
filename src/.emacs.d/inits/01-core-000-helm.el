;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-27 17:03:28>
;;; File: /home/ywatanabe/.emacs.d/inits/01-core-000-helm.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(global-set-key (kbd "C-c M-x") 'helm-M-x)


(provide '01-core-000-helm)

(when
    (not load-file-name)
  (message "01-core-000-helm.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))