;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:10:39>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/05-code-000-vc-smerge-mode.el

;; Modeline color for conflicts (buffer-local)

(defvar-local --my/smerge-mode-line-cookies nil
  "List of face remapping cookies for smerge mode line.")

(defun my/check-conflicts ()
  "Check if conflicts remain in buffer and update mode-line color (buffer-local)."
  (save-excursion
    (goto-char (point-min))
    ;; Remove existing remappings first
    (dolist (cookie --my/smerge-mode-line-cookies)
      (face-remap-remove-relative cookie))
    (setq --my/smerge-mode-line-cookies nil)
    ;; Add red background if conflicts exist
    (when (re-search-forward "^<<<<<<< " nil t)
      (push (face-remap-add-relative 'mode-line :background "darkred")
            --my/smerge-mode-line-cookies)
      (when (facep 'mode-line-active)
        (push
	 (face-remap-add-relative 'mode-line-active :background
				  "darkred")
         --my/smerge-mode-line-cookies)))
    (force-mode-line-update t)))

(defun my/smerge-mode-hook ()
  (if smerge-mode
      (progn
        (my/check-conflicts)
        (add-hook 'post-command-hook #'my/check-conflicts nil t))
    (remove-hook 'post-command-hook #'my/check-conflicts t)
    ;; Clean up face remappings when leaving smerge-mode
    (dolist (cookie --my/smerge-mode-line-cookies)
      (face-remap-remove-relative cookie))
    (setq --my/smerge-mode-line-cookies nil)
    (force-mode-line-update t)))

(add-hook 'smerge-mode-hook 'my/smerge-mode-hook)

(defun my/smerge-mode-maybe ()
  "Enable `smerge-mode' if the buffer contains conflict markers."
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^<<<<<<< " nil t)
      (smerge-mode 1))))

(add-hook 'find-file-hook 'my/smerge-mode-maybe)

(defun my/next-conflict-file ()
  "Open the next file with merge conflicts."
  (interactive)
  (when buffer-file-name
    (let* ((git-root (or (vc-git-root buffer-file-name)
                         default-directory))
           (default-directory git-root)
           (is-remote (file-remote-p git-root))
           (git-cmd (if is-remote
                        (concat (file-remote-p git-root) "git")
                      "git"))
           (conflicts (ignore-errors
                        (process-lines git-cmd "ls-files" "-u"))))
      (when conflicts
        (let*
            ((current (file-relative-name buffer-file-name git-root))
             (next-file (or (cadr (member current conflicts))
                            (car conflicts))))
          (when next-file
            (find-file (expand-file-name next-file git-root))))))))

;; Add keybinding

(define-key smerge-mode-map (kbd "C-c f") 'my/next-conflict-file)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Lower / Upper
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/smerge-keep-all-lower ()
  "Keep lower version for all conflicts in buffer or region."
  (interactive)
  (save-excursion
    (goto-char (if (use-region-p) (region-beginning) (point-min)))
    (while
        (re-search-forward "^<<<<<<< "
                           (if (use-region-p) (region-end)
                             (point-max))
                           t)
      (smerge-keep-lower))))

(defun my/smerge-keep-all-upper ()
  "Keep upper version for all conflicts in buffer or region."
  (interactive)
  (save-excursion
    (goto-char (if (use-region-p) (region-beginning) (point-min)))
    (while
        (re-search-forward "^<<<<<<< "
                           (if (use-region-p) (region-end)
                             (point-max))
                           t)
      (smerge-keep-upper))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Older / Newer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun smerge-get-timestamp (text)
  "Extract timestamp from conflict text. Returns nil if not found."
  (or (when (string-match "<\\([^>]+\\)>" text)
        (match-string 1 text))
      (when
          (string-match "\\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\\)"
                        text)
        (match-string 1 text))
      (when (string-match "\"\\([^\"]+\\)\"" text)
        (match-string 1 text))))

(defun smerge-keep-newer ()
  "Keep the newer version of a conflict."
  (interactive)
  (save-excursion
    (smerge-match-conflict)
    (let* ((beg1 (match-beginning 1))
           (end1 (match-end 1))
           (beg2 (match-beginning 3))
           (end2 (match-end 3))
           (text1 (buffer-substring beg1 end1))
           (text2 (buffer-substring beg2 end2))
           (ts1 (smerge-get-timestamp text1))
           (ts2 (smerge-get-timestamp text2)))
      (if (and ts1 ts2)
          (if (string< ts1 ts2)
              (smerge-keep-lower)
            (smerge-keep-upper))
        (smerge-keep-upper)
        (message "No timestamps found, keeping upper version")))))

(defun smerge-keep-older ()
  "Keep the older version of a conflict."
  (interactive)
  (save-excursion
    (smerge-match-conflict)
    (let* ((beg1 (match-beginning 1))
           (end1 (match-end 1))
           (beg2 (match-beginning 3))
           (end2 (match-end 3))
           (text1 (buffer-substring beg1 end1))
           (text2 (buffer-substring beg2 end2))
           (ts1 (smerge-get-timestamp text1))
           (ts2 (smerge-get-timestamp text2)))
      (if (and ts1 ts2)
          (if (string< ts1 ts2)
              (smerge-keep-upper)
            (smerge-keep-lower))
        (smerge-keep-lower)
        (message "No timestamps found, keeping lower version")))))

(defun my/smerge-keep-all-newer ()
  "Keep newer version for all conflicts in buffer or region."
  (interactive)
  (save-excursion
    (goto-char (if (use-region-p) (region-beginning) (point-min)))
    (while
        (re-search-forward "^<<<<<<< "
                           (if (use-region-p) (region-end)
                             (point-max))
                           t)
      (smerge-keep-newer))))

(defun my/smerge-keep-all-older ()
  "Keep older version for all conflicts in buffer or region."
  (interactive)
  (save-excursion
    (goto-char (if (use-region-p) (region-beginning) (point-min)))
    (while
        (re-search-forward "^<<<<<<< "
                           (if (use-region-p) (region-end)
                             (point-max))
                           t)
      (smerge-keep-older))))

(define-key smerge-mode-map (kbd "C-c L") 'my/smerge-keep-all-lower)

(define-key smerge-mode-map (kbd "C-c U") 'my/smerge-keep-all-upper)

(define-key smerge-mode-map (kbd "C-c N") 'my/smerge-keep-all-newer)

(define-key smerge-mode-map (kbd "C-c O") 'my/smerge-keep-all-older)

(define-key smerge-mode-map (kbd "M-n") 'smerge-next)

(define-key smerge-mode-map (kbd "M-p") 'smerge-prev)

(define-key smerge-mode-map (kbd "C-c l") 'smerge-keep-lower)

(define-key smerge-mode-map (kbd "C-c u") 'smerge-keep-upper)

(define-key smerge-mode-map (kbd "C-c n") 'smerge-keep-newer)

(define-key smerge-mode-map (kbd "C-c o") 'smerge-keep-older)

(provide '05-code-000-vc-smerge-mode)

(when
    (not load-file-name)
  (message "05-code-000-vc-smerge-mode.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))
