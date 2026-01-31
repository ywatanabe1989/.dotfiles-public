;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-16 22:03:34>
;;; File: /home/ywatanabe/.emacs.d/inits/03-ui-000-theme-zenburn.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


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
                                        ; Customize the show-paren-match face
  (custom-set-faces
   '(show-paren-match
     ((t (:background "maroon3" :foreground "white" :weight normal))))))

(my/load-zenburn-after-doom-opera)

;; ;; -*- lexical-binding: t -*-

;; (use-package doom-themes)
;; (use-package zenburn-theme)
;; ;; (use-package doom-opera
;; ;;   :ensure t
;; ;;   :config
;; ;; )

;; (show-paren-mode 1)

;; (use-package dracula-theme)

;; (load-theme 'dracula t)
;; (load-theme 'dracula nil)
;; (use-package solarized-theme
;;   :ensure t)

;; (use-package nord-theme
;;   :ensure t)

;; (use-package gruvbox-theme
;;   :ensure t)

;; ;; To load any of these themes, use:
;; ;; (load-theme 'dracula t)
;; ;; (load-theme 'solarized-dark t)
;; ;; (load-theme 'nord t)
;; ;; (load-theme 'gruvbox-dark-hard t)

;; ;; (defun my/load-zenburn-after-doom-opera ()
;; ;;   "Load themes and customize show-paren-match face."
;; ;;   (interactive)
;; ;;   (load-theme 'doom-opera t)
;; ;;   (load-theme 'zenburn t)
;; ;;   (show-paren-mode 1)
;; ;;   ; Customize the show-paren-match face
;; ;;   (custom-set-faces
;; ;;    '(show-paren-match ((t (:background "maroon3" :foreground "white" :weight normal)))))
;; ;;   )

;; ;; (my/load-zenburn-after-doom-opera)


(provide '03-ui-000-theme-zenburn)

(when
    (not load-file-name)
  (message "03-ui-000-theme-zenburn.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))