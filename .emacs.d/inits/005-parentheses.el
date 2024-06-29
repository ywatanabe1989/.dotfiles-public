(use-package highlight-parentheses)

(show-paren-mode 1)

(global-highlight-parentheses-mode)

(add-hook 'highlight-parentheses-mode-hook
          (lambda ()
            (setq autopair-handle-action-fns
                  (list 'autopair-default-handle-action
                        (lambda (action pair pos-before)
                          (hl-paren-color-update))))
            (setq hl-paren-colors
                  '("orange1" "yellow1" "greenyellow" "green1"
                    "springgreen1" "cyan1" "slateblue1" "magenta1" "purple"))))

(defun my/electric-pair-inhibit-predicate (char)
  "Inhibit automatic pair insertion if next character is not whitespace or end of line."
  (or
   (not (or (eolp)
            (looking-at "\\s-")))
   (electric-pair-default-inhibit char)))




(message "005-parentheses.el was loaded.")
