;; (use-package image-dired)

;; (auto-image-file-mode 1) ; ???

;; Configure image-mode behaviors
(add-hook 'image-mode-hook
  (lambda ()
    ;; (auto-revert-mode 1)  ; Enable auto-reverting for image files
    (setq buffer-read-only nil)
    (setq kill-buffer-query-functions
          (lambda () t))
    (image-transform-fit-to-window)
  ))

;;
;; (add-hook 'image-mode-hook
;;           (lambda ()
;;             (setq buffer-file-coding-system 'binary)
;;             (image-flush (image-get-display-property))
;;             ))

;; (image-flush (image-get-display-property))

(message "004-image.el was loaded.")
