;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-01 16:27:01>
;;; File: /home/ywatanabe/.emacs.d/inits/90-mine.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun sakana ()
  (interactive)
  (sakana1)
  (sakana2)
  (sakana3)
  (sakana4)
  (sakana5))


(provide '90-mine)

(when
    (not load-file-name)
  (message "90-mine.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))