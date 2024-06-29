(setq my/inits-dir "/home/ywatanabe/.dotfiles/.emacs.d/inits/")


(defalias 'inits 'my/tab-inits )

(defun my/tab-inits ()
  (interactive)

  ;; Init
  (message "my/tab-inits")
  (my/term-named "inits")

  ;; Left
  (find-file my/inits-dir)
  (my/tab-set-buffer "home")
  (split-window-right)

  ;; Right
  (other-window 1)
  (my/term-name "inits")
  (term-send-raw-string (concat "cd " my/inits-dir " \n"))
  (term-send-raw-string "clear\n")
  (my/tab-set-buffer "semi-home")

  ;; Left
  (other-window -1)
  (my/tab-set-buffer "home")

  )

(message "082-my-tab-inits.el was loaded.")
