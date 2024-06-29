;; -*- lexical-binding: t -*-

;; ibuffer
;; https://emacs.stackexchange.com/questions/202/close-all-dired-buffers
;; (require 'all-the-icons)

(require 'ibuffer)

(setq-default ibuffer-saved-filter-groups
              `(("Default"
                 ("Org" (mode . org-mode))
                 ("GPT" (name . "\\*GPT\\*"))
                 ("Python" (mode . python-mode))
                 ("Lisp" (mode . lisp-mode))
                 ("Terminal" (or
                            (mode . term-mode)
                            (mode . eshell-mode)
                            (mode . shell-mode)))
                 ("Dired" (mode . dired-mode))
                 ("Temporary" (name . "^\\*.*\\*$")))))

;; (setq ibuffer-default-sorting-mode 'major-mode)

(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-auto-mode 1)
            (ibuffer-switch-to-saved-filter-groups "Default")
            (ibuffer-do-sort-by-recency)
            ;; (my/ibuffer-icon-mode-hook)
            (isearch-forward)
            (define-key global-map (kbd "M-s") (lambda () (interactive) (my/tab-jump-to-buffer "semi-home")))
            ))

(global-set-key (kbd "C-x C-b") 'ibuffer)

;; just global buffer
(defun my/jump-buffer (buffername)
  "Switch to a buffer if it is open in any window, otherwise open it in the current window."
  (interactive "sEnter buffer name: ")
  (let ((buffer (get-buffer buffername)))
    (if buffer
        (let ((window (get-buffer-window buffer t)))
          (if window
              (select-window window)
              (switch-to-buffer buffer)))
      (message "No buffer named %s exists" buffername))))

(defun my/named-buffer (buffer-name)
  "Open a buffer with the specified BUFFER-NAME. If the buffer does not exist, create it."
  (interactive "sEnter buffer name: ")
  (let ((buffer (get-buffer-create buffer-name)))
    (switch-to-buffer buffer)))


(define-key ibuffer-mode-map (kbd "M-s") nil)

(defun my/jump-to-messages ()
  (interactive)
  (message "my/jump-to-messages")
  (switch-to-buffer '*Messages*)
  )

(define-key global-map (kbd "C-x C-m") 'my/jump-to-messages)

(message "030-ibuffer.el was loaded.")
