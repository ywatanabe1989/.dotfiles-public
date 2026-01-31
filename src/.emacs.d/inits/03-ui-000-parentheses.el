;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:09:06>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-parentheses.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2025-03-04 06:11:10 (ywatanabe)>
;;; File: ./.dotfiles/.emacs.d/inits/005-parentheses.el

(use-package highlight-parentheses)

(show-paren-mode 1)

(global-highlight-parentheses-mode)

(add-hook 'highlight-parentheses-mode-hook
          (lambda
            ()
            (setq autopair-handle-action-fns
                  (list 'autopair-default-handle-action
                        (lambda
                          (action pair pos-before)
                          (hl-paren-color-update))))
            (setq hl-paren-colors
                  '("orange1"
                    "yellow1"
                    "greenyellow"
                    "green1"
                    "springgreen1"
                    "cyan1"
                    "slateblue1"
                    "magenta1"
                    "purple"))
            (custom-set-faces
             '(show-paren-match
               ((t
                 (:background "maroon3" :foreground "white" :weight
                              normal)))))))

(defun my/electric-pair-inhibit-predicate
    (char)
  "Inhibit automatic pair insertion if next character is not whitespace or end of line."
  (or
   (not
    (or
     (eolp)
     (looking-at "\\s-")))
   (electric-pair-default-inhibit char)))

(setq electric-pair-inhibit-predicate
      'my/electric-pair-inhibit-predicate)
(electric-pair-mode -1)

(use-package mic-paren
  :ensure
  t
  :config
  (paren-activate)
  (setq paren-highlight-offscreen t)
  (setq paren-sexp-mode t))

(custom-set-faces
 '(paren-face-match
   ((t
     (:background "maroon3" :foreground "white" :weight normal))))
 '(paren-face-mismatch
   ((t
     (:background "red" :foreground "white"))))
 '(paren-face-no-match
   ((t
     (:background "yellow" :foreground "black")))))

(when
    (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '03-ui-000-parentheses)

(when
    (not load-file-name)
  (message "03-ui-000-parentheses.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))