;; -*- lexical-binding: t -*-

;; Custom functions
(defun my/left ()
  "Move the frame to left half"
  (interactive)
  (set-frame-position (selected-frame) 0 my/frame-size-mergin)
  (set-frame-size nil my/frame-size-width-half my/frame-size-height t)
  )

(defun my/right ()
  "Move the frame to right half"
  (interactive)
  ;; (set-frame-position nil (- 0 my/frame-size-width-half) my/frame-size-mergin)
  (set-frame-position (selected-frame) my/frame-size-width-half my/frame-size-mergin)
  (set-frame-size nil my/frame-size-width-half my/frame-size-height t)
  )

(defun my/maximize ()
  "Maximize the frame"
  (interactive)
  (set-frame-position (selected-frame) 0 my/frame-size-mergin)
  (set-frame-size nil my/frame-size-width my/frame-size-height t)
  )

;; Windows-like alignment
(define-key global-map (kbd "C-<left>") 'my/left)
(define-key global-map (kbd "C-<right>") 'my/right)
(define-key global-map (kbd "C-<up>") 'my/maximize)

;;;; Buffer size
(global-set-key (kbd "M-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "M-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "M-<up>") 'enlarge-window)
(global-set-key (kbd "M-<down>") 'shrink-window)

;; ;; Text
;; (define-key global-map (kbd "C--") 'text-scale-decrease)
;; (define-key global-map (kbd "C-0") 'text-scale-adjust)
;; (define-key global-map (kbd "C-+") 'text-scale-increase)


;; Text
(defun my/zoom-in ()
  (interactive)
  (let ((new-height (+ (face-attribute 'default :height) 10)))
    (set-face-attribute 'default nil :height new-height)
    (redraw-display)))

(defun my/zoom-out ()
  (interactive)
  (let ((new-height (- (face-attribute 'default :height) 10)))
    (when (> new-height 0)
      (set-face-attribute 'default nil :height new-height)
      (redraw-display))))

(defun my/zoom-default ()
  (interactive)
  (set-face-attribute 'default nil :height 100)
  (redraw-display))

(bind-key* (kbd "C-+") 'my/zoom-in)
(bind-key* (kbd "C--") 'my/zoom-out)
(bind-key* (kbd "C-0") 'my/zoom-default)


;; Open Emacs with a maximized frame
;; (my/maximize)

(message "022-display-size.el was loaded.")
