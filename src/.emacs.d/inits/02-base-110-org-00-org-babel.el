;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-08-26 07:09:18>
;;; File: /home/ywatanabe/.emacs.d/inits/02-base-110-org-00-org-babel.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; Configure org-babel for mermaid
(org-babel-do-load-languages
 'org-babel-load-languages
 '((mermaid . t)))

;; Set the exact path to mmdc
;; (setq ob-mermaid-cli-path "/usr/bin/mmdc")
(setq ob-mermaid-cli-path
      (string-trim (shell-command-to-string "which mmdc")))

;; Optional: set default theme and background
(setq ob-mermaid-cli-args
      '("--theme" "neutral" "--backgroundColor" "white"))

;; Then in your org file, use this syntax:

;; #+BEGIN_SRC mermaid :file diagrams/workflow.png
;; graph TD
;;     A[File Input] --> B{File Type Detection}
;;     B --> C[MarkdownChunker]
;;     B --> D[PythonChunker]
;;     style A fill:#e1f5fe
;;     style C fill:#c8e6c9
;; #+END_SRC

;; #+RESULTS:
;; [[file:diagrams/workflow.png]]

;; Usage:

;; 1. Put cursor in the mermaid block
;; 2. Press C-c C-c
;; 3. It generates the PNG and shows #+RESULTS: with the image link
;; 4. Use C-c C-x C-v to toggle inline image display


(provide '02-base-110-org-00-org-babel)

(when
    (not load-file-name)
  (message "02-base-110-org-00-org-babel.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))