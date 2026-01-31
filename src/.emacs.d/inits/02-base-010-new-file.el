;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:12>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-010-new-file.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-07 15:16:31>
;;; File: ./.dotfiles/.emacs.d/inits/010-new-file.el

(defun my/is-new-file ()
  "Check if the current buffer is a new file by checking if it's empty."
  (and buffer-file-name
       (not buffer-read-only)
       (or (not (file-remote-p buffer-file-name))
           (and (file-remote-p buffer-file-name)
                (not (file-exists-p buffer-file-name))))
       (= (point-min) (point-max))))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-010-new-file)

(when
    (not load-file-name)
  (message "02-base-010-new-file.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))