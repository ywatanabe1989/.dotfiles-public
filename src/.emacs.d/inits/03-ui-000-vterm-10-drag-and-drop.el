;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-28 18:21:00>
;;; File: /home/ywatanabe/.emacs.d/inits/03-ui-000-vterm-10-drag-and-drop.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun --my/vterm-handle-dnd (event)
  "Handle drag and drop in vterm with multiple file types."
  (interactive "e")
  (let* ((files (nth 2 event))
         (file-list (if (listp files) files (list files))))
    (dolist (file file-list)
      (let ((file-path (expand-file-name file)))
        (cond
         ((string-match
           "\\.\\(jpe?g\\|png\\|gif\\|bmp\\|tiff?\\|webp\\)$" file)
          (vterm-send-string
           (format "display %s &" (shell-quote-argument file-path))))
         ((string-match "\\.\\(pdf\\|ps\\|eps\\)$" file)
          (vterm-send-string
           (format "evince %s &" (shell-quote-argument file-path))))
         ((string-match "\\.\\(mp4\\|avi\\|mov\\|mkv\\|webm\\)$" file)
          (vterm-send-string
           (format "vlc %s &" (shell-quote-argument file-path))))
         ((string-match "\\.\\(mp3\\|wav\\|ogg\\|flac\\)$" file)
          (vterm-send-string
           (format "mpv %s &" (shell-quote-argument file-path))))
         ((string-match "\\.\\(html?\\|xml\\)$" file)
          (vterm-send-string
           (format "firefox %s &" (shell-quote-argument file-path))))
         (t
          (vterm-send-string
           (format " %s" (shell-quote-argument file-path)))))
        (vterm-send-return)))))

(add-hook 'vterm-mode-hook
          (lambda ()
            (define-key vterm-mode-map [drag-n-drop]
                        '--my/vterm-handle-dnd)))

;; (defun --my/vterm-handle-figure-dnd (event file-list)
;;   "Handle figure drag and drop with appropriate commands."
;;   (interactive "e\nxFiles: ")
;;   (let ((files (if (listp file-list) file-list (list file-list))))
;;     (dolist (file files)
;;       (when
;;           (string-match "\\.[jp][pn]g\\|\\.[pgn]ng\\|\\.[jpg][pef]"
;;                         file)
;;         (vterm-send-string
;;          (format "display %s &" (shell-quote-argument file)))
;;         (vterm-send-return)))))


(provide '03-ui-000-vterm-10-drag-and-drop)

(when
    (not load-file-name)
  (message "03-ui-000-vterm-10-drag-and-drop.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))