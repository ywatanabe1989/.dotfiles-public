;; consult - preview everything
(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("M-g g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ))
         ;; ("M-s f" . consult-find)
         ;; ("M-s l" . consult-line)  ;; key word
         ;; ("M-s g" . consult-grep)))

(message "270-consult.el was loaded.")
