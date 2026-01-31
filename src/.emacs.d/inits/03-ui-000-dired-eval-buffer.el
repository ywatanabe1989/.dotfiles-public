;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-06 02:30:18>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-dired-eval-buffer.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun my/dired-eval-selected-files ( )
  "Evaluate all marked files as elisp."
  (interactive)
  (let ((files (dired-get-marked-files))
        (count 0))
    (dolist (file files)
      (when (string-match-p "\\.el$" file)
        (with-current-buffer (find-file-noselect file)
          (eval-buffer)
          (kill-buffer))
        (message "Evaluated %s" file)
        (setq count (1+ count))))
    (message "Evaluated %d elisp file(s)" count)))


(provide '03-ui-000-dired-eval-buffer)

(when
    (not load-file-name)
  (message "03-ui-000-dired-eval-buffer.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))
