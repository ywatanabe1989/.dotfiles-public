;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-04-30 12:38:41>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-modeline-flash.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun --my/flash-mode-line (color-str &optional n-flash)
  "Flash the mode line's background color temporarily.
COLOR-STR specifies the color to flash.
N_FLASH optionally specifies the number of times to flash."
  (interactive
   "sEnter flash color: \nnNumber of flashes (default 1): ")
  (let* ((original-color (face-background 'mode-line))
         (flash-color color-str)
         (count (or n-flash 1))
         (is-remote
          (and (buffer-file-name) (file-remote-p (buffer-file-name)))))
    (unless is-remote
      (dotimes (i count)
        (set-face-background 'mode-line flash-color)
        (redisplay)
        (sleep-for 0.05)
        (set-face-background 'mode-line original-color)
        (redisplay)
        (sleep-for 0.05)))))


(provide '03-ui-000-modeline-flash)

(when
    (not load-file-name)
  (message "03-ui-000-modeline-flash.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))