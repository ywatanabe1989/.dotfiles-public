(require 'recentf)
(recentf-mode 1)
;; (define-key global-map (kbd "C-c C-r") 'recentf-open-files)
(bind-key* (kbd "C-c C-r") 'recentf-open-files)

(bind-key* (kbd "C-c C-n") 'previous-buffer)
(bind-key* (kbd "C-c C-p") 'next-buffer)


;; (defun my/display-in-side-window (buffer alist)
;;   "Display BUFFER in a small side window."
;;   (display-buffer-in-side-window buffer '((side . right) (slot . 1) (window-width . 0.05))))

;; (defun my/helm-buffers-list-side-window ()
;;   "Open `helm-buffers-list` in a side window."
;;   (interactive)
;;   (let ((display-buffer-overriding-action '(my/display-in-side-window)))
;;     (helm-buffers-list)))

;; (define-key global-map (kbd "M-l") 'my/helm-buffers-list-side-window)
(use-package helm)

(defun my/partial-display (buffer alist)
  "Display BUFFER in a small side window."
  (display-buffer-in-side-window buffer '((side . bottom) (slot . 1) (window-height . 0.1))))

(defun my/helm-buffers-list ()
  "Open `helm-buffers-list` in a small window"
  (interactive)
  (let ((display-buffer-overriding-action '(my/partial-display)))
    (helm-buffers-list)))

(define-key global-map (kbd "M-l") 'my/helm-buffers-list)

;; (define-key global-map (kbd "M-l") 'helm-buffers-list)

(message "000-recentf.el was loaded.")
