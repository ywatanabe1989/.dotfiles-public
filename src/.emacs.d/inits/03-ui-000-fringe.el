;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:55>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-fringe.el

;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: 2025-01-22 19:54:53
;;; Timestamp: <2025-01-22 19:54:53>
;;; File: /home/ywatanabe/.emacs.d/inits/03-visu-000-display-fringe.el
;; fringe
(setq-default left-fringe-width 10
              right-fringe-width 0)

(defun update-fringe-size ()
  "Adjust fringe size based on window dimensions."
  (let ((num-lines (count-lines (point-min) (point-max)))
        (num-cols (window-width)))
    (cond
     ((> num-cols 1000)
      (fringe-mode '(10 . 0)))
     ((> num-cols 100)
      (fringe-mode '(8 . 0)))
     ((> num-lines 10)
      (fringe-mode '(6 . 0)))
     (t
      (fringe-mode '(16 . 0))))))

;; Add the update function to the window size change hook
(add-hook 'window-size-change-functions
          (lambda (_frame) (update-fringe-size)))

;; Update fringe size upon definition to set initial state correctly
(update-fringe-size)
;; (add-hook 'post-command-hook (lambda () (update-fringe-size)))
(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '03-ui-000-fringe)

(when
    (not load-file-name)
  (message "03-ui-000-fringe.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))