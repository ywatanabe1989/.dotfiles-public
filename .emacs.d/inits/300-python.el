;; Parameters

(setq python-check-command "/home/ywatanabe/env/bin/flake8")
(setq time-stamp-format "%Y-%02m-%02d %02H:%02M:%02S (%u)")
(defvar py/results-alist nil
  "Alist mapping Python files to their results directories or files.")
(setq python-indent-offset 4)

;; Packages
(use-package python-isort
  :ensure t
  :config
  )

(defun py/remove-unused-imports ()
  (interactive)
  (pyimport-remove-unused)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^from[ \t]+\\(?:\\w*\\s-*\\)import[ \t]+\\w+.*$" nil t)
      (replace-match "")
    (while (re-search-forward "^from[ \t]+\\(?:\\w*\\s-*\\)cecreat import[ \t]+\\w+.*$" nil t)
      (replace-match "")
      ))))

(defun py/doublequoted-bracket ()
  (interactive)
  (save-excursion  ; Preserve the point's original position
    (let ((start (region-beginning))
          (end (region-end)))
      (goto-char start)
      (insert "[\"")
      (goto-char (+ end 2))  ; Adjust for the characters we just inserted
      (insert "\"]"))))



(use-package pyimport
  :ensure t
  :config
  (defalias 'py-i 'python-isort)
  )

(use-package blacken
  :ensure t
  :config
  (setq blacken-line-length 79)
  (defalias 'bl-b 'py/bl-b)
  )

;; Custom Functions
(defun py/insert-template-if-new-file ()
  "Insert the Python template into a new file, adjusting the file path for SSH connections."
  (when (and (string= (file-name-extension (or buffer-file-name "")) "py")
             (= (point-min) (point-max)))  ; Check if the buffer is empty
    (let* ((time-stamp (format-time-string "%Y-%m-%d %H:%M:%S"))
           (user-name (user-login-name))
           (file-name-or-path (or buffer-file-name ""))
           (clean-path (if (string-match "/ssh:[^:]+:\\([^:]*\\)" file-name-or-path)
                           (match-string 1 file-name-or-path)
                         file-name-or-path)))
      ;; Insert the template with the appropriate values
      (insert (format python-template time-stamp user-name clean-path))
      (goto-char (point-min)))))

