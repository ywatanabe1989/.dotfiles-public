;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-02 09:53:49>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/05-code-000-flycheck.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; Add python-ruff to disabled checkers
(setq-default flycheck-disabled-checkers
              (append '(python-ruff)
                      (remove 'emacs-lisp flycheck-disabled-checkers)))

;; (use-package flycheck
;;   :ensure
;;   t
;;   :init
;;   (global-flycheck-mode)
;;   :config
;;   ;; 1. General Configuration
;;   ;;   - highlight entire lines
;;   ;;   - only navigate errors
;;   (setq flycheck-highlighting-mode 'lines)
;;   (setq flycheck-navigation-minimum-level 'error)
;;   ;;   - enable Emacs Lisp checker
;;   (setq-default flycheck-disabled-checkers
;;                 (remove 'emacs-lisp flycheck-disabled-checkers))
;;   (setq flycheck-display-errors-delay 99999)

;;   ;; 2. Python Ruff checker
;;   ;;   - define ruff
;;   (flycheck-define-checker python-ruff
;;     "A Python syntax and style checker using ruff."
;;     :command ("ruff" "check" "--output-format=full"
;;               "--config" (eval (expand-file-name "~/.ruff.toml"))
;;               source-inplace)
;;     :error-patterns
;;     ((error   line-start (file-name) ":" line ":" column ": " (id "E")
;;               (message) line-end)
;;      (warning line-start (file-name) ":" line ":" column ": " (id "W")
;;               (message) line-end))
;;     :modes python-mode)
;;   ;;   - set ruff executable per host
;;   (setq flycheck-python-ruff-executable
;;         (if (string-equal (system-name) "titan")
;;             "/home/yusukew/.venv/bin/ruff"
;;           "/home/ywatanabe/.venv/bin/ruff")))

(use-package flycheck
  :ensure
  t
  :init
  (global-flycheck-mode)
  :config
  ;; General Configuration
  (setq flycheck-highlighting-mode 'lines)
  (setq flycheck-display-errors-function
        #'flycheck-posframe-show-posframe)

  ;; Enable Emacs Lisp checker explicitly
  (setq-default flycheck-disabled-checkers
                (remove 'emacs-lisp flycheck-disabled-checkers))
  (setq flycheck-display-errors-delay nil)

  ;; Python Configuration
  (setq-default flycheck-disabled-checkers
                '(python-pylint python-pycompile))
  (setq-default flycheck-checkers '(python-flake8))
  (setq flycheck-python-flake8-executable
        (expand-file-name "~/.venv/bin/python3"))
  (setq flycheck-python-flake8-executable
        (expand-file-name "~/.venv/bin/flake8"))
  (setq flycheck-flake8rc
        (expand-file-name "~/.flake8"))

  ;; JavaScript/TypeScript Configuration
  (setq flycheck-javascript-eslint-executable "/usr/bin/eslint")
  (flycheck-add-mode 'javascript-eslint 'typescript-mode)
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . web-mode)))

(use-package flycheck-pos-tip
  :ensure
  t
  :after flycheck
  :config
  (flycheck-pos-tip-mode))

(use-package flycheck-posframe
  :ensure
  t
  :after flycheck
  :config
  (flycheck-posframe-configure-pretty-defaults)
  (setq flycheck-posframe-warning-prefix "\u26a0 ")
  (setq flycheck-posframe-error-prefix "x ")
  (setq flycheck-posframe-background-face "red")
  (setq flycheck-posframe-border-width 0)
  (setq flycheck-pos-tip-timeout 3)
  (setq flycheck-posframe-position 'window-bottom-left-corner)
  (add-hook 'flycheck-mode-hook #'flycheck-posframe-mode))

(defun my/flycheck-error-detected ()
  "Flash the mode line red when Flycheck detects an error."
  (when (seq-some
         (lambda (err) (eq (flycheck-error-level err) 'error))
         flycheck-current-errors)
    (--my/flash-mode-line "red" 2)))

;; ;; works well but jumping to both warnings and errors

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

(defun my/flycheck-next-error-cyclic ()
  (interactive)
  (helm-flycheck))

(defun get-flycheck-output ()
  "Returns flycheck errors as string.

Example:
  (get-flycheck-output)
  ;; => \"line 10: error: Variable 'foo' is not bound\""
  (interactive)
  (let ((temp-output nil))
    (flycheck-list-errors)
    (sleep-for 0.5)
    (when-let ((buffer (get-buffer "*Flycheck errors*")))
      (with-current-buffer buffer
        (setq temp-output (buffer-string))))
    (message "%s" (or temp-output "No errors"))
    (or temp-output "")))

;; 3. JavaScript/TypeScript Configuration

(use-package flycheck
  :after
  flycheck
  :config
  ;;   - eslint executable
  (setq flycheck-javascript-eslint-executable "/usr/bin/eslint")
  ;;   - enable in tsx, ts and web-mode
  (flycheck-add-mode 'javascript-eslint 'typescript-mode)
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . web-mode))
  (add-hook 'web-mode-hook
            (lambda ()
              (when
                  (member (file-name-extension buffer-file-name)
                          '("ts" "tsx"))
                (setq flycheck-checker 'javascript-eslint)))))

;; 4. Flycheck pos-tip for popup errors

(use-package flycheck-pos-tip
  :ensure
  t
  :after flycheck
  :config
  (flycheck-pos-tip-mode))

;; 5. Flash mode line on error

(defun my/flycheck-error-detected ()
  "Flash the mode line red when an error is detected."
  (when (seq-some (lambda (err)
                    (eq (flycheck-error-level err) 'error))
                  flycheck-current-errors)
    (--my/flash-mode-line "red" 2)))
(add-hook 'flycheck-after-syntax-check-hook
          #'my/flycheck-error-detected)

;; 6. Next error cyclic or helm list

(defun my/flycheck-next-error-cyclic ()
  "Jump to next Flycheck error or open helm list if none."
  (interactive)
  (if (flycheck-has-current-errors-p 'error)
      (helm-flycheck)
    (message "No errors found")))

(global-set-key (kbd "C-M-f") #'my/flycheck-next-error-cyclic)

;; 7. Retrieve errors as string

(defun my/get-flycheck-output ()
  "Return Flycheck errors buffer contents."
  (interactive)
  (flycheck-list-errors)
  (sleep-for 0.5)
  (if-let ((buffer (get-buffer "*Flycheck errors*")))
      (with-current-buffer buffer
        (let ((output (buffer-string)))
          (message "%s" output)
          output))
    (message "No errors")
    ""))

;; 8. Helm integration: only show errors

(defun my/helm-flycheck-init-filter ()
  "Filter Helm candidates to errors only."
  (setq helm-flycheck-candidates
        (if (flycheck-has-current-errors-p 'error)
            (mapcar #'helm-flycheck-make-candidate
                    (seq-filter (lambda (err)
                                  (eq (flycheck-error-level err)
                                      'error))
                                (sort flycheck-current-errors
                                      #'flycheck-error-<)))
          (list (helm-flycheck-status-message)))))
(advice-add 'helm-flycheck-init :override
            #'my/helm-flycheck-init-filter)


(provide '05-code-000-flycheck)

(when
    (not load-file-name)
  (message "05-code-000-flycheck.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))