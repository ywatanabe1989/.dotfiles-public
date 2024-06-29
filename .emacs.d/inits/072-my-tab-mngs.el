(defun my/tab-mngs ()
  (interactive)
  ;; Init
  (message "my/tab-mngs")
  (my/term-named "mngs")

  ;; Left
    (find-file "/ssh:ywatanabe@crest:/home/ywatanabe/proj/mngs_repo/src/mngs/")
  (split-window-right)

  ;; Right
  (other-window 1)
  (my/term-name "mngs")
    (term-send-raw-string "ssh crest \n")
  (term-send-raw-string "cd /home/ywatanabe/proj/mngs_repo \n")
  (term-send-raw-string "clear\n")
  (my/tab-set-buffer "semi-home")

  ;; Left
  (other-window -1)
  (my/tab-set-buffer "home")
  )

;; (defun my/tab-ripple-wm-mngs ()
;;   (interactive)
;;   ;; Init
;;   (message "my/tab-ripple-wm-code-mngs")
;;     (my/term-named "ripple-wm-code-mngs")
;;     ;; Left
;;     (find-file "/ssh:ywatanabe@crest:/home/ywatanabe/proj/ripple-wm/code/scripts/externals/mngs/src/mngs/")
;;     (split-window-right)
;;     (other-window 1)

;;     ;; Right
;;     (my/term-name "ripple-wm-code-mngs")
;;     (term-send-raw-string "ssh crest \n")
;;     (term-send-raw-string "cd /home/ywatanabe/proj/ripple-wm/code/ \n")
;;     ;; (term-send-raw-string "ipy \n")
;;     (term-send-raw-string "\C-l")
;;     (my/tab-set-buffer "semi-home")

;;     ;; Left
;;     (other-window -1)
;;     (my/tab-set-buffer "home")
;;     )

(message "081-my-tab-mngs.el was loaded.")
