;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:55>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-frame.el

(setq frame-title-format
      '(:eval
        (let* ((host (my/find-host))
               (icon-and-color (--my/get-host-icon-and-color host))
               (icon (propertize (car icon-and-color)
                                 'face
                                 `(:family "Symbols Nerd Font Mono"
                                           :height 1.2 :foreground
                                           ,(cdr icon-and-color))))
               (title-color
                (color-lighten-name (cdr icon-and-color) 70))
               (title-text (concat
                            "   |   "
                            host
                            "   |   "
                            (if (buffer-file-name)
                                (buffer-name)
                              "%b")
                            "   |   "
                            (format-time-string "%Y-%m-%d %H:%M")
                            "   |   ")))
          (propertize title-text 'face `(:background ,title-color)))))

(setq my/frame-size-mergin 25)
(setq my/frame-size-width 1920)
(setq my/frame-size-width-half (/ my/frame-size-width 2))
(setq my/frame-size-height (- 1080 (* 2 my/frame-size-mergin)))

(if (display-graphic-p)
    (progn
      (setq initial-frame-alist
            '((width . 80)
              (height . 24)))
      (setq default-frame-alist
            '((width . 80)
              (height . 24)))))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '03-ui-000-frame)

(when
    (not load-file-name)
  (message "03-ui-000-frame.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))