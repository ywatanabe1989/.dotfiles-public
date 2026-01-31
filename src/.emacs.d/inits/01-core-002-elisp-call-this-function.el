;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-17 18:00:54>
;;; File: /home/ywatanabe/.emacs.d/inits/01-core-002-elisp-call-this-function.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; Main
;; ----------------------------------------

(defun my/call-or-test-this-function
    ()
  "Call function or run test at point, even if cursor is inside the definition."
  (interactive)
  (save-excursion
    (beginning-of-defun)
    (cond
     ((looking-at "(ert-deftest")
      (--my/test-this-function))
     ((looking-at "(defun")
      (--my/call-this-function))
     (t
      (message "No function or test at point")))))

;; Core
;; ----------------------------------------

(defun --my/test-this-function
    ()
  "Run test at point."
  (interactive)
  (let
      ((orig-buf
        (current-buffer))
       (orig-pos
        (point)))
    (save-excursion
      (beginning-of-line)
      (when
          (looking-at "^(ert-deftest\\s-+\\(\\sw\\(?:\\sw\\|-\\)*\\)")
        (let*
            ((test-name-str
              (match-string-no-properties 1))
             (test-name
              (intern test-name-str)))
          (ert test-name)
          (message "Test %s run." test-name-str)
          (display-buffer "*ert*"))))
    (pop-to-buffer orig-buf)
    (goto-char orig-pos)))

(defun --my/call-this-function
    ()
  "Call function definition at point for testing."
  (interactive)
  (let
      ((orig-buf
        (current-buffer))
       (orig-pos
        (point))
       (def
        (save-excursion
          (beginning-of-line)
          (when
              (looking-at "(defun\\s-+\\(\\sw\\|\\s_\\)+")
            (let*
                ((sexp
                  (read
                   (current-buffer)))
                 (fname
                  (intern
                   (symbol-name
                    (cadr sexp))))
                 (args
                  (help-function-arglist fname)))
              (eval sexp)
              (cons fname args))))))
    (if def
        (let*
            ((fname
              (car def))
             (args
              (cdr def))
             (arg-values
              (mapcar
               (lambda
                 (arg)
                 (let*
                     ((arg-name
                       (symbol-name
                        (if
                            (consp arg)
                            (car arg)
                          (if
                              (eq arg '&optional)
                              (cadr arg)
                            arg))))
                      (input
                       (string-trim
                        (read-string
                         (format "%s: " arg-name)))))
                   (if
                       (string-empty-p input)
                       nil
                     input)))
               (remove '&optional
                       (if
                           (consp
                            (car args))
                           (car args)
                         args))))
             (result
              (apply fname arg-values)))
          (message "%S" result)
          result)
      (user-error "No function definition at point"))
    (pop-to-buffer orig-buf)
    (goto-char orig-pos)))

;; ;; Key Binding
;; ;; ----------------------------------------

(define-key emacs-lisp-mode-map (kbd "C-c C-c")
            #'my/call-or-test-this-function)
;; (global-set-key
;;  (kbd "C-c C-c")
;;  'my/call-or-test-this-function)

;; (definekey 'elisp-mode-ma
;;  (kbd "C-c C-c")
;;  'my/call-or-test-this-function)

(defun example-echo
    ()
  (message "aaa"))

;; (ert-deftest test-direxample-echo
;;     ()
;;   (should
;;    (string=
;;     (example-echo)
;;     "aaa")))


(provide '01-core-002-elisp-call-this-function)

(when
    (not load-file-name)
  (message "01-core-002-elisp-call-this-function.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))