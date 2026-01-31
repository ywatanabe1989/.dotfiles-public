;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-12-18 08:25:08>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/01-core-099-yank.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(setq select-enable-clipboard t)
(setq select-enable-primary nil)
(setq select-active-regions nil)
(setq save-interprogram-paste-before-kill t)
(setq x-selection-timeout 60000) ; 60 sec

(defcustom my/yank-diff-hide-delay 5
  "Seconds of idle time before hiding the *Yank Diff* buffer.
Set to nil or 0 to disable auto-hiding."
  :type '(choice (const :tag "Disable" nil) integer)
  :group 'editing)

(defvar my/yank-diff-hide-timer nil
  "Timer used to hide the *Yank Diff* buffer.")

(defun my--hide-yank-diff-buffer ()
  "Hide the *Yank Diff* buffer by killing it."
  (interactive)
  (let ((diff-buffer (get-buffer "*Yank Diff*")))
    (when (and diff-buffer (buffer-live-p diff-buffer))
      (kill-buffer diff-buffer)
      (message "*Yank Diff* buffer closed.")))
  ;; Timer has done its job or was cancelled, clear the variable
  (when (timerp my/yank-diff-hide-timer)
    (cancel-timer my/yank-diff-hide-timer)
    (setq my/yank-diff-hide-timer nil)))

(defun my--show-diff-in-buffer (original-text yanked-text)
  "Compare ORIGINAL-TEXT and YANKED-TEXT using diff and display in *Yank Diff*.
The diff buffer is read-only and can be closed with 'q'."
  (let ((diff-buffer-name "*Yank Diff*")
        (old-file (make-temp-file "yank-diff-old-"))
        (new-file (make-temp-file "yank-diff-new-"))
        diff-buffer)
    (unwind-protect
        (progn
          ;; Write texts to temporary files for diff command
          (with-temp-file old-file (insert original-text))
          (with-temp-file new-file (insert yanked-text))

          ;; Get or create the target diff buffer, ensure it's empty
          (setq diff-buffer (get-buffer-create diff-buffer-name))
          (with-current-buffer diff-buffer
            (let ((inhibit-read-only t))
                                        ; Allow modification temporarily
              (erase-buffer)
              ;; Call diff command
              (call-process shell-file-name nil t nil
                            shell-command-switch
                            (format "diff -u %s %s"
                                    (shell-quote-argument old-file)
                                    (shell-quote-argument new-file)))
              ;; Set up buffer properties
              (goto-char (point-min))
              (diff-mode)
              (setq buffer-read-only t) ; Make it read-only
              ;; Define a local keymap for 'q' to quit
              (let ((map (make-sparse-keymap)))
                (set-keymap-parent map diff-mode-map) ; Inherit diff-mode keys
                (define-key map (kbd "q") #'my--hide-yank-diff-buffer) ; Bind q
                (use-local-map map))
                                        ; Activate local map
              ))

          ;; Display the diff buffer
          (display-buffer diff-buffer '(display-buffer-pop-up-window))

          ;; Cancel any existing hide timer
          (when (timerp my/yank-diff-hide-timer)
            (cancel-timer my/yank-diff-hide-timer)
            (setq my/yank-diff-hide-timer nil))

          ;; Start a new timer to hide the buffer after idle delay, if delay is set
          (when
              (and (integerp my/yank-diff-hide-delay)
                   (> my/yank-diff-hide-delay 0))
            (setq my/yank-diff-hide-timer
                  (run-with-idle-timer my/yank-diff-hide-delay nil
                                       #'my--hide-yank-diff-buffer))))
      ;; Cleanup: Delete temporary files
      (when (file-exists-p old-file) (delete-file old-file))
      (when (file-exists-p new-file) (delete-file new-file)))))

(defun my/smart-yank (arg)
  "Yank text. If region is active, replace it and show diff if changed.
The diff buffer *Yank Diff* is read-only, closes with 'q',
and auto-hides after `my/yank-diff-hide-delay` idle seconds.
With prefix ARG, yank the ARG-th kill in the kill ring."
  (interactive "*P")

  (let ((region-is-active (region-active-p)))
    (if region-is-active
        ;; Region is active: capture, delete, yank, then show diff
        (let* ((orig-beg (region-beginning))
               (orig-end (region-end))
               (region-had-content (> orig-end orig-beg))
               (orig-text (if region-had-content
                              (buffer-substring-no-properties orig-beg
                                                              orig-end)
                            ""))
               yank-succeeded
               yanked-text)
          ;; Delete the region *before* yanking
          (when region-had-content
            (delete-region orig-beg orig-end))
          ;; Ensure point is at the start position for yank insertion
          (goto-char orig-beg)
          ;; Perform the yank operation
          (condition-case err
              (progn
                (yank arg) ; Call the original yank command
                (setq yanked-text (current-kill 0)) ; Get what was just yanked
                (setq yank-succeeded t))
            (user-error ; Catch "Kill ring is empty" etc.
             (message "%s" (error-message-string err))
             (setq yank-succeeded nil))
            (error ; Catch other potential errors during yank
             (message "Error during yank: %s"
                      (error-message-string err))
             (setq yank-succeeded nil)))

          ;; If yank happened and region originally had content, check if text changed
          (when (and yank-succeeded region-had-content)
            (let
                ((text-changed (not (string= orig-text yanked-text))))
              ;; Show diff only if the text actually changed
              (if text-changed
                  (progn
                    (my--show-diff-in-buffer orig-text yanked-text)
                    (message
                     "Region replaced. Diff shown in *Yank Diff*. Press 'q' in diff buffer to close."))
                (message
                 "Region content was identical to yanked text.")))))
      ;; Else: No active region, just perform the original yank
      (yank arg))))

;; Bind C-y to the new smart-yank function

(global-set-key (kbd "C-y") 'my/smart-yank)

;; Optional: Load message when file is loaded directly
(when (not load-file-name)
  (message
   "01-core-099-yank.el (smart-yank with auto-hiding diff) loaded and bound to C-y."))


(provide '01-core-099-yank)

(when
    (not load-file-name)
  (message "01-core-099-yank.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))