;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:14>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-110-org-00-update.el

;;; -*- lexical-binding: t -*-
;;; Author: 2024-12-26 14:01:12
;;; Time-stamp: <2024-12-26 14:01:12 (ywatanabe)>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/100-editing/110-org/110-update.el

(use-package org
  :pin
  gnu)

;; Install org from GNU ELPA
(unless (package-installed-p 'org)
  (package-refresh-contents)
  (package-install 'org))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-110-org-00-update)

(when
    (not load-file-name)
  (message "02-base-110-org-00-update.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))