;;; Interactive Test v14 - Comprehensive diagnostic

;; First, let's see what's currently bound to C-S-g
(message "=== INITIAL KEYBINDING CHECK ===")
(message "C-S-g currently bound to: %s" (key-binding (kbd "C-S-g")))

;; Check if old function exists
(message "my/rg-search exists: %s" (fboundp 'my/rg-search))
(message "my/rg-search commandp: %s" (and (fboundp 'my/rg-search) (commandp 'my/rg-search)))

;; Redefine old function with diagnostic
(defun my/rg-search (&optional query)
  "DIAGNOSTIC: Catch calls to old function"
  (interactive "P")
  (message "=== OLD FUNCTION CALLED ===")
  (message "Query argument: %s" query)
  (message "interactive-p: %s" (called-interactively-p 'any))
  (message "BACKTRACE:")
  (backtrace)
  (error "Stopped at old function call"))

;; Simple working replacement
(defun my/working-search-v14 (query)
  "Working search function v14"
  (interactive "sV14 Search: ")
  (message "=== SUCCESS: V14 function called ===")
  (message "Query: %s" query)
  (message "Directory: %s" default-directory)
  (let ((buffer (get-buffer-create "*v14-success*")))
    (with-current-buffer buffer
      (erase-buffer)
      (insert "V14 SUCCESS!\n")
      (insert "=============\n\n")
      (insert (format "Query: %s\n" query))
      (insert (format "Directory: %s\n" default-directory))
      (insert (format "Time: %s\n" (current-time-string))))
    (pop-to-buffer buffer)))

;; Check what happens when we try to bind
(message "=== SETTING NEW KEYBINDING ===")
(global-unset-key (kbd "C-S-g"))
(global-set-key (kbd "C-S-g") 'my/working-search-v14)
(message "After binding, C-S-g bound to: %s" (key-binding (kbd "C-S-g")))

;; Test the binding programmatically
(defun test-keybinding ()
  "Test what happens when we simulate the keybinding"
  (message "=== SIMULATING C-S-g KEYPRESS ===")
  (condition-case err
      (progn
        (message "Calling key-binding result directly...")
        (let ((cmd (key-binding (kbd "C-S-g"))))
          (message "Command to call: %s" cmd)
          (message "Is command: %s" (commandp cmd))
          (if (commandp cmd)
              (call-interactively cmd)
            (message "ERROR: Not a command!"))))
    (error (message "ERROR in test: %s" err))))

;; Run the test
(test-keybinding)

(message "=== V14 DIAGNOSTIC COMPLETE ===")
(provide 'interactive-test-v14)