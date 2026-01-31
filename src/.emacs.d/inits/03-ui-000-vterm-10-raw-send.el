;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-12-30 13:10:00>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-vterm-10-raw-send.el

;;; Commentary:
;; Raw keyboard send mode for vterm
;; Usage:
;;   1. M-x my/vterm-raw-send-start (or C-c r s)
;;   2. Type keys freely (C-g, S-RET, M-x, etc.)
;;   3. C-c C-c to send, C-c C-g to cancel

;;; Code:

(defvar my/vterm-raw-send--buffer nil
  "List of key events to send to vterm.")

(defvar my/vterm-raw-send--target-buffer nil
  "Target vterm buffer for raw send.")

(defvar my/vterm-raw-send--active nil
  "Whether raw send mode is active.")

(defvar my/vterm-raw-send-mode-map
  (let ((map (make-sparse-keymap)))
    ;; Control keys for the mode itself
    (define-key map (kbd "C-c C-c") #'my/vterm-raw-send-execute)
    (define-key map (kbd "C-c C-g") #'my/vterm-raw-send-cancel)
    (define-key map (kbd "C-c C-k") #'my/vterm-raw-send-clear)
    (define-key map (kbd "C-c C-v") #'my/vterm-raw-send-preview)
    map)
  "Keymap for vterm raw send mode.")

(define-minor-mode my/vterm-raw-send-mode
  "Minor mode for recording raw keyboard input to send to vterm."
  :lighter " VtermRaw"
  :keymap my/vterm-raw-send-mode-map
  (if my/vterm-raw-send-mode
      (progn
        (setq my/vterm-raw-send--active t)
        (add-hook 'pre-command-hook #'my/vterm-raw-send--capture-key
		  nil t)
        (message
	 "Raw send started. Type keys, then C-c C-c to send, C-c C-g to cancel"))
    (setq my/vterm-raw-send--active nil)
    (remove-hook 'pre-command-hook #'my/vterm-raw-send--capture-key t)))

(defun my/vterm-raw-send--capture-key ()
  "Capture the current key event."
  (when (and my/vterm-raw-send--active
             this-command
             (not (memq this-command
                        '(my/vterm-raw-send-execute
                          my/vterm-raw-send-cancel
                          my/vterm-raw-send-clear
                          my/vterm-raw-send-preview))))
    ;; Capture the key sequence
    (let ((keys (this-command-keys-vector)))
      (push (list :keys keys
                  :command this-command
                  :key-desc (key-description keys))
            my/vterm-raw-send--buffer))
    ;; Prevent the command from executing
    (setq this-command 'ignore)))

(defun my/vterm-raw-send-start ()
  "Start raw send mode for vterm."
  (interactive)
  (unless (derived-mode-p 'vterm-mode)
    (user-error "Not in a vterm buffer"))
  (setq my/vterm-raw-send--buffer nil)
  (setq my/vterm-raw-send--target-buffer (current-buffer))
  (my/vterm-raw-send-mode 1))

(defun my/vterm-raw-send-execute ()
  "Send all captured keys to vterm and exit raw send mode."
  (interactive)
  (let ((keys-to-send (nreverse my/vterm-raw-send--buffer))
        (target my/vterm-raw-send--target-buffer))
    (my/vterm-raw-send-mode -1)
    (setq my/vterm-raw-send--buffer nil)
    (when (and target (buffer-live-p target))
      (with-current-buffer target
        (dolist (key-info keys-to-send)
          (my/vterm-raw-send--send-key-event
	   (plist-get key-info :keys)))))
    (message "Sent %d key events to vterm" (length keys-to-send))))

(defun my/vterm-raw-send--send-key-event (keys)
  "Send KEYS vector to vterm."
  (let ((key (aref keys 0)))
    (cond
     ;; Handle special keys
     ((eq key 'return)
      (vterm-send-return))
     ((eq key 'tab)
      (vterm-send-key "<tab>"))
     ((eq key 'escape)
      (vterm-send-escape))
     ((eq key 'backspace)
      (vterm-send-backspace))
     ;; Handle control characters
     ((and (integerp key) (< key 32))
      (vterm-send-key (string (+ key 96)) nil nil t))
					; C-a = 1, etc.
     ;; Handle meta combinations
     ((and (integerp key) (> key 127) (< key 256))
      (vterm-send-key (string (- key 128)) nil t nil))
     ;; Handle shift-return (special case)
     ((eq key 'S-return)
      (vterm-send-string "\e[13;2u"))
					; Modern terminal escape
     ;; Handle regular characters
     ((integerp key)
      (vterm-send-string (string key)))
     ;; Handle function keys and others
     ((symbolp key)
      (let* ((key-name (symbol-name key))
             (shift (string-prefix-p "S-" key-name))
             (meta (string-prefix-p "M-" key-name))
             (ctrl (string-prefix-p "C-" key-name))
             (base-key (replace-regexp-in-string
                        "^[SMC]+-" "" key-name)))
        (vterm-send-key base-key shift meta ctrl))))))

(defun my/vterm-raw-send-cancel ()
  "Cancel raw send mode without sending."
  (interactive)
  (setq my/vterm-raw-send--buffer nil)
  (my/vterm-raw-send-mode -1)
  (message "Raw send cancelled"))

(defun my/vterm-raw-send-clear ()
  "Clear captured keys without exiting mode."
  (interactive)
  (setq my/vterm-raw-send--buffer nil)
  (message "Cleared %d captured keys"
	   (length my/vterm-raw-send--buffer)))

(defun my/vterm-raw-send-preview ()
  "Preview captured keys."
  (interactive)
  (let ((keys (nreverse (copy-sequence my/vterm-raw-send--buffer))))
    (if keys
        (message "Captured: %s"
                 (mapconcat (lambda (k) (plist-get k :key-desc))
                            keys " "))
      (message "No keys captured yet"))))

;; Convenience function for quick raw key sending

(defun my/vterm-send-raw-key (key &optional shift meta ctrl)
  "Send KEY to vterm with optional SHIFT, META, CTRL modifiers."
  (interactive "sKey: ")
  (when (derived-mode-p 'vterm-mode)
    (vterm-send-key key shift meta ctrl)))

;; Keybinding setup
(with-eval-after-load 'vterm
  (define-key vterm-mode-map (kbd "C-c r s") #'my/vterm-raw-send-start)
  (define-key vterm-mode-map (kbd "C-c r r") #'my/vterm-send-raw-key))

(provide '03-ui-000-vterm-10-raw-send)

(when (not load-file-name)
  (message "03-ui-000-vterm-10-raw-send.el loaded."))
