;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-02 09:50:39>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-004-gc.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; Garbage Collection
(setq gc-cons-threshold
      (* 1024 1024 100))
                                        ; Set garbage collection threshold to 100MB
(setq garbage-collection-messages nil)
                                        ; Disable GC messages
(setq large-file-warning-threshold 100000000)
                                        ; Set large file warning to 100MB


(provide '01-core-004-gc)

(when
    (not load-file-name)
  (message "01-core-004-gc.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))