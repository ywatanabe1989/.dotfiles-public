;; -*- lexical-binding: t -*-

(add-to-list 'load-path "/home/ywatanabe/.emacs.d/lisp/auctex-13.2.3")
(load "auctex.el" nil t t)
(latex-preview-pane-enable)


(defun my/latex-count-words-in-region (start end)
  "Count words in the current region using TeXcount."
  (interactive "r")
  (let ((tempfile (make-temp-file "texcount")))
    (write-region start end tempfile)
    (shell-command-on-region start end (concat "texcount " tempfile) nil t)
    (delete-file tempfile)))

(defun my/latex-compile-sh ()
  "Run or create and run the compile.sh script to compile LaTeX project."
  (interactive)
  (unless (file-exists-p "./compile.sh")
    (with-temp-file "./compile.sh"
      (insert "#!/bin/bash\n\n"
              "pdflatex main\n"
              "bibtex main\n"
              "pdflatex main\n"
              "pdflatex main\n"))
    (set-file-modes "./compile.sh" #o755)
    (message "compile.sh created.")
    )
  (message "Compiling with compile.sh...")
  (let ((process (start-process "latex-compilation" "*latex-compilation-output*" "sh" "-c" "./compile.sh")))
    (set-process-sentinel
     process
     (lambda (process event)
       (when (string-match "finished\\|exited" event)
         (message "Compilation finished.")
         (latex-preview-pane-mode)
         (dolist (buffer (buffer-list))
           (with-current-buffer buffer
             (when (eq major-mode 'doc-view-mode)
               (doc-view-revert-buffer nil t t))))))))
  (latex-preview-pane-mode)  
  )



(define-key latex-mode-map (kbd "C-c p") 'latex-preview-pane-mode)
(define-key latex-mode-map (kbd "C-c c") 'my/latex-compile-sh)


;; (global-set-key (kbd "C-S-p") 'my/compile_latex)



;; including references
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

;; Enable PDF mode by default
(setq TeX-PDF-mode t)

;; To integrate with RefTeX for bibliography management
;; (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;; (setq reftex-plug-into-AUCTeX t)

;; (defun my/latex-compile-tex-and-bib ()
;;   (interactive)
;;   (shell-command "pdflatex main")
;;   (shell-command "bibtex main")
;;   (shell-command "pdflatex main")
;;   (shell-command "pdflatex main"))

;; (defun my/latex-preview-pane-mode ()
;;   (interactive)
;;   (my/compile-tex-and-bib)
;;   (latex-preview-pane-mode))

;; (defun my/latex-compile-sh ()
;;   (interactive)
;;   (message "compiling")
;;   (let ((process (start-process "latex-compilation" "*latex-compilation-output*" "sh" "-c" "./compile.sh")))
;;     (set-process-sentinel process (lambda (process event)
;;                                     (when (string-match "finished\\|exited" event) ; [REVISED]
;;                                       (message "finished")
;;                                       (dolist (buffer (buffer-list)) ; [REVISED]
;;                                         (with-current-buffer buffer ; [REVISED]
;;                                           (when (eq major-mode 'doc-view-mode) ; [REVISED]
;;                                             (doc-view-revert-buffer nil t))))))))) ; [REVISED]


;; (defun my/latex-compile-sh ()
;;   "Run the compile.sh script to compile LaTeX project."
;;   (interactive)
;;   (if (file-exists-p "./compile.sh")
;;       (progn
;;         (message "Compiling with compile.sh...")
;;         (let ((process (start-process "latex-compilation" "*latex-compilation-output*" "sh" "-c" "./compile.sh")))
;;           (set-process-sentinel
;;            process
;;            (lambda (process event)
;;              (when (string-match "finished\\|exited" event)
;;                (message "Compilation finished.")
;;                (dolist (buffer (buffer-list))
;;                  (with-current-buffer buffer
;;                    (when (eq major-mode 'doc-view-mode)
;;                      (doc-view-revert-buffer nil t t)))))))))
;;     (message "Error: compile.sh not found!")))


;; #!/bin/bash

;; pdflatex main
;; bibtex main
;; pdflatex main
;; pdflatex main"

;; # EOF
