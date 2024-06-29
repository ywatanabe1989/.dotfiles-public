;; -*- lexical-binding: t -*-

(defun my/ez-query-replace-region ()
  "Custom version of `ez-query-replace` that applies the replacement only to the selected region."
  (interactive)
  (if (use-region-p)
      (let* ((from-string (read-from-minibuffer "Replace what (in selected region)? " (ez-query-replace/dwim-at-point)))
             (to-string (read-from-minibuffer
                         (format "Replace %s with what? " from-string)))
             (description (format "%s -> %s"
                                  (ez-query-replace/truncate from-string)
                                  (ez-query-replace/truncate to-string)))
             (history-entry (list description from-string to-string))
             (start (region-beginning))
             (end (region-end)))
        (save-excursion
          (goto-char start)
          (ez-query-replace/backward from-string)
          (ez-query-replace/remember description from-string to-string)
          (deactivate-mark)
          (perform-replace from-string to-string t nil nil start end)))
    (my/ez-query-replace-whole-buffer)))
    ;; (message "No region selected")))


(defun my/ez-query-replace-whole-buffer ()
  "Custom version of `ez-query-replace` that applies the replacement to the entire buffer."
  (interactive)
  (let* ((from-string (read-from-minibuffer "Replace what (in the entire buffer)? " (ez-query-replace/dwim-at-point)))
         (to-string (read-from-minibuffer
                     (format "Replace %s with what? " from-string)))
         (description (format "%s -> %s"
                              (ez-query-replace/truncate from-string)
                              (ez-query-replace/truncate to-string)))
         (history-entry (list description from-string to-string)))
    (goto-char (point-min))
    (ez-query-replace/backward from-string)
    (ez-query-replace/remember description from-string to-string)
    (deactivate-mark)
    (perform-replace from-string to-string t nil nil)))



(define-key global-map (kbd "M-%") 'ez-query-replace)
;; (define-key global-map (kbd "M-$") 'my/ez-query-replace-whole-buffer)
(define-key global-map (kbd "M-$") 'my/ez-query-replace-region)

(message "120-query-replace.el was loaded.")
