;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-10-07 00:42:51>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-vterm-01-mode.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

(defun --my/vterm-to-copy-mode ()
  "Switch to vterm copy mode and update keybindings."
  (interactive)
  (when (eq major-mode 'vterm-mode)
    (let ((inhibit-read-only t))
      (vterm-copy-mode 1)
      (--my/vterm-bind-keys)
      (message "Copy mode")
      (--my/vterm-update-mode-line))))

(defun --my/vterm-to-char-mode ()
  "Switch to vterm char mode and update keybindings."
  (interactive)
  (when (eq major-mode 'vterm-mode)
    (let ((inhibit-read-only t))
      (when (region-active-p)
        (deactivate-mark))
      (vterm-copy-mode -1)
      (--my/vterm-bind-keys)
      (message "Char mode")
      (--my/vterm-update-mode-line))))

(defun --my/vterm-toggle-mode ()
  "Toggle between vterm char mode and copy mode."
  (interactive)
  (if (eq major-mode 'vterm-mode)
      (let ((inhibit-read-only t))
        (if vterm-copy-mode
            (progn
              (message "Switching to char mode")
              (--my/vterm-to-char-mode))
          (message "Switching to copy mode")
          (--my/vterm-to-copy-mode)))
    (ignore)))

(defmacro --my/vterm-with-copy-mode (&rest body)
  "Execute BODY with vterm in copy mode, restoring the previous mode after.
Also temporarily sets inhibit-read-only to t for the duration."
  (declare (indent 0) (debug t))
  `(when (eq major-mode 'vterm-mode)
     (let ((was-in-copy-mode vterm-copy-mode)
           (inhibit-read-only t))
                                        ; Add inhibit-read-only binding
       (unless was-in-copy-mode
         (--my/vterm-to-copy-mode))
       (unwind-protect
           (progn ,@body)
         (unless was-in-copy-mode
           (--my/vterm-to-char-mode))))))

(defmacro --my/vterm-with-char-mode (&rest body)
  "Execute BODY with vterm in char mode, restoring the previous mode after.
Also temporarily sets inhibit-read-only to t for the duration."
  (declare (indent 0) (debug t))
  `(when (eq major-mode 'vterm-mode)
     (let ((was-in-copy-mode vterm-copy-mode)
           (inhibit-read-only t))
                                        ; Add inhibit-read-only binding
       (when was-in-copy-mode
         (--my/vterm-to-char-mode))
       (unwind-protect
           (progn ,@body)
         (when was-in-copy-mode
           (--my/vterm-to-copy-mode))))))

(defvar-local --my/vterm-mode-line-cookies nil
  "List of face remapping cookies for vterm mode line.")

(defun --my/vterm-update-mode-line ()
  "Update mode-line face based on vterm mode.
Handles multiple faces for Emacs 28+ and doom-modeline compatibility."
  (when (eq major-mode 'vterm-mode)
    ;; Remove all existing remappings
    (dolist (cookie --my/vterm-mode-line-cookies)
      (face-remap-remove-relative cookie))
    (setq --my/vterm-mode-line-cookies nil)
    ;; Apply new remappings when in copy mode
    (when vterm-copy-mode
      (let ((bg-color "darkgreen"))
        ;; Core mode-line faces (Emacs 28+)
        (push
	 (face-remap-add-relative 'mode-line :background bg-color)
         --my/vterm-mode-line-cookies)
        (when (facep 'mode-line-active)
          (push
	   (face-remap-add-relative 'mode-line-active :background
				    bg-color)
           --my/vterm-mode-line-cookies))
        ;; doom-modeline faces
        (when (facep 'doom-modeline-bar)
          (push
	   (face-remap-add-relative 'doom-modeline-bar :background
				    bg-color)
           --my/vterm-mode-line-cookies))
        (when (facep 'doom-modeline-buffer-modified)
          (push
	   (face-remap-add-relative 'doom-modeline-buffer-modified
				    :background bg-color)
           --my/vterm-mode-line-cookies))))
    ;; Force modeline redisplay
    (force-mode-line-update t)))

(add-hook 'vterm-mode-hook
          (lambda ()
            (let ((inhibit-read-only t))
              (add-hook 'post-command-hook
                        #'--my/vterm-update-mode-line
                        nil t))))

(provide '03-ui-000-vterm-01-mode)

(when
    (not load-file-name)
  (message "03-ui-000-vterm-01-mode.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))
