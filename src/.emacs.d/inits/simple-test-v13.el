;;; Simple Test v13 - Find the culprit

;; Just redefine my/rg-search to catch what's calling it
(defun my/rg-search (&optional query)
  "CATCH: What is calling this old function?"
  (interactive)
  (message "=== CAUGHT OLD FUNCTION CALL ===")
  (message "BACKTRACE:")
  (let ((bt (with-output-to-string (backtrace))))
    (message "%s" bt))
  (error "OLD FUNCTION WAS CALLED - SEE BACKTRACE ABOVE"))

;; Simple working function
(defun my/test-search (query)
  "Simple test search."
  (interactive "sTest search: ")
  (message "Test search working: %s" query))

;; Bind it
(global-set-key (kbd "C-S-g") 'my/test-search)

(message "=== TEST v13: Press C-S-g to test ===")
(message "If old function is called, you'll see backtrace")