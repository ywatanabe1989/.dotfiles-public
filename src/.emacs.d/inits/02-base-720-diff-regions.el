;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-04-24 15:07:58>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-720-diff-regions.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun diff-regions ()
  "Compare two regions using diff. Mark first region, call this command, then mark second region."
  (interactive)
  (if (not (region-active-p))
      (error "No region active")
    (let ((r1-beg (region-beginning))
          (r1-end (region-end))
          (buf1 (generate-new-buffer "*diff-region-1*"))
          r2-beg
          r2-end
          (buf2 (generate-new-buffer "*diff-region-2*")))
      (append-to-buffer buf1 r1-beg r1-end)
      (deactivate-mark)
      (message "Mark second region and press C-c C-c")
      (let ((done nil))
        (while (not done)
          (let ((key (read-key-sequence nil)))
            (if (equal key "\C-c\C-c")
                (setq done t)
              (let ((command (key-binding key)))
                (when command
                  (call-interactively command))))))
        (if (not (region-active-p))
            (error "No second region marked")
          (setq r2-beg (region-beginning)
                r2-end (region-end))
          (append-to-buffer buf2 r2-beg r2-end)
          (diff buf1 buf2))))))

(bind-key* (kbd "C-c C-d") 'diff-regions)

(defun my/kill-region-without-diff-markers (beg end)
  "Kill region from BEG to END but strip leading + or - in each line."
  (interactive "r")
  (let ((raw-text (buffer-substring-no-properties beg end)))
    (delete-region beg end)
    (with-temp-buffer
      (insert raw-text)
      (goto-char (point-min))
      (while (not (eobp))
        (when (looking-at "^[+-]")
          (delete-char 1))
        (forward-line))
      (kill-new (buffer-string)))))

(global-set-key (kbd "C-S-w") #'my/kill-region-without-diff-markers)


(provide '02-base-720-diff-regions)

(when
    (not load-file-name)
  (message "02-base-720-diff-regions.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))