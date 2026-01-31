;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-12-04 08:08:22>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-vterm-10-yank.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun --my/vterm-yank ()
  "Yank text to vterm; if in ipdb, paste line by line."
  (interactive)
  (if (--my/vterm-ipdb-p)
      (let ((lines (split-string (current-kill 0) "\n" t)))
        (dolist (line lines)
          (vterm-send-string line)
          (vterm-send-return)))
    (vterm-yank))
  (--my/vterm-to-char-mode))

(defun --my/vterm-ipdb-p ()
  "Return non-nil if current buffer is in ipdb REPL."
  (save-excursion
    (let* ((case-fold-search nil)
           (last-ipdb-pos
            (progn
              (goto-char (point-max))
              (when (re-search-backward "^ipdb> " nil t)
                (point))))
           (last-ipy-pos
            (progn
              (goto-char (point-max))
              (when (re-search-backward "^In \\[[0-9]+\\]: " nil t)
                (point)))))
      (and last-ipdb-pos
           (or (not last-ipy-pos)
               (> last-ipdb-pos last-ipy-pos))))))

(defvar --my/vterm-yank-selected-ssh-info nil
  "Cached SSH info from host selection to avoid duplicate prompts.")

(defun --my/vterm-yank-as-file-both-text-and-image ()
  "Yank both text and image from Windows clipboard history to vterm.
First yanks the text (second most recent clipboard entry) using `ecc-vterm-yank-as-file',
then yanks the image (most recent clipboard entry) using `wsl-yank-image'.
This is useful after capturing a debug snapshot with Ctrl+Shift+I in browser,
which copies console logs (text) first, then screenshot (image) to clipboard history.
Prompts for host selection only once and reuses it for both operations."
  (interactive)
  ;; Get SSH info once
  (let ((--my/vterm-yank-selected-ssh-info
         (if (fboundp '--ecc-get-ssh-info-from-selection)
             (--ecc-get-ssh-info-from-selection)
           nil)))
    ;; Use the cached SSH info for both operations
    (cl-letf (((symbol-function '--ecc-get-ssh-info-from-selection)
               (lambda () --my/vterm-yank-selected-ssh-info)))
      (ecc-vterm-yank-as-file)
      (wsl-yank-image))))


(provide '03-ui-000-vterm-10-yank)

(when
    (not load-file-name)
  (message "03-ui-000-vterm-10-yank.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))