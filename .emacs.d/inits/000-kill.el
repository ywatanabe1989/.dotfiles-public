(defun kill-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

(global-unset-key (kbd "C-\\"))

(defun my/kill-or-hide-buffer ()
  "Kill the current buffer unless it is any of home or semi-home buffers, in which case bury it."
  (interactive)
  (let ((current-buffer-name (buffer-name))
        (is-special-buffer (or (eq major-mode 'genai-mode)
                               (string= (buffer-name) "*GENAI*")
                               (string= (buffer-name) "*mu4e-headers*")
                               (my/tab-is-any-buffer "home")
                               (my/tab-is-any-buffer "semi-home"))))
    (if is-special-buffer
        (progn
          (bury-buffer)
          (message "Buried: %s" current-buffer-name))
      (progn
        (kill-buffer current-buffer-name)
        (message "Killed: %s" current-buffer-name)))))
