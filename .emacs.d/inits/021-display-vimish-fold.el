(use-package vimish-fold

  :config
  (define-prefix-command 'my/vimish-fold-map)
  (vimish-fold-global-mode 1)
  (set-face-attribute 'vimish-fold-overlay nil
                      :background "gray40"
  )

  (define-key global-map (kbd "C-S-f f") 'vimish-fold)
  (define-key global-map (kbd "C-S-f u") 'vimish-fold-unfold)
  (define-key global-map (kbd "C-S-f r") 'vimish-fold-refold)
  (define-key global-map (kbd "C-S-f a r") 'vimish-fold-refold-all)
  (define-key global-map (kbd "C-S-f a f") 'vimish-fold-all)
  (define-key global-map (kbd "C-S-f a u") 'vimish-fold-unfold-all)
  (define-key global-map (kbd "C-S-f d") 'vimish-fold-delete)
  )


;; (defun my/vimish-fold-toggle ()
;;   "Toggle folding at the current point. Select the unfolded region automatically."
;;   (interactive)
;;   ;; Check if the point is inside an existing fold.
;;   (if (cl-some (lambda (ov) (eq (overlay-get ov 'type) 'vimish-fold--folded))
;;                (overlays-at (point)))
;;       ;; If inside a fold, unfold it and select the unfolded region.
;;       (let* ((ov (cl-find-if (lambda (ov) (eq (overlay-get ov 'type) 'vimish-fold--folded))
;;                              (overlays-at (point))))
;;              (beg (overlay-start ov))
;;              (end (overlay-end ov)))
;;         (vimish-fold-unfold)
;;         (goto-char beg)
;;         (push-mark end nil t))  ; The 't' argument activates the mark.
;;     ;; If not inside a fold, try to fold the region or current line.
;;     (let ((region-active (use-region-p))
;;           (beg (if (use-region-p) (region-beginning) (line-beginning-position)))
;;           (end (if (use-region-p) (region-end) (line-end-position))))
;;       (vimish-fold-delete)
;;       (vimish-fold beg end))))



(message "023-display-vimish-fold.el was loaded.")
