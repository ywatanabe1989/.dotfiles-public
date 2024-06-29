(setq my/bashd-dir "/home/ywatanabe/.dotfiles/.bash.d/")

(defalias 'bash.d 'my/tab-bashd)

(defun my/tab-bashd ()
  (interactive)

  ;; Init
  (message "my/tab-bash.d")
  (my/term-named ".bash.d")

  ;; Left
  (find-file my/bashd-dir)
  (my/tab-set-buffer "home")
  (split-window-right)

  ;; Right
  (other-window 1)
  (my/term-name "bashd")
  (term-send-raw-string (concat "cd " my/bashd-dir " \n"))
  (term-send-raw-string "clear\n")
  (my/tab-set-buffer "semi-home")

  ;; Left
  (other-window -1)
  (my/tab-set-buffer "home")

  )

(message "082-my-tab-bash.d.el was loaded.")
