;; Agenda
(setq my/org-agenda-dir "~/proj/org/")
(setq org-agenda-files (list my/org-agenda-dir))
(setq org-agenda-weekend-days 'nil)
(setq org-todo-keywords
      '((sequence "TODO(t)" "DONE(d)" "CANCELED(c)" "WAITING(w)")))
(defface org-waiting-face
  '((t :foreground "gray"))
  "Face for WAITING tasks in org-mode.")
(setq org-todo-keyword-faces
      '(("WAITING" . org-waiting-face)))

;; Custom Functions
(defun my/org-agenda ()
  (interactive)
  (org-agenda nil "n")
  ;; (org-agenda-maybe-redo)
  (when (equal (buffer-name) "*Org Agenda*") (other-window 1)))

(defun my/org-agenda-to-right ()
  (interactive)
  ;; Check if there is a window to the right
  (unless (window-in-direction 'right)
    ;; If no window to the right, split the current window to the right
    (split-window-right))
  ;; Move focus to the right window
  (other-window 1)
  ;; Open or refresh Org Agenda in the current window
  (my/org-agenda))

;; (defun my/org-export-as-html ()
;;   "Export the current Org buffer to an HTML file."
;;   (interactive)


;; Bindings
(global-set-key (kbd "C-c C-a") 'my/org-agenda)
(global-set-key (kbd "C-c C-c") 'org-capture)


(message "112-org-agenda.el was loaded.")
