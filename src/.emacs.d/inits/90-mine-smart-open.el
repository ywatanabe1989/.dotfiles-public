;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:10:59>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/90-mine-smart-open.el

(use-package thingatpt)

;; Browser config for 'browse-url-generic'
;; ----------------------------------------

(setq browse-url-generic-program
      "/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe")
(setq browse-url-browser-function 'browse-url-generic)

;; (defun my/open
;;     ()
;;   "Open a URL or file based on the context at the point, supporting TRAMP paths."
;;   (interactive)
;;   (let*
;;       ((selected-text
;;         (when
;;             (use-region-p)
;;           (buffer-substring-no-properties
;;            (region-beginning)
;;            (region-end))))
;;        (backward-result
;;         (if selected-text
;;             (cons 'unknown selected-text)
;;           (my/things-at-a-backward-point)))
;;        (forward-result
;;         (if selected-text
;;             (cons 'unknown selected-text)
;;           (my/things-at-a-forward-point)))
;;        (backward-type
;;         (car backward-result))
;;        (backward-obj
;;         (--my/open-parse-tex-if
;;          (cdr backward-result)))
;;        (forward-type
;;         (car forward-result))
;;        (forward-obj
;;         (--my/open-parse-tex-if
;;          (cdr forward-result)))
;;        (tramp-prefix
;;         (when
;;             (file-remote-p default-directory)
;;           (extract-tramp-details default-directory)))
;;        (final-path
;;         (if
;;             (and backward-obj
;;                  (string-prefix-p "." backward-obj))
;;             (concat
;;              (file-name-directory
;;               (buffer-file-name))
;;              backward-obj)
;;           backward-obj)))

;;     (if selected-text
;;         (find-file selected-text)
;;       (if
;;           (and
;;            (eq backward-type forward-type)
;;            (string= backward-obj forward-obj))
;;           (cond
;;            ((and
;;              (eq backward-type 'url)
;;              (string-prefix-p "http" backward-obj))
;;             (browse-url-generic backward-obj))

;;            ((eq backward-type 'filename)
;;             (if
;;                 (string-match-p "\\.\\(jpg\\|jpeg\\|png\\|gif\\|bmp\\)$" final-path)
;;                 (my/open-in-windows
;;                  (if tramp-prefix
;;                      (concat tramp-prefix final-path)
;;                    final-path))
;;               (find-file
;;                (if tramp-prefix
;;                    (concat tramp-prefix final-path)
;;                  final-path)))))))))

;; Core function to prepare context for opening
;; ----------------------------------------

(defun --my/open-prepare-context
    ()
  "Prepare context information for opening a URL or file."
  (let*
      ((selected-text
        (when
            (use-region-p)
          (buffer-substring-no-properties
           (region-beginning)
           (region-end))))
       (backward-result
        (if selected-text
            (cons 'unknown selected-text)
          (my/things-at-a-backward-point)))
       (forward-result
        (if selected-text
            (cons 'unknown selected-text)
          (my/things-at-a-forward-point)))
       (backward-type
        (car backward-result))
       (backward-obj
        (--my/open-parse-tex-if
         (cdr backward-result)))
       (forward-type
        (car forward-result))
       (forward-obj
        (--my/open-parse-tex-if
         (cdr forward-result)))
       (tramp-prefix
        (when
            (file-remote-p default-directory)
          (extract-tramp-details default-directory)))
       (final-path
        (if
            (and backward-obj
                 (string-prefix-p "." backward-obj))
            (concat
             (file-name-directory
              (buffer-file-name))
             backward-obj)
          backward-obj)))
    (list selected-text backward-type forward-type
          backward-obj forward-obj tramp-prefix final-path)))

;; Main functions
;; ----------------------------------------

(defun my/open
    ()
  "Open a URL or file based on the context at the point, supporting TRAMP paths."
  (interactive)
  (let*
      ((context
        (--my/open-prepare-context))
       (selected-text
        (nth 0 context))
       (backward-type
        (nth 1 context))
       (forward-type
        (nth 2 context))
       (backward-obj
        (nth 3 context))
       (forward-obj
        (nth 4 context))
       (tramp-prefix
        (nth 5 context))
       (final-path
        (nth 6 context)))
    (if selected-text
        (find-file selected-text)
      (if
          (and
           (eq backward-type forward-type)
           (string= backward-obj forward-obj))
          (cond
           ((and
             (eq backward-type 'url)
             (string-prefix-p "http" backward-obj))
            (browse-url-generic backward-obj))
           ((eq backward-type 'filename)
            (if
                (string-match-p
                 "\\.\\(jpg\\|jpeg\\|png\\|gif\\|bmp\\)$" final-path)
                (my/open-in-windows
                 (if tramp-prefix
                     (concat tramp-prefix final-path)
                   final-path))
              (find-file
               (if tramp-prefix
                   (concat tramp-prefix final-path)
                 final-path)))))))))

(defun my/open-in-another-buffer
    ()
  "Open a URL or file in another window based on the context at point, supporting TRAMP paths."
  (interactive)
  (let*
      ((context
        (--my/open-prepare-context))
       (selected-text
        (nth 0 context))
       (backward-type
        (nth 1 context))
       (forward-type
        (nth 2 context))
       (backward-obj
        (nth 3 context))
       (forward-obj
        (nth 4 context))
       (tramp-prefix
        (nth 5 context))
       (final-path
        (nth 6 context)))
    (if selected-text
        (find-file-other-window selected-text)
      (if
          (and
           (eq backward-type forward-type)
           (string= backward-obj forward-obj))
          (cond
           ((and
             (eq backward-type 'url)
             (string-prefix-p "http" backward-obj))
            (browse-url-generic backward-obj))
           ((eq backward-type 'filename)
            (if
                (string-match-p
                 "\\.\\(jpg\\|jpeg\\|png\\|gif\\|bmp\\)$" final-path)
                (my/open-in-windows
                 (if tramp-prefix
                     (concat tramp-prefix final-path)
                   final-path))
              (find-file-other-window
               (if tramp-prefix
                   (concat tramp-prefix final-path)
                 final-path)))))))))

(defun --my/open-parse-tex-if
    (file-path)
  (interactive)
  (if
      (string-match "input{\\(.*?\\)}" file-path)
      (concat
       (match-string 1 file-path)
       ".tex")
    file-path))

(defun extract-tramp-details
    (tramp-path)
  "Extracts and prints details from a TRAMP path, focusing on the last colon."
  (interactive "sEnter TRAMP path: ")
  (let*
      ((reversed-path
        (reverse tramp-path))
       (first-colon-reversed
        (string-match ":" reversed-path))
       (last-colon
        (if first-colon-reversed
            (-
             (length tramp-path)
             first-colon-reversed 1)
          nil)))
    (if last-colon
        (let
            ((full-path tramp-path)
             (prefix
              (substring tramp-path 0
                         (1+ last-colon))))
          prefix)
      (message "No colon found in the TRAMP path."))))

(defun tramp-open-connection
    (path)
  "Open a TRAMP connection for the given PATH."
  (let
      ((default-directory path))
    (dired path)))

(defun my/things-at-a-point
    (shift)
  "Identify the thing at point and return its type and value."
  (save-excursion
    (forward-char shift)
    (let
        ((url
          (thing-at-point 'url))
         (filename
          (thing-at-point 'filename))
         (directory
          (thing-at-point 'directory)))
      (cond
       (url
        (cons 'url url))
       (filename
        (let
            ((clean-directory
              (or
               (file-remote-p default-directory 'localname)
               default-directory)))
          (if
              (string-prefix-p "." filename)
              (let
                  ((full-path
                    (concat
                     (file-name-directory clean-directory)
                     filename)))
                (cons 'filename full-path))
            (cons 'filename filename))))
       (directory
        (cons 'directory directory))
       (t
        (cons nil nil))))))

;; (defun my/open-in-another-buffer
;;     ()
;;   "Open a URL or file in another window based on the context at point, supporting TRAMP paths."
;;   (interactive)
;;   (let*
;;       ((selected-text
;;         (when
;;             (use-region-p)
;;           (buffer-substring-no-properties
;;            (region-beginning)
;;            (region-end))))
;;        (backward-result
;;         (if selected-text
;;             (cons 'unknown selected-text)
;;           (my/things-at-a-backward-point)))
;;        (forward-result
;;         (if selected-text
;;             (cons 'unknown selected-text)
;;           (my/things-at-a-forward-point)))
;;        (backward-type
;;         (car backward-result))
;;        (backward-obj
;;         (--my/open-parse-tex-if
;;          (cdr backward-result)))
;;        (forward-type
;;         (car forward-result))
;;        (forward-obj
;;         (--my/open-parse-tex-if
;;          (cdr forward-result)))
;;        (tramp-prefix
;;         (when
;;             (file-remote-p default-directory)
;;           (extract-tramp-details default-directory)))
;;        (final-path
;;         (if
;;             (and backward-obj
;;                  (string-prefix-p "." backward-obj))
;;             (concat
;;              (file-name-directory
;;               (buffer-file-name))
;;              backward-obj)
;;           backward-obj)))
;;     (if selected-text
;;         (find-file-other-window selected-text)
;;       (if
;;           (and
;;            (eq backward-type forward-type)
;;            (string= backward-obj forward-obj))
;;           (cond
;;            ((and
;;              (eq backward-type 'url)
;;              (string-prefix-p "http" backward-obj))
;;             (browse-url-generic backward-obj))
;;            ((eq backward-type 'filename)
;;             (if
;;                 (string-match-p "\\.\\(jpg\\|jpeg\\|png\\|gif\\|bmp\\)$" final-path)
;;                 (my/open-in-windows
;;                  (if tramp-prefix
;;                      (concat tramp-prefix final-path)
;;                    final-path))
;;               (find-file-other-window
;;                (if tramp-prefix
;;                    (concat tramp-prefix final-path)
;;                  final-path)))))))))

(defun my/things-at-a-backward-point
    ()
  (my/things-at-a-point 0))

(defun my/things-at-a-forward-point
    ()
  (my/things-at-a-point 0))

;; Key Bindings
;; ----------------------------------------

(bind-key* "C-o" 'my/open)

(when
    (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '90-mine-smart-open)

(when
    (not load-file-name)
  (message "90-mine-smart-open.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))