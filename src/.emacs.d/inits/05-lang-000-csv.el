;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-18 19:15:29>
;;; File: /home/ywatanabe/.emacs.d/inits/05-lang-000-csv.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun my/csv-mode-hook
    ()
  ;; (csv-align-fields)
  )

(defun my/csv-toggle-comma-visibility ()
  "Toggle visibility of commas in CSV mode."
  (interactive)
  (if (member ?, csv-separators)
      (setq csv-separators (remove ?, csv-separators))
    (push ?, csv-separators))
  (csv-reformat-buffer)
  (message "Commas are now %s"
           (if (member ?, csv-separators) "visible" "hidden")))

;; Add keybinding for toggling comma visibility
(with-eval-after-load 'csv-mode
  (define-key csv-mode-map (kbd "C-c C-,")
              'my/csv-toggle-comma-visibility))

;; In hard-aligned records, separators become invisible whenever
;; `buffer-invisibility-spec' is non-nil.  In soft-aligned records, make
;; separators invisible if and only if `buffer-invisibility-spec' is
;; non-nil when the records are aligned; this can be changed only by
;; re-aligning.  (Unaligning always makes separators visible.)

;; When called non-interactively, use hard alignment if HARD is non-nil;
;; BEG and END specify the region to align.
;; If there is no selected region, default to the whole buffer. (cons current-prefix-arg (if (use-region-p) (list (region-beginning) (region-end)) (list (point-min) (point-max))))] 0)

;; C-c C-v
;; csv-toggle-invisibility


(provide '05-lang-000-csv)

(when
    (not load-file-name)
  (message "05-lang-000-csv.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))