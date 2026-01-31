;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:41>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-099-describe-symbol.el

;; 1. Main Functions
;; ----------------------------------------

(defun my/describe-symbol-at-point
    ()
  "Describe symbol at point, falling back to `my/list' if symbol not found."
  (interactive)
  (let
      ((sym
        (symbol-at-point)))
    (if
        (and sym
             (symbolp sym)
             (or
              (boundp sym)
              (fboundp sym)))
        (describe-symbol sym)
      (my/list nil
               (symbol-name
                (or sym ""))))))

(defun my/list
    (type pattern)
  "List llemacs symbols by TYPE with optional PATTERN."
  (interactive
   (list
    (completing-read "Type (command/variable/function/group): "
                     '("command" "variable" "function" "group")
                     nil t)
    (read-string "Pattern (or empty for all): "
                 (when
                     (symbol-at-point)
                   (symbol-name
                    (symbol-at-point))))))
  (let
      ((type-str
        (if
            (stringp type)
            type
          "")))
    (cond
     ((equal type-str "command")
      (apropos-command pattern t))
     ((equal type-str "variable")
      (apropos-variable pattern))
     ((equal type-str "function")
      (let
          ((apropos-documentation-sort-by-scores nil))
        (apropos-documentation
         (concat "^" pattern))))
     ((equal type-str "group")
      (my/list-groups pattern))
     (t
      (apropos pattern)))))

;; 2. Helper Functions
;; ----------------------------------------

(defun my/show-functions
    (pattern)
  "Show functions and their argument lists matching PATTERN."
  (interactive "sPattern: ")
  (let
      ((matches nil))
    (mapatoms
     (lambda
       (sym)
       (when
           (and
            (fboundp sym)
            (string-match pattern
                          (symbol-name sym)))
         (push
          (cons sym
                (help-function-arglist sym))
          matches))))
    (dolist
        (match
         (sort matches
               (lambda
                 (a b)
                 (string<
                  (symbol-name
                   (car a))
                  (symbol-name
                   (car b))))))
      (princ
       (format "%s: %S\n"
               (car match)
               (cdr match))))))

(defun my/list-groups
    (pattern)
  "List all custom group matching PATTERN."
  (let
      ((groups))
    (mapatoms
     (lambda
       (symbol)
       (when
           (and
            (string-match-p pattern
                            (symbol-name symbol))
            (get symbol 'custom-group))
         (push symbol groups))))
    (sort groups #'string-lessp)))

;; 3. Keybindings and Configuration
;; ----------------------------------------

(define-key special-event-map
            (kbd "C-S-h")
            'my/describe-symbol-at-point)
(put 'my/describe-symbol-at-point 'permanent-local t)

;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: 2025-01-22 22:03:46
;;; Timestamp: <2025-01-22 22:03:46>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-099-list.el
;; ;;; -*- coding: utf-8; lexical-binding: t -*-
;; ;;; Author: 2025-01-11 07:45:32
;; ;;; Timestamp: <2025-01-11 07:45:32>
;; ;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/000-core/099-list.el

;; (defun my/describe-symbol-at-point ()
;;   "Describe symbol at point, falling back to `my/list' if symbol not found."
;;   (interactive)
;;   (let ((sym (symbol-at-point)))
;;     (if (and sym (symbolp sym) (or (boundp sym) (fboundp sym)))
;;         (describe-symbol sym)
;;       (my/list nil (symbol-name (or sym ""))))))

;; (defun my/list (type pattern)
;;   "List llemacs symbols by TYPE with optional PATTERN."
;;   (interactive
;;    (list
;;     (completing-read "Type (command/variable/function/group): "
;;                      '("command" "variable" "function" "group")
;;                      nil t)
;;     (read-string "Pattern (or empty for all): "
;;                  (when (symbol-at-point)
;;                    (symbol-name (symbol-at-point))))))
;;   (let ((type-str (if (stringp type) type "")))
;;     (cond
;;      ((equal type-str "command") (apropos-command pattern t))
;;      ((equal type-str "variable") (apropos-variable pattern))
;;      ((equal type-str "function")
;;       (let ((apropos-documentation-sort-by-scores nil))
;;         (apropos-documentation (concat "^" pattern))))
;;      ((equal type-str "group") (my/list-groups pattern))
;;      (t (apropos pattern)))))

;; ;; (my/list "command" "llemacs--")
;; ;; (my/list "variable" "llemacs--")
;; ;; (my/list "function" "llemacs--")

;; (defun my/show-functions (pattern)
;;   "Show functions and their argument lists matching PATTERN."
;;   (interactive "sPattern: ")
;;   (let ((matches nil))
;;     (mapatoms
;;      (lambda (sym)
;;        (when (and (fboundp sym)
;;                   (string-match pattern (symbol-name sym)))
;;          (push (cons sym (help-function-arglist sym)) matches))))
;;     (dolist (match (sort matches (lambda (a b) (string< (symbol-name (car a))
;;                                                         (symbol-name (car b))))))
;;       (princ (format "%s: %S\n" (car match) (cdr match))))))

;; (defun my/list-groups (pattern)
;;   "List all custom group matching PATTERN."
;;   (let ((groups))
;;     (mapatoms
;;      (lambda (symbol)
;;        (when (and (string-match-p pattern (symbol-name symbol))
;;                   (get symbol 'custom-group))
;;          (push symbol groups))))
;;     (sort groups #'string-lessp)))

;; ;; (global-set-key (kbd "C-S-h") 'my/describe-symbol-at-point)

;; (define-key special-event-map (kbd "C-S-h") 'my/describe-symbol-at-point)
;; (put 'my/describe-symbol-at-point 'permanent-local t)

(when
    (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '01-core-099-describe-symbol)

(when
    (not load-file-name)
  (message "01-core-099-describe-symbol.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))