
;; (defface my-yellow-highlight
;;   '((t :background "yellow" :foreground "black"))
;;   "Face for highlighting multibyte characters with a yellow background.")

;; (defun my/visualize-specific-characters ()
;;   "Highlight specific characters in the current buffer."
;;   (interactive)
;;   (save-excursion
;;     (goto-char (point-min))
;;     (while (not (eobp))
;;       (let ((char (char-after)))
;;         (when (member char '(?# ?_))  ; Add other characters to the list if needed
;;           (overlay-put (make-overlay (point) (1+ (point))) 'face 'my-yellow-highlight))
;;         (forward-char 1)))))

(defface my-yellow-highlight
  '((t :background "yellow" :foreground "black"))
  "Face for highlighting multibyte characters with a yellow background.")

;; (defface my-transparent-highlight
;;   '((t :background "unspecified-bg" :foreground "unspecified-fg"))
;;   "Face for making the overlay transparent.")

;; (defun my/toggle-overlay-face (ov)
;;   "Toggle the face of the overlay OV between `highlight` and `default`."
;;   (overlay-put ov 'face (if (eq (overlay-get ov 'face) 'highlight)
;;                             'default
;;                           'highlight)))

;; (defun my/remove-flashing-overlay (start end)
;;   "Remove the flashing overlay from START to END."
;;   (interactive "r")
;;   (remove-overlays start end))

;; (defun my/toggle-overlay-face (ov)
;;   "Toggle the face of the overlay between highlighted and transparent."
;;   (if (eq (overlay-get ov 'face) 'my-yellow-highlight)
;;       (overlay-put ov 'face 'my-transparent-highlight)
;;     (overlay-put ov 'face 'my-yellow-highlight)))

;; (defun my/flash-overlay (ov interval)
;;   "Flash the overlay OV at INTERVAL seconds."
;;   (when (overlayp ov)
;;     (my/toggle-overlay-face ov)
;;     (run-with-timer interval nil 'my/flash-overlay ov interval)))

;; (defun my/escape-and-flash ()
;;   "Escape specific characters in the buffer by adding a backslash before them and flash them."
;;   (interactive)
;;   (save-excursion
;;     (goto-char (point-min))
;;     (while (search-forward-regexp "\\([^\\]\\|^\\)\\([#_]\\)" nil t)
;;       (let ((start (match-beginning 2))  ; Start of the character to escape
;;             (end (match-end 2)))         ; End of the character to escape
;;         (replace-match "\\1\\\\\\2" nil nil)
;;         ;; Create an overlay to flash the escaped character
;;         (let ((ov (make-overlay start (+ end 1))))  ; Adjust end to include the newly added backslash
;;           (my/flash-overlay ov 0.5)))))  ; Flash duration of 0.5 seconds

(defun my/visualize-specific-characters ()
  "Highlight specific characters in the current buffer and make them flash."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (let ((char (char-after)))
        (when (member char '(?# ?_ ?&))  ; Add other characters to the list if needed
          (let ((ov (make-overlay (point) (1+ (point)))))
            (overlay-put ov 'face 'my-yellow-highlight)
            ))
        (forward-char 1)))))

;; (add-hook 'before-save-hook 'my/visualize-specific-characters)

;; (defun my/replace-newlines-with-double-backslashes-and-newline ()
;;   "Replace all newline characters in the current buffer with double backslashes followed by a newline."
;;   (interactive)
;;   (save-excursion
;;     (goto-char (point-min))
;;     (while (search-forward "\n" nil t)
;;       (replace-match "\\\\
;; " nil t))))

(defun my/replace (search-exp replace-exp)
  (interactive "sEnter search expression: \nsEnter replace expression: ")  ;; [REVISED]
  (save-excursion
    (goto-char (point-min))
    (while (search-forward search-exp nil t)
      (replace-match replace-exp nil t))))



(defun my/tex-revise ()
  (interactive)
  (my/delete-trailing-whitespace)
  (my/visualize-specific-characters)

  (my/replace "\\\\" "")
  (my/replace "\n" "\\\\
")
  (my/replace "{\\\\" "{")
  (my/replace "}\\\\" "}")
  (my/replace "_" "\_")
  (my/replace "#" "\#")
  (my/replace "&" "\&")
  (my/replace "[" "{[")
  (my/replace "]" "]}")
  (my/replace "–" "--")
  (my/replace "−" "$-$")
  (my/replace "±" "$±$")
  (my/delete-trailing-whitespace)  
  )
;; Unicode character − (U+2212)


(defvar my-en-dash "–" "Variable to hold the en dash character.")
(defvar my-em-dash "—" "Variable to hold the em dash character.")

(message "171-latex-revision.el was loaded.")
