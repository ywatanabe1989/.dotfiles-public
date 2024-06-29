(use-package csv-mode)

(defun my/csv-align-fields-automatically ()
  (csv-align-fields nil (point-min) (point-max)))

(add-hook 'csv-mode-hook 'my/csv-align-fields-automatically)

(defvar my/csv-aligned-view nil
  "Track the alignment status of the CSV buffer.")

(defun my/toggle-csv-view ()
  "Toggle between original and aligned CSV views."
  (interactive)
  (if my/csv-aligned-view
      (progn
        (revert-buffer :ignore-auto :noconfirm)
        (setq my/csv-aligned-view nil))
    (csv-align-fields nil (point-min) (point-max))
    (setq my/csv-aligned-view t)))

(define-key csv-mode-map (kbd "C-c C-a") 'my/toggle-csv-view)

;; (use-package csv-mode)

;; (defun my/csv-align-fields-automatically ()
;;   (csv-align-fields nil (point-min) (point-max)))
;; (add-hook 'csv-mode-hook 'my/csv-align-fields-automatically)

;; (defvar my/csv-aligned-view nil
;;   "Track the alignment status of the CSV buffer.")

;; (defun my/toggle-csv-view ()
;;   "Toggle between original and aligned CSV views."
;;   (interactive)
;;   (if my/csv-aligned-view
;;       (progn
;;         (revert-buffer :ignore-auto :noconfirm)
;;         (setq my/csv-aligned-view nil))
;;     (csv-align-fields nil (point-min) (point-max))
;;     (setq my/csv-aligned-view t)))


;; (define-key csv-mode-map (kbd "C-c C-a") 'my/toggle-csv-view)
