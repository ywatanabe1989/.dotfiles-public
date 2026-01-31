;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:07:47>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-001-mv-or-write-file.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-07 15:16:23>
;;; File: ./.dotfiles/.emacs.d/inits/000-move-or-write-file.el

(defun my/mv-or-write-file (tgt)
  "Move or write file based on the directory.

If tgt is in the same directory, move the file.
Otherwise, write the file to the new target."
  (interactive "FMove or write file to: ")
  (let ((current-file (buffer-file-name)))
    (if (not current-file)
        (error "Buffer is not visiting a file"))
    (let ((current-dir (file-name-directory current-file))
          (target-dir (file-name-directory tgt)))
      (if (string= current-dir target-dir)
          (let
              ((new-file
                (concat current-dir (file-name-nondirectory tgt))))
            (rename-file current-file new-file)
            (set-visited-file-name new-file)
            (set-buffer-modified-p nil)
            (message "File moved to %s" new-file))
        (write-file tgt)
        (message "File written to %s" tgt)))))

(global-set-key (kbd "C-x C-w") 'my/mv-or-write-file)

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-001-mv-or-write-file)

(when
    (not load-file-name)
  (message "02-base-001-mv-or-write-file.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))