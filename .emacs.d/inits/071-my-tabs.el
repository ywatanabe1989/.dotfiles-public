(defvar my/ylab-host "g08" "")

(defun my/tab-close-all ()
  "Close all tabs in the current Emacs session."
  (interactive)
  (if (fboundp 'tab-bar-mode)
      (progn
        (tab-bar-mode 1)  ; Ensure tab-bar-mode is enabled
        (while (> (length (tab-bar-tabs)) 1)
          (tab-bar-close-tab))
        (message "All tabs closed except the current one."))
    (message "Tab functionality not available in this Emacs version.")))

(defun my/tab-reset ()
  "Close all tabs in the current Emacs session."
  (interactive)
  (my/tab-close-all)
  (sleep-for 1)
  (my/tab-setup)
  )


(defun my/tab-setup ()
  (interactive)

  (my/tab-ripple-wm-code)
  (my/tab-ripple-wm-paper)

  ;; ;; Basics
  ;; (my/tab-bashd)
  ;; (my/tab-inits)
  ;; (my/tab-mngs)

  ;; (my/tab-scratch-message)

  ;; Removes the first tab
  (my/tab-remove-1)
  (my/tab-jump-to 1))



(message "071-my-tabs.el was loaded.")
