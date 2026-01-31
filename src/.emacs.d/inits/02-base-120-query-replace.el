;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:14>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-120-query-replace.el

;; ;; -*- lexical-binding: t -*-

(defun my/ez-query-replace-region
    ()
  "Custom version of `ez-query-replace` that applies the replacement only to the selected region."
  (interactive)
  (if
      (use-region-p)
      (let*
          ((from-string
            (read-from-minibuffer
             "Replace what (in selected region)? "
             (ez-query-replace/dwim-at-point)))
           (to-string
            (read-from-minibuffer
             (format "Replace %s with what? " from-string)))
           (description
            (format "%s -> %s"
                    (ez-query-replace/truncate from-string)
                    (ez-query-replace/truncate to-string)))
           (history-entry
            (list description from-string to-string))
           (start
            (region-beginning))
           (end
            (region-end)))
        (save-excursion
          (goto-char start)
          (ez-query-replace/backward from-string)
          (ez-query-replace/remember description from-string to-string)
          (deactivate-mark)
          (perform-replace from-string to-string t nil nil start end)))
    (my/ez-query-replace-whole-buffer)))
;; (message "No region selected")))
(defun my/ez-query-replace-whole-buffer
    ()
  "Custom version of `ez-query-replace` that applies the replacement to the entire buffer."
  (interactive)
  (let*
      ((from-string
        (read-from-minibuffer "Replace what (in the entire buffer)? "
                              (ez-query-replace/dwim-at-point)))
       (to-string
        (read-from-minibuffer
         (format "Replace %s with what? " from-string)))
       (description
        (format "%s -> %s"
                (ez-query-replace/truncate from-string)
                (ez-query-replace/truncate to-string)))
       (history-entry
        (list description from-string to-string)))
    (goto-char
     (point-min))
    (ez-query-replace/backward from-string)
    (ez-query-replace/remember description from-string to-string)
    (deactivate-mark)
    (perform-replace from-string to-string t nil nil)))

;; (defun my/ez-query-replace-region
;;     (&optional use-regexp)
;;   "Custom version of `ez-query-replace` that applies the replacement only to the selected region.
;; With prefix argument, use regexp matching."
;;   (interactive "P")
;;   (if
;;       (use-region-p)
;;       (let*
;;           ((from-string
;;             (read-from-minibuffer
;;              (if use-regexp
;;                  "Replace regexp (in selected region)? "
;;                "Replace what (in selected region)? ")
;;              (ez-query-replace/dwim-at-point)))
;;            (to-string
;;             (read-from-minibuffer
;;              (format "Replace %s with what? " from-string)))
;;            (description
;;             (format "%s -> %s"
;;                     (ez-query-replace/truncate from-string)
;;                     (ez-query-replace/truncate to-string)))
;;            (history-entry
;;             (list description from-string to-string))
;;            (start
;;             (region-beginning))
;;            (end
;;             (region-end)))
;;         (save-excursion
;;           (goto-char start)
;;           (ez-query-replace/backward from-string)
;;           (ez-query-replace/remember description from-string to-string)
;;           (deactivate-mark)
;;           (perform-replace from-string to-string t use-regexp nil start end)))
;;     (my/ez-query-replace-whole-buffer use-regexp)))

;; (defun my/ez-query-replace-whole-buffer
;;     (&optional use-regexp)
;;   "Custom version of `ez-query-replace` that applies the replacement to the entire buffer.
;; With prefix argument, use regexp matching."
;;   (interactive "P")
;;   (let*
;;       ((from-string
;;         (read-from-minibuffer
;;          (if use-regexp
;;              "Replace regexp (in the entire buffer)? "
;;            "Replace what (in the entire buffer)? ")
;;          (ez-query-replace/dwim-at-point)))
;;        (to-string
;;         (read-from-minibuffer
;;          (format "Replace %s with what? " from-string)))
;;        (description
;;         (format "%s -> %s"
;;                 (ez-query-replace/truncate from-string)
;;                 (ez-query-replace/truncate to-string)))
;;        (history-entry
;;         (list description from-string to-string)))
;;     (goto-char
;;      (point-min))
;;     (ez-query-replace/backward from-string)
;;     (ez-query-replace/remember description from-string to-string)
;;     (deactivate-mark)
;;     (perform-replace from-string to-string t use-regexp nil)))

(define-key global-map
            (kbd "M-%")
            'ez-query-replace)

(define-key global-map
            (kbd "M-$")
            'my/ez-query-replace-region)

(when
    (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-120-query-replace)

(when
    (not load-file-name)
  (message "02-base-120-query-replace.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))