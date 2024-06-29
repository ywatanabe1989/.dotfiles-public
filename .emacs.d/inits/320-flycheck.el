(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode)
  :config
  ;; General Configuration
  (setq flycheck-highlighting-mode 'lines)

  ;; Enable Emacs Lisp checker explicitly
  (setq-default flycheck-disabled-checkers
                (remove 'emacs-lisp flycheck-disabled-checkers))

  ;; Python Configuration
  (setq-default flycheck-disabled-checkers '(python-pylint python-pycompile))
  (setq-default flycheck-checkers '(python-flake8))
  (setq flycheck-python-flake8-executable "/home/ywatanabe/envs/py3/bin/python3")
  (setq flycheck-flake8rc "/home/ywatanabe/.config/flake8")

  ;; JavaScript/TypeScript Configuration
  (setq flycheck-javascript-eslint-executable "/usr/bin/eslint")
  (flycheck-add-mode 'javascript-eslint 'typescript-mode)
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . web-mode))
  (add-hook 'web-mode-hook
            (lambda ()
              (when (or (string-equal "tsx" (file-name-extension buffer-file-name))
                        (string-equal "ts" (file-name-extension buffer-file-name)))
                (setq flycheck-checker 'javascript-eslint)))))

(use-package flycheck-pos-tip
  :ensure t
  :after flycheck
  :config
  (flycheck-pos-tip-mode))

(use-package flycheck-posframe
  :ensure t
  :after flycheck
  :config
  (flycheck-posframe-configure-pretty-defaults)
  (setq flycheck-posframe-warning-prefix "\u26a0 ") ; ⚠
  (setq flycheck-posframe-error-prefix "x ") ; x
  (setq flycheck-posframe-background-face "red")
  (setq flycheck-posframe-border-width 0)
  (setq flycheck-pos-tip-timeout 3)
  (setq flycheck-posframe-position 'window-bottom-left-corner)
  (add-hook 'flycheck-mode-hook #'flycheck-posframe-mode))

(defun my/flycheck-error-detected ()
  "Flash the mode line red when Flycheck detects an error."
  (when (seq-some (lambda (err) (eq (flycheck-error-level err) 'error))
                  flycheck-current-errors)
    (my/flash-mode-line "red" 2)))

(defun my/flash-mode-line (color duration)
  "Flash the mode line with COLOR for DURATION seconds."
  (let ((prev-bg (face-background 'mode-line)))
    (set-face-background 'mode-line color)
    (run-with-timer duration nil
                    (lambda (col) (set-face-background 'mode-line col))
                    prev-bg)))

(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'flycheck-after-syntax-check-hook 'my/flycheck-error-detected)
(add-hook 'emacs-lisp-mode-hook 'flycheck-mode)

;; (use-package flycheck-pos-tip)
;; (use-package flycheck-posframe
;;   :ensure t
;;   :after flycheck
;;   :config
;;   (flycheck-posframe-configure-pretty-defaults)
;;   (add-hook 'flycheck-mode-hook #'flycheck-posframe-mode))


;; ;; Flycheck Configuration (Emacs)
;; (setq flycheck-posframe-warning-prefix "\u26a0 ") ; ⚠
;; (setq flycheck-posframe-error-prefix "x ") ; x
;; (setq flycheck-posframe-background-face "red")
;; (setq flycheck-posframe-border-width 0)
;; (setq flycheck-pos-tip-timeout 3)
;; (setq flycheck-posframe-position 'window-bottom-left-corner)
;; ;; (setq flycheck-posframe-position 'window-top-right-corner)
;; ; (setq flycheck-posframe-position 'window-bottom-left-corner)
;; ; (setq flycheck-posframe-position 'point-top-left-corner)


;; (use-package flycheck
;;   :ensure t
;;   :init
;;   (global-flycheck-mode)
;;   (flycheck-pos-tip-mode nil)
;;   (flycheck-posframe-mode)

;;   :config
;;   ;; (require 'flycheck-pos-tip)
;;   ;; (flycheck-posframe-mode)
;;   ;; (flycheck-pos-tip-mode nil)
;;   (setq flycheck-highlighting-mode 'lines)

;;   ;; Python
;;   (setq-default flycheck-disabled-checkers '(python-pylint python-pycompile))
;;   (setq-default flycheck-checkers '(python-flake8))
;;   (setq flycheck-python-flake8-executable "/home/ywatanabe/envs/py3/bin/python3")
;;   (setq flycheck-flake8rc "/home/ywatanabe/.config/flake8")

;;   ;; JavaScript and TypeScript
;;   (setq flycheck-javascript-eslint-executable "/usr/bin/eslint")
;;   (flycheck-add-mode 'javascript-eslint 'typescript-mode)
;;   (flycheck-add-mode 'javascript-eslint 'web-mode)
;;   (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . web-mode))
;;   (add-hook 'web-mode-hook
;;             (lambda ()
;;               (when (or (string-equal "tsx" (file-name-extension buffer-file-name))
;;                         (string-equal "ts" (file-name-extension buffer-file-name)))
;;                 (setq flycheck-checker 'javascript-eslint)))))

;; (with-eval-after-load 'flycheck
;;   (flycheck-pos-tip-mode nil)
;;   (flycheck-posframe-mode)
;;   )

(defun my/flycheck-next-error-cyclic (&optional n)
  "Go to the next Flycheck error cyclically, ignoring warnings.
If N is given, move to the N-th next error. If N is negative, move to the N-th previous error."
  (interactive "P")
  (let* ((n (or n 1))
         (current-pos (point))
         (errors (flycheck-error-list-current-errors))
         (errors-pos (mapcar (lambda (err) (flycheck-error-pos err)) errors))
         (errors-pos (sort errors-pos #'<))
         (next-pos (or (car (seq-filter (lambda (pos) (> pos current-pos)) errors-pos))
                       (car errors-pos))))
    (if next-pos
        (progn
          (goto-char next-pos)
          (when (> current-pos next-pos)
            (message "Wrapped to first error")))
      (message "No errors found in buffer"))))

;; (defun my/flycheck-next-error-cyclic (&optional n)
;;   "Go to the next Flycheck error cyclically, ignoring warnings.
;; If N is given, move to the N-th next error. If N is negative, move to the N-th previous error."
;;   (interactive "P")
;;   (let ((current-pos (point))
;;         (next-error-pos nil)
;;         (wrapped nil))
;;     (save-excursion
;;       (while (and (not next-error-pos) (not wrapped))
;;         (condition-case nil
;;             (progn
;;               (flycheck-next-error n t)  ; The 't' argument means "only errors"
;;               (when (> (point) current-pos)
;;                 (setq next-error-pos (point))))
;;           (user-error
;;            (goto-char (point-min))
;;            (setq wrapped t)))))
;;     (if next-error-pos
;;         (goto-char next-error-pos)
;;       (if wrapped
;;           (message "No errors found in buffer.")
;;         (message "Wrapping to first error...")
;;         (goto-char (point-min))
;;         (my/flycheck-next-error-cyclic n)))))

;; (defun my/flycheck-next-error-cyclic (&optional n)
;;   "Go to the next Flycheck error cyclically.
;; If N is given, move to the N-th next error. If N is negative, move to the N-th previous error."
;;   (interactive "P")
;;   (let ((current-pos (point))
;;         (next-error-pos nil))
;;     (save-excursion
;;       (condition-case nil
;;           (progn
;;             (flycheck-next-error n)
;;             (setq next-error-pos (point)))
;;         (user-error nil)))
;;     (if next-error-pos
;;         (goto-char next-error-pos)
;;       (progn
;;         ;; If there was no next error, wrap around.
;;         (message "Wrapping to first error...")
;;         (flycheck-first-error)
;;         (flycheck-next-error (when n (1- n)))))))

;; (defun my/flycheck-error-detected ()
;;   "Flash the mode line red when Flycheck detects an error."
;;   (when (seq-some (lambda (err) (eq (flycheck-error-level err) 'error))
;;                   flycheck-current-errors)
;;     (my/flash-mode-line "red" 2)))


;; (add-hook 'before-save-hook 'my/flycheck-error-detected)
;; (add-hook 'flycheck-after-syntax-check-hook 'my/flycheck-error-detected)
;; (add-hook 'after-init-hook #'global-flycheck-mode)
