(use-package multi-term
  :ensure t
  :config
  (add-hook 'term-mode-hook (lambda ()
                              ;; Disable company-mode in term
                              (company-mode -1)
                              ;; Remove the process kill confirmation specifically for term buffers
                              (setq-local kill-buffer-query-functions
                                          (remq 'process-kill-buffer-query-function kill-buffer-query-functions))))
  )

(setq kill-buffer-query-functions
      (remq 'process-kill-buffer-query-function kill-buffer-query-functions))

(defun my/term-send-forward-char ()
  (interactive)
  (term-send-raw-string "\C-f"))

(defun my/term-send-backward-char ()
  (interactive)
  (term-send-raw-string "\C-b"))

(defun my/term-send-previous-line ()
  (interactive)
  (term-send-raw-string "\C-p"))

(defun my/term-send-next-line ()
  (interactive)
  (term-send-raw-string "\C-n"))

(defun my/term-send-return ()
  (interactive)
  (term-send-raw-string "\C-m"))

(defun my-term-send-C-w ()
  "Send `C-w` to the terminal."
  (interactive)
  (term-send-raw-string "\C-w"))

(defun my/term-send-tab ()
  (interactive)
  (term-send-raw-string "\t"))

;; (defun my/term-name (arg)
;;   (interactive
;;    (list
;;     (read-string "Enter string: ")))
;;   (let ((buffer-name (format "Term: %s" arg)))
;;     (if (get-buffer buffer-name)
;;         (switch-to-buffer buffer-name)
;;       (progn
;;         (multi-term)
;;         (rename-buffer buffer-name)))))

;; (defun my/term-name (arg)
;;   (interactive
;;    (list
;;     (read-string "Enter string: ")))
;;   (let ((buffer-name (format "Term: %s" arg)))
;;       (progn
;;         (multi-term)
;;         (rename-buffer buffer-name))))
(defun my/term-name (arg)
  "Create a new terminal with a given name, adding numbers if the name already exists."
  (interactive
   (list
    (read-string "Enter string: ")))
  (let ((base-name (format "Term: %s" arg))
        (counter 1)
        (buffer-name))
    (setq buffer-name base-name)
    (while (get-buffer buffer-name)
      (setq counter (1+ counter)
            buffer-name (format "%s<%d>" base-name counter)))
    (progn
      (multi-term)
      (rename-buffer buffer-name))))


(defvar my/multi-term-counter 0 "Counter to track the number of terminals opened.")

(defun my/multi-term-on-client (arg)
  "Open a new terminal buffer with a unique name based on the provided argument."
  (interactive
   (list
    (read-string "Enter base name for terminal: " "")))
  (defun generate-unique-term-name (base)
    (let ((name (format "Term: %s-%d" base my/multi-term-counter)))
      (setq my/multi-term-counter (1+ my/multi-term-counter))
      name))

  (multi-term)

  (let ((new-name (generate-unique-term-name arg)))
    (rename-buffer new-name)))

;; (defun my/multi-term-on-client (arg)
;;   (interactive
;;    (list
;;     (read-string "Enter string: ")))
;;   (find-file "//tmp")
;;   (multi-term)
;;   (rename-buffer (message "Term: %s" arg))
;;   (kill-buffer "tmp")
;;   )

(defun my/term-get-remote-info ()
  "Get the current working directory, user, and host of the remote shell."
  (interactive)
  (let (user host cwd)
    ;; Send the 'echo' command to print user, host, and working directory.
    (term-send-raw-string "echo my_remote_info $(whoami)@$(hostname):$(pwd)")
    ;; probably, here, return is not pressed
    ;; Wait briefly to ensure the command output is in the buffer.
    (my/term-send-return)
    (sleep-for 0.5)
    ;; Search buffer for the output pattern.
    (save-excursion
      (goto-char (point-max))
      (when (search-backward-regexp "my_remote_info \\(.*\\)" nil t)
        ;; Capture the match.
        (let ((info (match-string 1)))
          ;; Split the info into user, host, and cwd.
          (when (string-match "\\(.*\\)@\\(.*\\):\\(.*\\)" info)
            (setq user (match-string 1 info))
            (setq host (match-string 2 info))
            (setq cwd (match-string 3 info))))))
    ;; Return a plist of the remote info.
    (list :user user :host host :cwd cwd)))

(defun my/find-file-in-term-directory ()
  "Open `find-file` with the current directory of the `multi-term`."
  (interactive)
  ;; Get remote info as a property list.
  (let* ((remote-info (my/term-get-remote-info))
         (user (plist-get remote-info :user))
         (host (plist-get remote-info :host))
         (cwd (plist-get remote-info :cwd))
         (default-directory (format "/ssh:%s@%s:%s/" user host cwd)))
    ;; Call `find-file` with the remote path.
    (call-interactively 'find-file)))

;; (defun my/multi-term-custom-bindings ()
;;   ;; Bind C-w to kill-region in multi-term's raw mode
;;   (define-key term-raw-map (kbd "C-w") 'kill-region))


(defun my/term-insert-mngs-src ()
  (interactive)
  (term-send-raw-string "mngs.gen.src(")
  )


(defun my/term-toggle-mode ()
  "Toggle between line mode and char mode in multi-term."
  (interactive)
  (if (eq major-mode 'term-mode)
      (if (term-in-line-mode)
          (term-char-mode)
        (term-line-mode)
        (term-send-raw-string "\C-l")
        )
    (message "Not in a term buffer")))

;; kill-line
(defun my/term-kill-line ()
  (interactive)
  (ignore-errors (kill-line))
  (term-send-raw-string "\C-k")
  )

;; kill-region
(defun my/term-send-raw-set-mark ()
  (interactive)
  (term-char-mode)
  (set-face-background 'mode-line "darkgreen")
  (set-mark-command))

(defun my/term-send-raw-kill-region ()
  (interactive)
  (kill-region (region-beginning) (region-end))
  (term-line-mode)
  (set-face-background 'mode-line "black")
  (term-send-raw-string "\C-l")
  )


(defun my/term-send-raw-set-mark ()
  (interactive)
  (term-send-raw)
  (set-mark-command nil))

(defun my/term-send-raw-kill-region ()
  (interactive)
  (term-send-raw)
  (kill-region (region-beginning) (region-end)))


(defun my/multi-term-custom-bindings ()
  ;;;; kill-line
  (define-key term-raw-map (kbd "\C-k") 'my/term-kill-line)

  ;;;; kill-region
  (define-key term-raw-map (kbd "C-SPC") nil)
  (define-key term-raw-map (kbd "C-w") nil)
  (define-key term-raw-map (kbd "C-SPC") 'my/term-send-raw-set-mark)
  (define-key term-raw-map (kbd "C-w") 'my/term-send-raw-kill-region)

  ;;;; toggle-mode
  (define-key term-raw-map (kbd "M-m") 'my/term-toggle-mode)


  ;; (define-key term-raw-map (kbd "\C-y") 'my/term-yank)
  ;; (define-key term-raw-map (kbd "\C-w") 'my/term-kill-region) ; not working


  (define-key term-raw-map (kbd "\C-f") (lambda () (interactive) (term-send-raw-string "\C-f")))
  (define-key term-raw-map (kbd "\C-b") (lambda () (interactive) (term-send-raw-string "\C-b")))
  (define-key term-raw-map (kbd "\C-p") (lambda () (interactive) (term-send-raw-string "\C-p")))
  (define-key term-raw-map (kbd "\C-n") (lambda () (interactive) (term-send-raw-string "\C-n")))
  (define-key term-raw-map (kbd "M-j") 'term-line-mode)
  (define-key term-mode-map (kbd "M-k") 'term-char-mode)
  ;; (define-key term-raw-map (kbd "C-SPC") 'cua-set-mark)




  (define-key term-raw-map (kbd "C-c p") 'multi-term-prev)
  (define-key term-raw-map (kbd "C-c n") 'multi-term-next)

  (define-key term-raw-map (kbd "M-1") (lambda () (interactive) (my/tab-jump-to 1)))
  (define-key term-raw-map (kbd "M-2") (lambda () (interactive) (my/tab-jump-to 2)))
  (define-key term-raw-map (kbd "M-3") (lambda () (interactive) (my/tab-jump-to 3)))
  (define-key term-raw-map (kbd "M-4") (lambda () (interactive) (my/tab-jump-to 4)))
  (define-key term-raw-map (kbd "M-5") (lambda () (interactive) (my/tab-jump-to 5)))
  (define-key term-raw-map (kbd "M-6") (lambda () (interactive) (my/tab-jump-to 6)))
  (define-key term-raw-map (kbd "M-7") (lambda () (interactive) (my/tab-jump-to 7)))
  (define-key term-raw-map (kbd "M-8") (lambda () (interactive) (my/tab-jump-to 8)))
  (define-key term-raw-map (kbd "M-9") (lambda () (interactive) (my/tab-jump-to 9)))
  (define-key term-raw-map (kbd "M-h") (lambda () (interactive) (my/tab-jump-to-buffer "home")))
  (define-key term-raw-map (kbd "M-s") (lambda () (interactive) (my/tab-jump-to-buffer "semi-home")))
  )

(add-hook 'term-mode-hook 'my/multi-term-custom-bindings)

(global-set-key (kbd "C-S-m") 'my/multi-term-on-client)
(global-set-key (kbd "C-S-a") 'my/term-name)

;; References
;; http://sleepboy-zzz.blogspot.com/2012/12/emacsmulti-termel.html
