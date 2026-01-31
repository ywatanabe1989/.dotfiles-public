(require 'outline)
(defvar markdown-mode-map (make-sparse-keymap))
(defvar gfm-mode-map (make-sparse-keymap))

;; Mock functions/vars
(defun indent-for-tab-command () (interactive) (message "Indent"))
(defun markdown-code-block-at-point-p () 
  (let ((face (get-text-property (point) 'face)))
    (or (eq face 'markdown-pre-face)
        (eq face 'markdown-code-face))))
(defun markdown-inline-code-at-point-p () nil)
(defun mmm-overlays-at (pos) nil) ; Assume failing for now

;; User's function (simplified from previous state)
(defun my/markdown-outline-toggle ()
  "Toggle outline visibility at point."
  (interactive)
  (if (or (markdown-code-block-at-point-p)
          (markdown-inline-code-at-point-p)
          (and (fboundp 'mmm-overlays-at)
               (mmm-overlays-at (point))))
      (indent-for-tab-command)
    (let ((h2+ (save-excursion
                 (beginning-of-line)
                 (when (looking-at "^##") (point)))))
          (h1 (save-excursion
                (beginning-of-line)
                (when (looking-at "^# [^#]") (point)))))
      (cond
       (h2+ (message "Toggle H2"))
       (h1 (message "Toggle H1"))
       (t (indent-for-tab-command))))))

(with-temp-buffer
  ;; Setup content
  (insert "# Header 1\n\nSome text\n\n```python\n# Comment\nprint('hi')\n```\n")
  
  ;; Case 1: On Header 1
  (goto-char (point-min))
  (message "Line 1: %s" (buffer-substring (line-beginning-position) (line-end-position)))
  (my/markdown-outline-toggle)
  
  ;; Case 2: Inside code block on comment
  (search-forward "# Comment")
  (beginning-of-line)
  (message "Line 5: %s" (buffer-substring (line-beginning-position) (line-end-position)))
  ;; Simulate no text properties yet (failure of markdown-mode fontification)
  (my/markdown-outline-toggle)
  
  ;; Case 3: Simulate text properties present
  (put-text-property (line-beginning-position) (line-end-position) 'face 'markdown-code-face)
  (message "Line 5 (with face): %s" (buffer-substring (line-beginning-position) (line-end-position)))
  (my/markdown-outline-toggle)
)
