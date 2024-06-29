;; For the use of 'thing-at-point'
(use-package thingatpt)

;; ;; Set the browser for 'browse-url-generic'
(setq browse-url-generic-program "google-chrome")
(setq browse-url-browser-function 'browse-url-generic)

(defun my/open ()
  "Open a URL or file based on the context at the point, supporting TRAMP paths."
  (interactive)
  (let* ((backward-result (my/things-at-a-backward-point))
         (forward-result (my/things-at-a-forward-point))
         (backward-type (car backward-result))
         (backward-obj (cdr backward-result))
         (forward-type (car forward-result))
         (forward-obj (cdr forward-result))
         (tramp-prefix (when (file-remote-p default-directory)
                         (extract-tramp-details default-directory)))
         (final-path (if (and backward-obj (string-prefix-p "." backward-obj))
                         (concat (file-name-directory (buffer-file-name)) backward-obj)
                       backward-obj)))
    (if (and (eq backward-type forward-type)
             (string= backward-obj forward-obj))
        (cond
         ((and (eq backward-type 'url) (string-prefix-p "http" backward-obj))
          (browse-url-generic backward-obj)) ;; Just use backward-obj here

         ((eq backward-type 'filename)
          (if tramp-prefix
              (find-file (concat tramp-prefix final-path)) ;; [REVISED]
            (find-file final-path))))))) ;; [REVISED]

(defun extract-tramp-details (tramp-path)
  "Extracts and prints details from a TRAMP path, focusing on the last colon."
  (interactive "sEnter TRAMP path: ")
  (let* ((reversed-path (reverse tramp-path))
         (first-colon-reversed (string-match ":" reversed-path))
         (last-colon (if first-colon-reversed
                         (- (length tramp-path) first-colon-reversed 1)
                       nil)))
    (if last-colon
        (let ((full-path tramp-path)
              (prefix (substring tramp-path 0 (1+ last-colon))))
          prefix)
      (message "No colon found in the TRAMP path."))))

(defun tramp-open-connection (path)
  "Open a TRAMP connection for the given PATH."
  (let ((default-directory path))
    (dired path)))

(defun my/things-at-a-point (shift)
  "Identify the thing at point and return its type and value."
  (save-excursion
    (forward-char shift)
    (let ((url (thing-at-point 'url))
          (filename (thing-at-point 'filename))
          (directory (thing-at-point 'directory)))
      (cond
       (url
        (cons 'url url))
       (filename
        (let ((clean-directory (or (file-remote-p default-directory 'localname)
                                   default-directory)))
          (if (string-prefix-p "." filename)
              (let ((full-path (concat (file-name-directory clean-directory) filename)))
                (cons 'filename full-path))
            (cons 'filename filename)))) ;; [REVISED]
       (directory
        (cons 'directory directory))
       (t
        (cons nil nil))))))

(defun my/things-at-a-backward-point ()
  (my/things-at-a-point 0))

(defun my/things-at-a-forward-point ()
  (my/things-at-a-point 0))

(bind-key* "C-o" 'my/open)

(message "002-smart-open.el was loaded.")
