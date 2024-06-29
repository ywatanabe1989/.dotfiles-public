;; -*- lexical-binding: t -*-

(use-package doom-themes)
(use-package zenburn-theme)
(show-paren-mode 1)

(defun my/load-zenburn-after-doom-opera ()
  "Load themes and customize show-paren-match face."
  (interactive)
  (load-theme 'doom-opera t)
  (load-theme 'zenburn t)
  (show-paren-mode 1)
  ;; Customize the show-paren-match face
  (custom-set-faces
   '(show-paren-match ((t (:background "#2F4F4F" :weight normal)))))
  )

(my/load-zenburn-after-doom-opera)

(message "021_display-zenburn.el was loaded.")
