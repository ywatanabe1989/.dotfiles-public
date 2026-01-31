;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:18>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-999-delete-this-file.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-09 12:20:31>
;;; File: ./.dotfiles/.emacs.d/inits/100-editing/999-delete-this-file.el

(defun my/to-old-this-file ()
  "Move current file to .old directory with _ prefix/suffix and kill its buffer."
  (interactive)
  (let* ((file (buffer-file-name))
         (old-dir (expand-file-name ".old" (file-name-directory file)))
         (base-name (file-name-nondirectory file))
         (new-base-name (concat "_" base-name "_"))
         (new-name (expand-file-name new-base-name old-dir)))
    (when (and file
               (file-exists-p file)
               (yes-or-no-p
                (format "Move %s to .old/_%s_? " file base-name)))
      (unless (file-exists-p old-dir)
        (make-directory old-dir t))
      (rename-file file new-name t)
      (kill-buffer)
      (message "Moved to %s" new-name))))

(global-set-key (kbd "C-c o") 'my/to-old-this-file)

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-999-delete-this-file)

(when
    (not load-file-name)
  (message "02-base-999-delete-this-file.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))