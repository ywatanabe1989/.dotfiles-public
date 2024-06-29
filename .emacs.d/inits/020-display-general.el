;; -*- lexical-binding: t -*-

;; fringe
(fringe-mode '(8 . 0))

(defun update-fringe-size ()
  "Adjust fringe size based on window dimensions."
  (let ((num-lines (count-lines (point-min) (point-max)))
        (num-cols (window-width)))
    (cond
     ((> num-cols 1000)
      (fringe-mode '(8 . 0)))
     ((> num-cols 100)
      (fringe-mode '(6 . 0)))
     ((> num-lines 100)
      (fringe-mode '(4 . 0)))
     (t
      (fringe-mode '(16 . 0))))))

;; Add the update function to the window size change hook
(add-hook 'window-size-change-functions (lambda (_frame) (update-fringe-size)))

;; Update fringe size upon definition to set initial state correctly
(update-fringe-size)

;; Font
(set-frame-font "DejaVu Sans Mono-11" nil t)

;; Column number
(column-number-mode t)

;; Line number
(global-display-line-numbers-mode t)
(setq display-line-numbers "%4d \u2502 ")

;; Highlight line
(defface my/hl-line-face
  '((((class color) (background dark))
     (:background "NavyBlue" t))
    (((class color) (background light))
     (:background "LightSkyBlue" t))
    (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my/hl-line-face)
(global-hl-line-mode t)


;; Display Encoding
(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")

;; Parenthesis
;; (show-paren-mode t)
(show-paren-mode 0)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)

;; Time
(display-time-mode t)
(display-time)
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)

;; Battery
(display-battery-mode nil)

;; Frame
(setq frame-title-format
      '(:eval (concat
               "   |   "
               (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b")
               "   |   "
               (system-name)
               "   |   "
               (format-time-string "%Y-%m-%d %H:%M")
               "   |   "
               )))

(setq my/frame-size-mergin 25)
(setq my/frame-size-width 1920)
(setq my/frame-size-width-half (/ my/frame-size-width 2))
(setq my/frame-size-height (- 1080 (* 2 my/frame-size-mergin)))

;; Disable menu bar, tool bar, and scroll bar
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq mode-line-format t)

;; fixme
(setq default-frame-alist (cons '(tool-bar-lines . 0) default-frame-alist))
(setq initial-frame-alist (cons '(tool-bar-lines . 0) initial-frame-alist))


;; Indent
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; Highlight indent
(use-package highlight-indent-guides
  :ensure t
  :config
  (setq highlight-indent-guides-method 'character)
  (setq highlight-indent-guides-character 124)
  (setq highlight-indent-guides-responsive 'top)
  (setq highlight-indent-guides-auto-enabled nil)
  (setq highlight-indent-guides-delay 0)

  ;; Set faces for the guides
  (set-face-background 'highlight-indent-guides-odd-face "dimgray")
  (set-face-background 'highlight-indent-guides-even-face "dimgray")
  (set-face-foreground 'highlight-indent-guides-character-face "dimgray")
  (set-face-background 'highlight-indent-guides-top-odd-face "darkgray")
  (set-face-background 'highlight-indent-guides-top-even-face "darkgray")
  (set-face-foreground 'highlight-indent-guides-top-character-face "darkgray"))


(defun my/flash-mode-line (color-str &optional n-flash)
  (interactive)
  "Flash the mode line's background color temporarily.
COLOR-STR specifies the color to flash.
N_FLASH optionally specifies the number of times to flash."
  (interactive "sEnter flash color: \nnNumber of flashes (default 1): ")
  (let ((original-color (face-background 'mode-line))
        (flash-color color-str)
        (count (or n-flash 1)))
    (dotimes (i count)
      (set-face-background 'mode-line flash-color)
      (redisplay)
      (sleep-for 0.05)
      (set-face-background 'mode-line original-color)
      (redisplay)
      (sleep-for 0.05))))


(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)

(defun my/enable-company-for-files ()
  "Enable company-mode for specific files."
  (when (and (buffer-file-name)
             (string-match-p "\\.myext\\'" (buffer-file-name)))
    (company-mode 1)))

(add-hook 'find-file-hook 'vc-find-file-hook)
(add-hook 'find-file-hook 'my/enable-company-for-files)

(message "029-display-general.el was loaded.")
