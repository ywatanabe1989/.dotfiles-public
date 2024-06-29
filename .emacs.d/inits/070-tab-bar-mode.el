;; -*- lexical-binding: t -*-
(defvar my/tab-buffer-alist nil
  "Alist buffer types.")

(use-package company
  :ensure t
  )

(use-package tab-bar
  :ensure t
  :init
  (tab-bar-mode t)
  :custom
  (tab-bar-show t)
  (tab-bar-tab-hints t)
  (tab-bar-name-truncated t)
  (tab-bar-auto-width nil)
  ;; (tab-bar-new-tab-to 'rightmost)
  (tab-bar-new-tab-to 'right)
  (setq tab-bar-close-button-show nil)
  (custom-set-faces
   '(tab-bar ((t (:background "gray20" :foreground "white"))))
   '(tab-bar-tab ((t (:inherit tab-bar :background "gray40" :foreground "dark orange"))))
   '(tab-bar-tab-inactive ((t (:inherit tab-bar :background "gray20" :foreground "gray80")))))
  )


;; Functions
(defun my/term-named (arg)
  ;; (defun my/tab-new (arg)
  (interactive
   (list
    (read-string "Enter string: ")))
  (tab-new)
  (tab-rename (message "%s" arg))
  )

(defun my/tab-set-buffer (type &optional tab-name buffer-name)
  "Set a buffer as either home or semi-home for a given tab."
  (interactive "sType (home/semi-home): ")
  ;; Validate type
  (unless (member type '("home" "semi-home"))
    (error "Type must be either 'home' or 'semi-home'"))
  ;; Use current tab's name if TAB-NAME is not provided.
  (unless tab-name
    (setq tab-name (alist-get 'name (tab-bar--current-tab))))
  ;; (setq tab-name (alist-get 'name (car (last (tab-bar-tabs))))))
  ;; Use current buffer's name if BUFFER-NAME is not provided.
  (unless buffer-name
    (setq buffer-name (buffer-name)))
  ;; Ensure the buffer exists.
  (get-buffer-create buffer-name)
  ;; Find or create tab entry in alist.
  (let ((tab-entry (assoc tab-name my/tab-buffer-alist)))
    (if tab-entry
        ;; Update existing tab entry.
        (setcdr tab-entry (cons (cons type buffer-name) (assoc-delete-all type (cdr tab-entry))))
      ;; Add new tab entry.
      (push (cons tab-name (list (cons type buffer-name))) my/tab-buffer-alist)))
  (message "The %s buffer of tab \"%s\" is set as \"%s\"" type tab-name buffer-name))

(defun my/tab-get-buffer (type &optional tab)
  "Get the buffer of a given type (home or semi-home) associated with a tab."
  (interactive "sType (home/semi-home): ")
  ;; Use the current tab if none is specified.
  (unless tab (setq tab (tab-bar--current-tab)))
  (let* ((tab-name (alist-get 'name tab))
         (tab-entry (assoc tab-name my/tab-buffer-alist))
         (buffer-entry (assoc type (cdr tab-entry))))
    (cdr buffer-entry)))

(defun my/tab-jump-to-buffer (type)
  "Jump to the buffer of a given type associated with the current tab."
  (interactive "sType (home/semi-home): ")
  (let ((buffer (my/tab-get-buffer type)))
    (if buffer
        (progn
          (switch-to-buffer buffer)
          (message "Switched to %s buffer." type))
      (message "No %s buffer set for this tab" type))))

(defun my/tab-describe-buffer-alist ()
  "Print each (tab-name . buffer-alist) pair in `my/tab-buffer-alist`."
  (interactive)
  (message "%s" (mapconcat (lambda (pair)
                             (format "%s: %s" (car pair) (mapconcat (lambda (bp)
                                                                      (format "%s: %s" (car bp) (cdr bp)))
                                                                    (cdr pair) ", ")))
                           my/tab-buffer-alist
                           ", ")))

(defun my/tab-is-any-buffer (type)
  "Check if the current buffer is of a given type (home or semi-home) in any tab."
  (let ((current-buffer-name (buffer-name))
        (found nil))
    (dolist (tab-entry my/tab-buffer-alist found)
      (when (string= (cdr (assoc type (cdr tab-entry))) current-buffer-name)
        (setq found t)))
    found))

(defun my/tab-jump-to (index)
  "Jump to the tab at the specified INDEX."
  (interactive "p")
  (tab-bar-select-tab index))

(defun my/tab-move (&optional step)
  "Move to the next tab, or move STEP tabs if specified."
  (interactive
   (list (if current-prefix-arg
             (prefix-numeric-value current-prefix-arg)
           (read-number "Enter step: " 1))))
  (tab-move step))

(defun my/tab-remove-1 ()
  (interactive)
  (my/tab-jump-to 1)
  (tab-close)
  )


;; Bindings
;; tab-bar-mode
(define-prefix-command 'my/tab-bar-mode)
(global-set-key (kbd "M-t") 'my/tab-bar-mode)
(define-key my/tab-bar-mode (kbd "0") 'tab-close)
(define-key my/tab-bar-mode (kbd "1") 'tab-close-other)
(define-key my/tab-bar-mode (kbd "2") 'my/term-named)
(define-key my/tab-bar-mode (kbd "n") 'my/term-named)
(define-key my/tab-bar-mode (kbd "m") 'my/tab-move)
(define-key my/tab-bar-mode (kbd "r") 'tab-rename)
(define-key my/tab-bar-mode (kbd "d") 'my/tab-describe-buffer-alist)
(define-key my/tab-bar-mode (kbd "h") (lambda () (interactive) (my/tab-set-buffer "home")))
(define-key my/tab-bar-mode (kbd "s") (lambda () (interactive) (my/tab-set-buffer "semi-home")))

(define-key image-mode-map (kbd "h") (lambda () (interactive) (my/tab-set-buffer "home")))
(define-key image-mode-map (kbd "s") (lambda () (interactive) (my/tab-set-buffer "semi-home")))



(message "070-tab-bar-mode.el was loaded")
