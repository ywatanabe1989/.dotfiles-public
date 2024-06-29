;; -*- lexical-binding: t -*-

(defvar key-chatter-delay 0.05
  "Number of seconds to wait before allowing the same key to register again.") ;; [REVISED]

(defvar key-chatter-last-time nil
  "Time of the last key press.") ;; [REVISED]

(defvar key-chatter-last-key nil
  "The last key that was pressed.") ;; [REVISED]

(defun key-chatter-filter ()
  "Filter out key chattering by introducing a delay between key presses." ;; [REVISED]
  (let ((time (float-time (current-time)))
        (key last-command-event))
    (if (and (eq key key-chatter-last-key)
             key-chatter-last-time ;; [REVISED]
             (< (- time key-chatter-last-time) key-chatter-delay))
        (setq this-command 'ignore) ;; [REVISED]
      (setq key-chatter-last-time time)
      (setq key-chatter-last-key key))))

(add-to-list 'post-self-insert-hook 'key-chatter-filter)

;; Keyboard
(global-unset-key (kbd "C-\\"))
(setq default-input-method nil)
(set-input-method nil)
