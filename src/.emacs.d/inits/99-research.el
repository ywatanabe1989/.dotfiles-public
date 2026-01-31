;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-28 17:46:36>
;;; File: /home/ywatanabe/.emacs.d/inits/99-research.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun dev ()
  ""
  (interactive)
  (etm-open-neurovista)
  (etm-open-pdf)
  (etm-open-contents)
  (etm-open-fig)
  (etm-open-tables))


(provide '99-research)

(when
    (not load-file-name)
  (message "99-research.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))