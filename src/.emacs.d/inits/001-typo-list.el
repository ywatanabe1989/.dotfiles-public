;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-10-09 23:56:48>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/001-typo-list.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(setq my/typo-replacements '(
                             ("aab" . "aab")
                             ("patient" . "patient")
                             ("import" . "import")
                             ("without" . "without")
                             ("patient" . "patient")
                             ("patient_id" . "patient_id")
                             ("import" . "import")
                             ("import" . "import")
                             ("Exception" . "Exception")
                             ("import" . "import")
                             ("import" . "import")
                             ("hello" . "hello")))
"A list of common typos and their corrections."


(provide '001-typo-list)

(when
    (not load-file-name)
  (message "001-typo-list.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))