(defun py/cycle (&optional step)
  "Cycle through buffers in python-mode."
  (interactive "p") ; 'p' means the function accepts a prefix argument, defaulting to 1 if none is provided.
  (let* ((current-buffer (current-buffer))
         (python-buffers (seq-filter (lambda (buf)
                                       (with-current-buffer buf
                                         (eq major-mode 'python-mode)))
                                     (buffer-list)))
         (current-index (cl-position current-buffer python-buffers :test 'eq))
         (buffer-count (length python-buffers))
         (next-index (mod (+ current-index (or step 1)) buffer-count))) ; Corrected to use 'step' instead of 'steps'
    (when python-buffers
      (switch-to-buffer (nth next-index python-buffers)))))

(defun py/open-results ()
  (interactive)
  (when (and (buffer-file-name) (string-match-p "\\.py\\'" (buffer-file-name)))
    (let* ((current-path (buffer-file-name))
           (base-name (file-name-sans-extension current-path))
           (results-dir (concat base-name)))
      (if (file-exists-p results-dir)
          (find-file results-dir)
        (message "Directory does not exist: %s" results-dir)))))

(defun py/embed-paste ()
  (interactive)
  (other-window 1)
  (term-send-raw-string "from IPython import embed")
  (term-send-raw-string "\C-m")
  (term-send-raw-string "embed()")
  (term-send-raw-string "\C-m")
  (term-send-raw-string "paste\C-m")
  (term-send-raw-string "exit\C-m")
  (other-window -1)
  )

(defun py/check-errors-in-region (region-start region-end)
  "Check for Flycheck errors in the specified region."
  (let* ((only-errors (seq-filter (lambda (err)
                                    (eq (flycheck-error-level err) 'error))
                                  flycheck-current-errors))
         (errors-in-region (seq-filter (lambda (err)
                                         (let ((err-start (flycheck-error-pos err)))
                                           (and (>= err-start region-start)
                                                (<= err-start region-end))))
                                       only-errors)))
    errors-in-region))

(defun py/run-if (script-path)
  "Handle the terminal state based on whether it's in iPDB, IPython, or a regular terminal."
  (cond
   ((py/check-if-in-ipdb)
    (message "Exiting iPDB")
    (term-send-raw-string "exit\n")  ; from ipdb
    (term-send-raw-string "exit\n")  ; from ipython
    ;; (term-send-raw-string "\C-l")
    (term-send-raw-string (concat "python " script-path "\n")))

   ((py/check-if-in-ipython)
    (message "Exiting IPython")
    (term-send-raw-string "exit\n")
    ;; (term-send-raw-string "\C-l")
    (term-send-raw-string (concat "python " script-path "\n")))

   ((and (eq major-mode 'term-mode) (not (py/check-if-in-ipython)))
    (message "Term")
    ;; (term-send-raw-string "\C-l")
    (term-send-raw-string (concat "python " script-path "\n")))))


;; (defun py/run-if (script-path)
;;   "Handle the terminal state based on whether it's in iPDB, IPython, or a regular terminal.
;; SCRIPT-PATH is the path to the Python script to execute."
;;   (cond
;;    ((py/check-if-in-ipdb)
;;     (message "Exiting iPDB")
;;     (term-send-raw-string "exit\n")  ; from ipdb
;;     (term-send-raw-string "exit\n")  ; from ipython
;;     (term-send-raw-string "\C-l")
;;     (term-send-raw-string (concat "python " script-path "\n")))

;;    ((py/check-if-in-ipython)
;;     (message "Exiting IPython")
;;     (term-send-raw-string "exit\n")
;;     (term-send-raw-string "\C-l")
;;     (term-send-raw-string (concat "python " script-path "\n")))

;;    ((eq major-mode 'term-mode)
;;     (message "Running in regular terminal")
;;     (term-send-raw-string "\C-l")
;;     (term-send-raw-string (concat "python " script-path "\n")))
;;    ))

(defun py/run ()
  "Main function to run the Python script in the current buffer."
  (interactive)
  (save-buffer)
  (let ((script-path (my/get-current-path)))
       (other-window 1)
       (py/run-if script-path))
  (other-window -1))


(defun py/paste-if ()
  "Handle the terminal state based on whether it's in iPDB, IPython, or a regular terminal."
  (cond
   ((py/check-if-in-ipdb)
    (term-send-raw-string "exit\C-m")
    (term-send-raw-string "paste\C-m"))

   ((py/check-if-in-ipython)
    (message "IPython")
    (term-send-raw-string "paste\C-m"))

   ((and (eq major-mode 'term-mode) (not (py/check-if-in-ipython)))
    (message "Term")
    (term-send-raw-string "ipython\C-m")
    (term-send-raw-string "paste\C-m"))))

(defun py/paste ()
  "Main function to run the process on ipython."
  (interactive)
  (let* ((original-pos (point-marker))
         ;; Check if a region is selected; if not, select the entire buffer.
         (region-start (if (use-region-p) (region-beginning) (point-min)))
         (region-end (if (use-region-p) (region-end) (point-max)))
         (errors-in-region (py/check-errors-in-region region-start region-end)))
    (if (and (bound-and-true-p flycheck-mode)
             errors-in-region)
        (progn
          (message "Errors detected within the region, jumping to the first error.")
          (goto-char (flycheck-error-pos (car errors-in-region)))
          (flycheck-next-error 1)
          (flycheck-previous-error 1)
          (message "Press M-g M-p to go back to the original position.")
          (push-mark original-pos))
      (progn
        (my/copy-region-or-buffer)
        (other-window 1)
        (py/paste-if)
        (other-window -1)
        (deactivate-mark)
        (goto-char original-pos)))))

(defun py/check-if-in-ipython ()
  (interactive)
  "Check if the term buffer in the curent window is running an IPython session by looking for an IPython prompt."
  (let ((ipython-detected nil))
    (save-excursion
      ;; (goto-char (point-min))
      (beginning-of-line)
      (setq ipython-detected (re-search-forward "In \\[\\([0-9]+\\)\\]: " nil t)))
    (if ipython-detected
        (progn
          (message "IPython session detected.")
          t)
      (progn
        (message "No IPython session detected.")
        nil))))

(defun py/check-if-in-ipdb ()
  (interactive)
  "Check if the current line in the buffer contains 'ipdb> '."
  (save-excursion
    (beginning-of-line)
    (let ((found (re-search-forward "ipdb> " (line-end-position) t)))
      (if found
          (progn
            (message "IPDB prompt detected on the current line.")  ;; Print message for user.
            t)  ;; Return t for true, indicating an IPDB prompt was found on the current line.
        (progn
          (message "No IPDB prompt detected on the current line.")  ;; Print message for user.
          nil)))))

(defun py/bl-b ()
  (interactive)
  (let ((current-point (point))) ; Save current cursor position
    (condition-case err
        (blacken-buffer) ; Attempt to blacken the buffer
      (error
       (let ((error-buffer (get-buffer "*blacken-error*")))
         (when error-buffer
           (pop-to-buffer error-buffer) ; Open the error buffer
           (goto-char (point-min))))) ; Go to the top of the error buffer
      (unless err
        (goto-char current-point))))) ; If no error, restore cursor position


;; python-mode-hook
(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 4)
            (blacken-mode t)
            (highlight-indent-guides-mode t)
            (flycheck-mode t)
            (flycheck-pos-tip-mode nil)
            (flycheck-posframe-mode t)
            (define-key python-mode-map (kbd "C-S-p") my/python-mode-prefix-map)
            (define-key python-mode-map (kbd "C-c C-f") 'my/copy-current-path)
            (add-hook 'before-save-hook 'delete-trailing-whitespace nil t)
            (add-hook 'before-save-hook 'python-isort-buffer nil t)
            (add-hook 'before-save-hook 'blacken-buffer nil t)
            ;; (add-hook 'before-save-hook 'pyimport-remove-unused nil t)
            (py/insert-template-if-new-file)
            (highlight-parentheses-mode t)
            (lambda ()
              ;; (set (make-local-variable 'electric-pair-inhibit-predicate)
              ;;    #'my/electric-pair-inhibit-predicate)
              (setq autopair-handle-action-fns
                    (list 'autopair-default-handle-action
                          (lambda (action pair pos-before)
                            (hl-paren-color-update))))
              (setq hl-paren-colors
                    '("orange1" "yellow1" "greenyellow" "green1"
                      "springgreen1" "cyan1" "slateblue1" "magenta1" "purple")))))


;; Keybindings on python-mode-map
(with-eval-after-load 'python
  (define-key python-mode-map (kbd "M-i") 'py/insert-ipdb)
  (define-key python-mode-map (kbd "C-S-p") my/python-mode-prefix-map)
  (define-key python-mode-map (kbd "C-c C-r") 'py/open-results)
  (define-key python-mode-map (kbd "C-c C-c") 'py/cycle)
  (define-key python-mode-map (kbd "M-p") 'py/paste)
  (define-key python-mode-map (kbd "M-r") 'py/run)
  (define-key python-mode-map (kbd "M-c") 'py/cycle)
  (define-key python-mode-map (kbd "C-M-f") 'my/flycheck-next-error-cyclic)
  )

;; Keybindings on python-mode-prefix-map
(defvar my/python-mode-prefix-map (make-sparse-keymap)
  "A prefix keymap for custom python-mode bindings.")
(define-key my/python-mode-prefix-map (kbd "a") 'py/insert-argparse-template)
(define-key my/python-mode-prefix-map (kbd "e") 'py/embed-paste)
(define-key my/python-mode-prefix-map (kbd "h") 'highlight-indent-guides-mode)
(define-key my/python-mode-prefix-map (kbd "m") 'py/insert-if-name-main)
(define-key my/python-mode-prefix-map (kbd "o") 'py/open-results)
(define-key my/python-mode-prefix-map (kbd "p") 'py/insert-plot-template)
;; (define-key my/python-mode-prefix-map (kbd "i") 'pyimport-remove-unused)
(define-key my/python-mode-prefix-map (kbd "i") 'py/remove-unused-imports)

(define-key my/python-mode-prefix-map (kbd "r") 'py/run)
(define-key my/python-mode-prefix-map (kbd "t") 'py/insert-template)
(define-key my/python-mode-prefix-map (kbd "w") 'py/insert-warnings-template)

(define-key my/python-mode-prefix-map (kbd "d") 'py/doublequoted-bracket)



(message "300-python.el was loaded.")
