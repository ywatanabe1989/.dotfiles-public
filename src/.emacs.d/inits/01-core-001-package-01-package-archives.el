;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-27 17:03:30>
;;; File: /home/ywatanabe/.emacs.d/inits/01-core-001-package-01-package-archives.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/")
             t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/")
             t)
(add-to-list 'package-archives
             '("gnu" . "https://elpa.gnu.org/packages/")
             t)
(add-to-list 'package-archives
             '("nongnu" . "https://elpa.nongnu.org/nongnu/")
             t)

;; (package-refresh-contents)


(provide '01-core-001-package-01-package-archives)

(when
    (not load-file-name)
  (message "01-core-001-package-01-package-archives.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))