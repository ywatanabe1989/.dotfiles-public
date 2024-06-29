;; -*- lexical-binding: t -*-


(save-place-mode t)
(setq use-dialog-box nil)
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)


(use-package command-log-mode
  :config
  (global-command-log-mode nil)
  ; (clm/open-command-log-buffer)
  ; (clm/close-command-log-buffer)
  )




;; windows
(pixel-scroll-precision-mode)

;; cua
(cua-selection-mode t)

;; Disables backup
(setq make-backup-files nil)

;; Disables autosave
(setq auto-save-default nil)

;; Delete auto-save files
(setq delete-auto-save-files t)

;; Backup Dir
;; (add-to-list 'backup-directory-alist
;;              (cons "." "~/.emacs.d/backups/"))

;; ;; Auto Saving Dir
;; (setq auto-save-file-name-transforms
;;       `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))

;; Disables the bell
(setq ring-bell-function 'ignore)
(setq visible-bell t)

;; Comment Style
(setq comment-style 'multi-line)

;; Disable checking remote files
(global-auto-revert-mode t)

;; Enable y/n questions
(fset 'yes-or-no-p 'y-or-n-p)

;; Ignore case on file name completion
(setq read-file-name-completion-ignore-case t)

;; Follow symlinks
(setq vc-follow-symlinks t)

;; Scroll step
(setq scroll-conservatively 1)
(setq scroll-step 1)

;; Enable Upcase/Downcase-region
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Disable right-to-left languages
(setq-default bidi-display-reordering nil)

;; Inhibit startup-message
(setq inhibit-startup-message t)

;; Disable splash screen
(setq inhibit-startup-screen t)


;; Auto save
(setq auto-save-timeout 5)
(setq auto-save-interval 60)

;; Show buffer size
(size-indication-mode t)

;; GC
(setq gc-cons-threshold most-positive-fixnum)
(setq gc-cons-threshold (* 1024 1024 100))
(setq garbage-collection-messages t)

;; ;; History limits for the mini-buffer
;; (setq history-length 1000)
;; Save what you enter into minibuffer prompts
(setq history-length 25)
(savehist-mode t)

;; regexp
(require 'visual-regexp-steroids)
(setq vr/engine 'python)


(defun my/reload-emacs ()
  (interactive)
  (load-file "~/.emacs.d/init.el")
)
(global-set-key (kbd "C-S-r") 'my/reload-emacs)

(defun my/back-other-window ()
  (interactive)
  (other-window -1)
)

(defun _my/last-message (&optional num)
  (or num (setq num 1))
  (if (= num 0)
      (current-message)
    (with-current-buffer "*Messages*"
      (save-excursion
        (forward-line (- 1 num))
        (backward-char)
        (let ((end (point)))
          (forward-line 0)
          (buffer-substring-no-properties (point) end))))))

(defun my/last-message (&optional num)
  (interactive "*p")
  (insert (_my/last-message num)))

(defun my/revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive)
    (message "Reloaded.")
    (revert-buffer :ignore-auto :noconfirm))


(defun my/delete-trailing-whitespace-and-comments ()
  "Delete trailing whitespace and trailing comments, then notify in the minibuffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (end-of-line)
      (delete-horizontal-space)
      (let ((syntax (syntax-ppss)))
        (when (nth 4 syntax)
          (goto-char (nth 8 syntax))
          (skip-syntax-backward " ")
          (when (not (bolp))
            (delete-region (point) (progn (end-of-line) (point))))))
      (forward-line 1))
    (message "Trailing whitespaces and comments are deleted.")))

(bind-key* (kbd "C-M-d") 'my/delete-trailing-whitespace-and-comments)



(defun my/delete-trailing-whitespace ()
  "Delete trailing whitespace and notify in the minibuffer."
  (interactive)
  (delete-trailing-whitespace)
  (message "Trailing whitespaces are deleted."))

(defun my/close-dired-buffers ()
  (interactive)
  (mapc (lambda (buffer)
          (when (eq 'dired-mode (buffer-local-value 'major-mode buffer))
            (kill-buffer buffer)))
        (buffer-list)))

(defun my/df ()
  (interactive)
  (delete-frame)
)

(defun my/mv (new-path)
  "Move/rename the current buffer and the file it's visiting to NEW-PATH."
  (interactive "FNew path: ")
  (let ((old-path (buffer-file-name)))
    (unless old-path
      (error "Buffer '%s' is not visiting a file!" (buffer-name)))
    (if (get-buffer new-path)
        (error "A buffer named '%s' already exists!" new-path))
    (rename-file old-path new-path 1)
    (rename-buffer new-path)
    (set-visited-file-name new-path)
    (set-buffer-modified-p nil)
    (message "Moved '%s' to '%s'" old-path new-path)))

(defun my/copy-region-or-buffer ()
  (interactive)
  "If region is not activated, set the region-start and region-end as the start and end of the buffer, then copy to kill ring."
  (if (use-region-p)
      (kill-ring-save (region-beginning) (region-end))
    (kill-ring-save (point-min) (point-max))))

(defun my/insert-tree-parts ()
  "Eval unicode decimal codes for expressing tree structures."
  (interactive)
  (insert "")
  (newline)
  (insert "")
  (newline)
  (insert "")
  (newline)
  (insert "")
  )


(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)


;; (defun remove-multibyte-characters ()
;;   "Remove all multibyte characters from the current buffer."
;;   (interactive)
;;   (save-excursion
;;     (goto-char (point-min))
;;     (while (not (eobp))
;;       (let ((char (char-after)))
;;         (if (> (string-bytes (string char)) 1)
;;             (delete-char 1)
;;           (forward-char 1))))))

;; (add-hook 'before-save-hook 'remove-multibyte-characters)

;; Revert Dired and other buffers
(defun my/revert-buffer-with-no-confirm ()
  "Revert buffer without confirmation."
  (interactive)
  (clear-image-cache)
  (revert-buffer nil t))
(global-set-key (kbd "C-S-r") 'my/revert-buffer-with-no-confirm)

;; (setq revert-without-query '(".*"))


;; (defun always-kill-buffer ()
;;   "Always kill the buffer without confirmation."
;;   t)

;; (add-to-list 'kill-buffer-query-functions 'always-kill-buffer)
;; (setq kill-buffer-query-functions (delq 'process-kill-buffer-query-function kill-buffer-query-functions))



(defun my/replace-nnbsp-with-space ()
  (interactive)
  "Replace narrow no-break spaces with regular spaces."
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\u202F" nil t)
      (replace-match " "))))

(add-hook 'find-file-hook 'my/replace-nnbsp-with-space)


(setq large-file-warning-threshold 100000000)

(defun my/doublequoted-bracket ()
  (interactive)
  (save-excursion
    (let ((start (region-beginning))
          (end (region-end)))
      (goto-char start)
      (insert "[\"")
      (goto-char (+ end 2))
      (insert "\"]"))))


(defun my/remove-dos-eol ()
  "Remove dos end of line (^M) in the buffer before saving."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\r" nil t) (replace-match ""))))

(add-hook 'before-save-hook 'my/remove-dos-eol)

;; (setq debug-on-error nil)

(message "000-base.el was loaded.")


(defun my/eval-buffer ()
  "Evaluate the current buffer and jump to the first error, if any."
  (interactive)
  (condition-case err
      (eval-buffer)
    (error
     (message "Caught an error: %s" (error-message-string err))
     ;; Attempt to find the line from the error text
     (when-let ((line-number (my/get-line-number-from-error (error-message-string err))))
       (goto-line line-number)))))

(defun my/get-line-number-from-error (error-message)
  "Extract line number from the error message, if present."
  (when (string-match "at line \\([0-9]+\\)" error-message)
    (string-to-number (match-string 1 error-message))))
