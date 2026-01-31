;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-17 23:59:41>
;;; File: /home/ywatanabe/.emacs.d/inits/02-base-001-window-highlight-window.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; ;;; -*- coding: utf-8; lexical-binding: t -*-
;; ;;; Author: ywatanabe
;; ;;; Timestamp: <2025-05-17 23:21:30>
;; ;;; File: /home/ywatanabe/.emacs.d/inits/02-base-001-window-highlight-window.el

;; ;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

;; ;; (use-package auto-dim-other-buffers)

;; ;; (auto-dim-other-buffers-mode -1)

;; (defun my/highlight-selected-window ()
;;   "Highlight selected window with a different background color."
;;   (walk-windows (lambda (w)
;;                   (unless (eq w (selected-window))
;;                     (with-current-buffer (window-buffer w)
;;                       (buffer-face-set '(:background "#111"))))))
;;   (buffer-face-set 'default))

;; (add-hook 'buffer-list-update-hook 'my/highlight-selected-window)
;; (remove-hook 'buffer-list-update-hook 'my/highlight-selected-window)

;; (provide '02-base-001-window-highlight-window)

;; (when
;;     (not load-file-name)
;;   (message "02-base-001-window-highlight-window.el loaded."
;;            (file-name-nondirectory
;;             (or load-file-name buffer-file-name))))


(provide '02-base-001-window-highlight-window)

(when
    (not load-file-name)
  (message "02-base-001-window-highlight-window.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))