;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-07 03:59:13>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-tool-000-mermaid.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(use-package mermaid-mode
  :ensure
  t)

(use-package ob-mermaid
  :ensure
  t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((mermaid . t)))

;; # 1. Node.js 18+ Setup
;; sudo apt-get remove nodejs libnode-dev
;; sudo apt-get autoremove
;; sudo apt-get install nodejs -y

;; # 2. Mermaid CLI & Dependencies
;; sudo npm install -g @mermaid-js/mermaid-cli
;; sudo apt-get install -y chromium-browser
;; sudo npm install -g puppeteer
;; npx puppeteer browsers install chrome-headless-shell

;; # 3. Test Setup
;; echo "graph TD; A-->B;" > /tmp/test.mmd
;; mmdc -i /tmp/test.mmd -o test.png

(defun my/mermaid-compile ()
  "Generate PNG, SVG, and GIF after saving Mermaid files."
  (interactive)
  (when (and (eq major-mode 'mermaid-mode)
             (buffer-file-name))
    (let* ((input-file (buffer-file-name))
           (base-name (file-name-sans-extension input-file)))
      (call-process "mmdc" nil nil nil
                    "-i" input-file
                    "-o" (concat base-name ".png")
                    "--backgroundColor" "transparent"
                    "-s 3")
      (call-process "mmdc" nil nil nil
                    "-i" input-file
                    "-o" (concat base-name ".svg")
                    "--backgroundColor" "transparent"
                    "-f" "svg")
      (call-process "convert" nil nil nil
                    (concat base-name ".png")
                    (concat base-name ".gif"))
      (message "Created %s.png, %s.svg and %s.gif" base-name base-name
               base-name))))

(defun my/mermaid-after-save-hook ()
  (my/mermaid-compile))

(use-package mermaid-mode
  :ensure
  t
  :custom
  (setq mermaid-output-format ".png")
  :hook
  (after-save . my/mermaid-after-save-hook))

(use-package ob-mermaid
  :ensure
  t
  :custom
  (ob-mermaid-cli-path "/usr/local/bin/mmdc")
  (ob-mermaid-extra-args "--backgroundColor transparent -f svg"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((mermaid . t)))

;; # 1. Node.js 18+ Setup
;; sudo apt-get remove nodejs libnode-dev
;; sudo apt-get autoremove
;; sudo apt-get install nodejs -y

;; # 2. Mermaid CLI & Dependencies
;; sudo npm install -g @mermaid-js/mermaid-cli
;; sudo apt-get install -y chromium-browser
;; sudo npm install -g puppeteer
;; npx puppeteer browsers install chrome-headless-shell

;; # 3. Test Setup
;; echo "graph TD; A-->B;" > /tmp/test.mmd
;; mmdc -i /tmp/test.mmd -o test.png


(provide '03-tool-000-mermaid)

(when
    (not load-file-name)
  (message "03-tool-000-mermaid.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))