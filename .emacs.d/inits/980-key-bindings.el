; (define-key global-map (kbd "C-M-t") nil)
; (define-key dired-mode-map (kbd "s") nil)
; (define-key dired-mode-map (kbd "s") 'dired-sort-toggle-or-edit)
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; Escape
(define-key key-translation-map (kbd "ESC") 'execute-extended-command)

;; Backspace
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))
(define-key global-map (kbd "C-S-h") 'help)

;; (define-key key-translation-map (kbd "C-x C-m") ' openbuffer *Message*)

;; (define-key key-translation-map (kbd "C-x C-m") 'open-buffer)
(define-key global-map (kbd "C-x C-m") (lambda () (interactive) (switch-to-buffer "*Messages*")))
(define-key global-map (kbd "C-x C-m") #'(lambda () (interactive) (switch-to-buffer "*Messages*")))





;; Next line
(define-key global-map (kbd "C-n") 'next-line)

;; New line and indent
(define-key global-map (kbd "C-m") 'newline-and-indent)

;; Frame
(define-key global-map (kbd "C-x f") 'make-frame)


;; Navigation
(bind-key* "C-t" 'other-window)
(bind-key* "C-S-t" 'my/back-other-window)

;; Buffer
(define-key global-map (kbd "C-S-k") 'my/kill-or-hide-buffer)
;; (define-key global-map (kbd "C-S-k") 'kill-this-buffer)
(define-key global-map (kbd "C-S-M-k") 'kill-all-buffers)
(global-set-key (kbd "C-c k") 'browse-kill-ring)


;; Insert last message
(define-key global-map (kbd "C-x m") 'my/insert-last-message)
;; Insert file name
(global-set-key (kbd "C-c TAB") 'my/insert-file-name-here)





;; ;; yasnippet
;; (define-key yas-minor-mode-map (kbd "C-x i i") 'yas-insert-snippet)
;; (define-key yas-minor-mode-map (kbd "C-x i n") 'yas-new-snippet)
;; (define-key yas-minor-mode-map (kbd "C-x i v") 'yas-visit-snippet-file)

;; Magit
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-c d") 'magit-diff-buffer-file)
;; (global-set-key (kbd "<your-keybinding>") 'toggle-magit-status)
;; (global-set-key (kbd "C-M-i") 'toggle-enable-disable-magit)
;; (global-set-key (kbd "C-M-i") 'toggle-enable-disable-magit)







;; company
;; (global-set-key (kbd "C-M-i") 'company-complete)
;; (define-key company-active-map (kbd "C-n") 'company-select-next)
;; (define-key company-search-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "C-s") 'company-filter-candidates)
(define-key company-active-map (kbd "C-i") 'company-complete-selection)
(define-key company-active-map (kbd "C-f") 'company-complete-selection)
(define-key company-active-map [tab] 'company-complete-selection)

;; (define-key emacs-lisp-mode-map (kbd "C-M-i") 'company-complete)

;; reload
(global-set-key (kbd "C-S-r") 'my/reload-emacs)
(global-set-key (kbd "<f5>") 'my/revert-buffer-no-confirm)


;; undo
(define-key global-map (kbd "C-;") 'undo-tree-undo)
(define-key global-map (kbd "C-'") 'undo-tree-redo)





;; ;; flycheck
;; (define-key global-map (kbd "C-M-f") 'flycheck-mode)

;; ;; guides
;; (define-key global-map (kbd "C-M-g") 'highlight-indent-guides-mode)

;; delete-trailing-whitespace
(define-key global-map (kbd "C-M-d") 'my/delete-trailing-whitespace)


;; (define-key term-mode-map (kbd "C-x C-f") 'my/find-file-in-term-directory)
(define-key global-map (kbd "C-c C-f") 'my/find-file-in-term-directory)




;; whisper
(define-key global-map (kbd "M-RET") 'whisper-run)
;; (define-key global-map (kbd "C-M-T") 'whisper-run)
;; (define-key global-map (kbd "C-M-t") nil)

;; term mode









;; (defvar toggle-previous-next-buffer-last 'next
;;   "Keep track of the last buffer switch direction for toggling.")

;; (defun my/toggle-previous-next-buffer ()
;;   "Toggle between the previous and next buffer."
;;   (interactive)
;;   (if (eq toggle-previous-next-buffer-last 'next)
;;       (progn
;;         (previous-buffer)
;;         (setq toggle-previous-next-buffer-last 'previous))
;;     (progn
;;       (next-buffer)
;;       (setq toggle-previous-next-buffer-last 'next))))

;; (define-key global-map (kbd "C-q") 'my/toggle-previous-next-buffer)

;; (define-key global-map (kbd "C-q") 'previous-buffer)

;; ;; Python mode
;; (add-hook 'python-mode-hook
;;           (lambda ()
;;             (local-set-key (kbd "C-c C-f") 'my/insert-file-name-here)))


(define-key pdf-view-mode-map (kbd "M-h") 'pdf-annot-add-highlight-markup-annotation)

(message "980-key-bindings.el was loaded.")
