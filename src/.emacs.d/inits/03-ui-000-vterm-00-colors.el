;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-20 18:15:30>
;;; File: /home/ywatanabe/.emacs.d/inits/03-ui-000-vterm-00-colors.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defvar-local my/vterm-grayscale-mode nil
  "When non-nil, vterm is in grayscale mode.")

(defun --my/vterm-set-colors ()
  (interactive)
  (setq vterm-term-environment-variable "xterm-256color")
  (setq vterm-truecolor-support t)

  ;; Standard ANSI terminal colors
  (setq vterm-color-black   "#000000")
  (setq vterm-color-red     "#CD0000")
  ;; (setq vterm-color-green   "#00CD00")
  (setq vterm-color-green   "#55AA55")
  (setq vterm-color-yellow  "#CDCD00")
  ;; (setq vterm-color-blue    "#0000EE")
  (setq vterm-color-blue    "#5555AA")
  (setq vterm-color-magenta "#CD00CD")
  (setq vterm-color-cyan    "#00CDCD")
  (setq vterm-color-white   "#E5E5E5")

  ;; Custom faces for better visibility
  (custom-set-faces
   '(vterm-color-green
     ((t (:foreground "#00CD00" :background "#005F00"))))
   '(vterm-color-bright-green
     ((t (:foreground "#00FF00" :background "#008000"))))
   '(vterm-color-blue
     ((t (:foreground "#5C5CFF" :background "#00008F"))))
   ;; '(vterm-color-bright-blue
   ;;   ((t (:foreground "#8080FF" :background "#0000AF"))))
   '(vterm-color-bright-blue
     ((t (:foreground "#6A6ADB" :background "#00008F"))))))

(defun my/vterm-toggle-grayscale ()
  "Toggle between color and grayscale modes in vterm."
  (interactive)
  (let ((grayscale-mode
         (not my/vterm-grayscale-mode)))
    (setq-local my/vterm-grayscale-mode grayscale-mode)

    ;; Apply the appropriate color scheme
    (if grayscale-mode
        ;; Switch to grayscale colors
        (progn
          (setq-local vterm-color-black   "#000000")
          (setq-local vterm-color-red     "#707070")
          (setq-local vterm-color-green   "#909090")
          (setq-local vterm-color-yellow  "#a0a0a0")
          (setq-local vterm-color-blue    "#808080")
          (setq-local vterm-color-magenta "#b0b0b0")
          (setq-local vterm-color-cyan    "#c0c0c0")
          (setq-local vterm-color-white   "#ffffff")
          ;; Bright variants
          (setq-local vterm-color-bright-black   "#303030")
          (setq-local vterm-color-bright-red     "#888888")
          (setq-local vterm-color-bright-green   "#a8a8a8")
          (setq-local vterm-color-bright-yellow  "#b8b8b8")
          (setq-local vterm-color-bright-blue    "#989898")
          (setq-local vterm-color-bright-magenta "#c8c8c8")
          (setq-local vterm-color-bright-cyan    "#d8d8d8")
          (setq-local vterm-color-bright-white   "#ffffff"))
      ;; Switch back to color mode
      (--my/vterm-set-colors))

    ;; Force terminal to refresh with new colors
    (vterm-clear)
    (message "Vterm grayscale mode: %s"
             (if grayscale-mode "enabled" "disabled"))))

;; (defun my/vterm-toggle-grayscale ()
;;   "Toggle between color and grayscale modes in vterm."
;;   (interactive)
;;   (let ((colors-inhibit (not (or
;;                               (bound-and-true-p vterm-colors-inhibit)
;;                               (bound-and-true-p
;;                                ansi-colors-disabled)))))
;;     (setq-local vterm-colors-inhibit colors-inhibit)
;;     ;; Also set ansi-color variables for compatibility
;;     (setq-local ansi-colors-disabled colors-inhibit)
;;     (message "Vterm grayscale mode: %s"
;;              (if colors-inhibit "enabled" "disabled"))
;;     (vterm-reset-cursor-point)))

(--my/vterm-set-colors)


(provide '03-ui-000-vterm-00-colors)

(when
    (not load-file-name)
  (message "03-ui-000-vterm-00-colors.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))