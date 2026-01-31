;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-19 01:39:21>
;;; File: /home/ywatanabe/.emacs.d/inits/03-ui-000-vterm-10-clear.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun my/vterm-clear-buffer ()
  "Clear the vterm buffer completely."
  (interactive)
  (vterm-clear))
;; (vterm-send-string "\033c"))


(provide '03-ui-000-vterm-10-clear)

(when
    (not load-file-name)
  (message "03-ui-000-vterm-10-clear.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))