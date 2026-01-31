;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-06-21 02:06:29>
;;; File: /home/ywatanabe/.emacs.d/inits/05-tool-999-pandoc.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun my/file-convert-format (input-file output-format)
  "Convert file to specified format using pandoc."
  (interactive "fSelect file: \nsOutput format: ")
  (let* ((pandoc-format (cond
                         ((string= output-format "md") "markdown")
                         ((string= output-format "tex") "latex")
                         ((string= output-format "txt") "plain")
                         (t output-format)))
         (output-file
          (concat (file-name-sans-extension input-file) "."
                  output-format))
         (command (format "pandoc %s -t %s -o %s"
                          (shell-quote-argument input-file)
                          (shell-quote-argument pandoc-format)
                          (shell-quote-argument output-file))))
    (shell-command command)
    (find-file output-file)
    (message "Converted to %s" output-file)))

(defun my/dired-convert-format ()
  "Convert selected files in dired to specified format."
  (interactive)
  (let ((files (dired-get-marked-files))
        (output-format (completing-read "Output format: "
                                        '("org" "md" "txt"
                                          "html"
                                          "pdf"
                                          "docx" "tex"))))
    (dolist (file files)
      (let* ((pandoc-format (cond
                             ((string= output-format "md") "markdown")
                             ((string= output-format "tex") "latex")
                             ((string= output-format "txt") "plain")
                             (t output-format)))
             (output-file
              (concat (file-name-sans-extension file) "."
                      output-format))
             (command (format "pandoc %s -t %s -o %s"
                              (shell-quote-argument file)
                              (shell-quote-argument pandoc-format)
                              (shell-quote-argument output-file))))
        (shell-command command)
        (message "Converted %s to %s" file output-file)))
    (revert-buffer)))

(global-set-key (kbd "C-c p") 'my/file-convert-format)

(define-key dired-mode-map (kbd "C-c p") 'my/dired-convert-format)


(provide '05-tool-999-pandoc)

(when
    (not load-file-name)
  (message "05-tool-999-pandoc.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))