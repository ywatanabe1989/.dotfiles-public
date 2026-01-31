;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-27 17:03:31>
;;; File: /home/ywatanabe/.emacs.d/inits/01-core-001-package-03-package-install-from-URL.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(require 'package)

(defun my/download-el-to-lisp-dir (url)
  "Download .el file from URL and save it to ~/.emacs.d/lisp/."
  (let* ((filename (file-name-nondirectory url))
         (lisp-dir "~/.emacs.d/lisp/")
         (local-path (concat lisp-dir filename)))
    (unless (file-directory-p lisp-dir)
      (make-directory lisp-dir t))
    (url-copy-file url local-path t)
    (message "Downloaded %s to %s" filename lisp-dir)))


(provide '01-core-001-package-03-package-install-from-URL)

(when
    (not load-file-name)
  (message "01-core-001-package-03-package-install-from-URL.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))