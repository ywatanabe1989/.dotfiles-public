;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-17 23:13:22>
;;; File: /home/ywatanabe/.emacs.d/inits/03-ui-000-color.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun my/contrast-color (bg-color)
  (interactive)
  "Return white or black depending on the brightness of BG-COLOR."
  (if
      (> (color-distance bg-color "white")
         (color-distance bg-color "black"))
      "light gray"
    "gray10"))

(defun my/color-display ()
  (interactive)
  "Display colors with code"
  (list-colors-display))

;; (my/contrast-color "#000000")

;; (list-colors-display)


(provide '03-ui-000-color)

(when
    (not load-file-name)
  (message "03-ui-000-color.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))