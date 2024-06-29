;; -*- lexical-binding: t -*-

(use-package time-stamp
  :ensure t
  :config
  (setq
   time-stamp-active t
   time-stamp-line-limit 10
   time-stamp-format "%Y-%02m-%02d %02H:%02M:%02S (%u)"))

(use-package autoinsert
  :config
  (setq auto-insert-query nil)
  (auto-insert-mode 1)
  )

(add-hook 'write-file-hooks 'time-stamp)

(message "060-timestamp.el was loaded.")
