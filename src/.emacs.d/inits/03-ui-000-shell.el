;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-04-16 07:28:34>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-shell.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

(add-to-list 'auto-mode-alist
             '("\\.sh\\.src\\'" . sh-mode))
(add-to-list 'auto-mode-alist
             '("\\.sh\\.source\\'" . sh-mode))
(add-to-list 'auto-mode-alist
             '("\\.def\\'" . sh-mode))

(require 'sh-script)
(add-to-list 'sh-imenu-generic-expression
             '(nil
               "^\\s-*function\\s-+\\([[:alpha:]-]+\\)\\s-*\\(?:()\\)?"
               1))

(defun my/shell-get-bash-completions
    (command)
  (with-temp-buffer
    (call-process "bash" nil t nil "-ic"
                  (format
                   "source ~/.bashrc && compgen -A function -A command %s"
                   command))
    (split-string
     (buffer-string)
     "\n" t)))

(defun my/shell-bash-completion-function
    ()
  (interactive)
  (let*
      ((input
        (minibuffer-contents))
       (completions
        (my/shell-get-bash-completions input)))
    (completion-in-region
     (minibuffer-prompt-end)
     (point-max)
     completions)))

(defun my/shell-async-run-with-loading-bashrc
    (&optional command)
  (interactive)
  (when-let
      ((buffer
        (get-buffer "*Async Shell Command*")))
    (kill-buffer buffer))
  (--my/shell-run-async-run-with-loading-bashrc command))

(defun --my/shell-run-async-run-with-loading-bashrc
    (&optional command)
  (interactive)
  (let*
      ((shell-file-name "bash")
       (shell-command-switch "-ic")
       (current-dir
        (if
            (eq major-mode 'dired-mode)
            (dired-current-directory)
          default-directory))
       (is-remote
        (file-remote-p current-dir))
       (bashrc-source ". ~/.bashrc && ")
       (cd-command
        (format "cd %s && "
                (shell-quote-argument
                 (if is-remote
                     (file-remote-p current-dir 'localname)
                   current-dir))))
       (command
        (or command
            (read-from-minibuffer "Shell command: "
                                  nil
                                  (let
                                      ((map
                                        (make-sparse-keymap)))
                                    (set-keymap-parent map
                                                       minibuffer-local-map)
                                    (define-key map "\t"
                                                #'my/shell-bash-completion-function)
                                    map)
                                  nil
                                  'shell-command-history)))
       (full-command
        (concat bashrc-source cd-command command))
       (proc
        (async-shell-command full-command)))
    (set-process-sentinel
     (get-buffer-process "*Async Shell Command*")
     (lambda
       (process event)
       (when
           (string-match "finished" event)
         (kill-buffer
          (process-buffer process)))))))

(defun my/shell-async-run-in-background
    (command)
  "Run shell COMMAND asynchronously in the background."
  (interactive "sCommand: ")
  (let
      ((output-buffer
        (generate-new-buffer
         (format " *%s*" command))))
    (set-process-sentinel
     (start-process-shell-command command output-buffer command)
     (lambda
       (process event)
       (when
           (memq
            (process-status process)
            '(exit signal))
         (kill-buffer
          (process-buffer process)))))))

;; Replace the after-init-hook with this

(define-key key-translation-map
            (kbd "C-S-<return>")
            (kbd "C-M-<return>"))

(global-set-key
 (kbd "C-M-<return>")
 'my/shell-async-run-with-loading-bashrc)

(with-eval-after-load 'dired
  (define-key dired-mode-map
              (kbd "C-M-<return>")
              'my/shell-async-run-with-loading-bashrc))

;; (defun my/sh-mode-setup
;;     ()
;;   (add-hook 'before-save-hook '--my/update-file-header nil t)
;;   (add-hook 'before-save-hook '--my/update-file-footer nil t))

;; (add-hook 'sh-mode-hook 'my/sh-mode-setup)

(provide '03-ui-000-shell)

(when
    (not load-file-name)
  (message "03-ui-000-shell.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))