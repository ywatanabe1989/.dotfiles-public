;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-10 09:11:14>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/init.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(when
    (fboundp 'llemacs--buffer-logging)
  (fmakunbound 'llemacs--buffer-logging))

;; Clean load-path of unwanted directories

(setq load-path
      (cl-remove-if
       (lambda
         (path)
         (and
          (stringp path)
          (string-match-p "shared_emacsd" path)))
       load-path))

;; Clean native-comp-eln-load-path if using native compilation

(when
    (boundp 'native-comp-eln-load-path)
  (setq native-comp-eln-load-path
        (cl-remove-if
         (lambda
           (path)
           (and
            (stringp path)
            (string-match-p "shared_emacsd" path)))
         native-comp-eln-load-path)))

;; Force clean package directory

(require 'package)

(setq package-user-dir
      (replace-regexp-in-string
       "/shared_emacsd/" "/.emacs.d/"
       package-user-dir))

;; Suppress warnings

(setq warning-minimum-level :error)

(setq native-comp-async-report-warnings-errors nil)

(setq byte-compile-warnings
      '(not obsolete))

(setq warning-suppress-log-types
      '((comp)
        (bytecomp)))

(setq warning-suppress-types
      '((comp)
        (bytecomp)))

;; (defun my/load-dir (dir)
;;   "Load .el files in DIR in numerical order. Stop and show error in split window."
;;   (let* ((el-files (directory-files dir t "^[0-9].*\\.el$"))
;;          (sorted-files (sort el-files #'string<))
;;          (excluded-patterns '("safe_emacs.d")))
;;     (catch 'error-occurred
;;       (dolist (file sorted-files)
;;         (when (and (file-regular-p file)
;;                    (string-match "\\.el$" file)
;;                    (not (cl-some (lambda (pattern)
;;                                    (string-match-p pattern file))
;;                                  excluded-patterns)))
;;           (condition-case err
;;               (load file nil t)
;;             (error
;;              (delete-other-windows)
;;              (find-file-other-window file)
;;              (with-current-buffer (get-buffer-create "*Error*")
;;                (insert (format "Error loading %s:\n%s"
;;                                file
;;                                (error-message-string err)))
;;                (display-buffer (current-buffer)))
;;              (throw 'error-occurred t))))))))

(defun my/load-dir
    (dir)
  "Load .el files in DIR in numerical order. Show file on left, error on right."
  (let*
      ((el-files
        (directory-files dir t "^[0-9].*\\.el$"))
       (sorted-files
        (sort el-files #'string<))
       (excluded-patterns
        '("safe_emacs.d")))
    (catch 'error-occurred
      (dolist
          (file sorted-files)
        (when
            (and
             (file-regular-p file)
             (string-match "\\.el$" file)
             (not
              (cl-some
               (lambda
                 (pattern)
                 (string-match-p pattern file))
               excluded-patterns)))
          (condition-case err
              (load file nil t)
            (error
             (delete-other-windows)
             (find-file file)
             (split-window-right)
             (with-current-buffer
                 (get-buffer-create "*Error*")
               (erase-buffer)
               (insert
                (format "Error loading %s:\n%s"
                        file
                        (error-message-string err))))
             (display-buffer "*Error*"
                             '(display-buffer-reuse-window
                               (reusable-frames . visible)
                               (side . right)))
             (throw 'error-occurred t))))))))

;; Load all configuration files

(my/load-dir "~/.emacs.d/inits")

;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(LaTeX-electric-left-right-brace t)
;;  '(Man-notify-method 'aggressive t)
;;  '(TeX-auto-save t)
;;  '(TeX-electric-math '("$" . "$"))
;;  '(TeX-electric-sub-and-superscript t)
;;  '(TeX-parse-self t)
;;  '(bookmark-save-flag 1)
;;  '(completion-category-overrides '((file (styles partial-completion))) nil nil "Customized with use-package orderless")
;;  '(completion-cycle-threshold 3)
;;  '(completion-styles '(orderless basic) nil nil "Customized with use-package orderless")
;;  '(completions-detailed t)
;;  '(dired-auto-revert-buffer t)
;;  '(dired-dwim-target t)
;;  '(ediff-window-setup-function 'ediff-setup-windows-plain t)
;;  '(eglot-autoshutdown t t)
;;  '(eshell-scroll-to-bottom-on-input 'this t)
;;  '(etm-protected-buffers
;;    '("*GenAI*" "*mu4e-headers*" "*mu4e-main*" "*Async Shell Command*"))
;;  '(fancy-splash-image
;;    "/home/ywatanabe/.emacs.d/crafted-emacs/system-crafters-logo.png")
;;  '(fast-but-imprecise-scrolling t)
;;  '(global-auto-revert-non-file-buffers t)
;;  '(ibuffer-movement-cycle nil)
;;  '(ibuffer-old-time 24)
;;  '(kill-do-not-save-duplicates t)
;;  '(load-prefer-newer t t)
;;  '(markdown-enable-html t)
;;  '(markdown-enable-math t)
;;  '(org-hide-emphasis-markers t)
;;  '(org-link-descriptive t)
;;  '(org-mouse-1-follows-link t)
;;  '(org-return-follows-link t)
;;  '(package-archive-priorities
;;    '(("gnu" . 99) ("nongnu" . 80) ("stable" . 70) ("melpa" . 0)))
;;  '(package-selected-packages nil)
;;  '(reftex-plug-into-AUCTeX t t)
;;  '(scheme-program-name "guile" t)
;;  '(scroll-conservatively 101)
;;  '(scroll-margin 0)
;;  '(scroll-preserve-screen-position t)
;;  '(speedbar-frame-parameters
;;    '((name . "speedbar") (title . "speedbar") (minibuffer)
;;      (border-width . 2) (menu-bar-lines . 0) (tool-bar-lines . 0)
;;      (unsplittable . t) (left-fringe . 10)))
;;  '(speedbar-update-flag t)
;;  '(speedbar-use-images nil)
;;  '(switch-to-buffer-in-dedicated-window 'pop)
;;  '(switch-to-buffer-obey-display-actions t)
;;  '(tab-always-indent 'complete)
;;  '(tabspaces-mode t t)
;;  '(tramp-default-remote-shell "/bin/bash" t)
;;  '(tramp-default-user nil)
;;  '(tramp-encoding-shell "/usr/bin/bash")
;;  '(xref-show-definitions-function 'xref-show-definitions-completing-read))

;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(doom-modeline-face ((t :inherit default :background nil :foreground nil)))
;;  '(magit-diff-added ((t (:background "#335533" :foreground "#ddffdd"))))
;;  '(magit-diff-added-highlight ((t (:background "#336633" :foreground "#eeffee"))))
;;  '(magit-diff-hunk-heading ((t (:background "#444444" :foreground "#999999"))))
;;  '(magit-diff-hunk-heading-highlight ((t (:background "#555555" :foreground "#aaaaaa"))))
;;  '(magit-diff-removed ((t (:background "#553333" :foreground "#ffdddd"))))
;;  '(magit-diff-removed-highlight ((t (:background "#663333" :foreground "#ffeeff"))))
;;  '(markdown-code-face ((t (:background "gray26"))))
;;  '(paren-face-match ((t (:background "maroon3" :foreground "white" :weight normal))))
;;  '(paren-face-mismatch ((t (:background "red" :foreground "white"))))
;;  '(paren-face-no-match ((t (:background "yellow" :foreground "black"))))
;;  '(show-paren-match ((t (:background "maroon3" :foreground "white" :weight normal))))
;;  '(tab-bar ((t (:background "gray20" :foreground "white"))))
;;  '(tab-bar-tab ((t (:inherit tab-bar :background "dark green" :foreground "gray 60"))))
;;  '(tab-bar-tab-inactive ((t (:inherit tab-bar :background "gray20" :foreground "gray80"))))
;;  '(term-color-black ((t (:foreground "#3F3F3F" :background "#2B2B2B"))))
;;  '(term-color-blue ((t (:foreground "#8CD0D3" :background "#4F7F7F"))))
;;  '(term-color-cyan ((t (:foreground "#93E0E3" :background "#4F7F7F"))))
;;  '(term-color-green ((t (:foreground "#7F9F7F" :background "#3F5F3F"))))
;;  '(term-color-magenta ((t (:foreground "#DC8CC3" :background "#7F4F7F"))))
;;  '(term-color-red ((t (:foreground "#CC9393" :background "#7C3F3F"))))
;;  '(term-color-white ((t (:foreground "#DCDCCC" :background "#656555"))))
;;  '(term-color-yellow ((t (:foreground "#F0DFAF" :background "#7F7F4F"))))
;;  '(term-default-bg-color ((t (:inherit term-color-black))))
;;  '(term-default-fg-color ((t (:inherit term-color-white)))))

;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(ehf-exclude-files
;;    '("/ssh:ywatanabe@sp:/home/ywatanabe/proj/mngs_repo/tests/update_test_structure.sh"
;;      "/ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/calc_pac_around_seizures.py"
;;      "/ssh:sp:/home/ywatanabe/proj/neurovista/scripts/eda/plot_seizure_aligned_signals_sbatch.sh"
;;      "/ssh:sp:/home/ywatanabe/proj/neurovista/scripts/pac/_visualize_pac_sbatch.sh"
;;      "/ssh:sp:/home/ywatanabe/proj/neurovista/scripts/eda/plot_seizure_aligned_signals.sh"
;;      "/ssh:sp:/home/ywatanabe/proj/neurovista/scripts/eda/plot_seizure_aligned_signals.py"
;;      "/ssh:sp:/home/ywatanabe/proj/neurovista/scripts/dataset/convert_mat_files_to_hdf5.sh"
;;      "/ssh:sp:/home/ywatanabe/proj/neurovista/scripts/dataset/concatenate_mat_files.sh"
;;      "/ssh:sp:/home/ywatanabe/proj/llemacs/apptainer/build/04_python.sh"
;;      "/ssh:sp:/home/ywatanabe/proj/llemacs/apptainer/build/03_emacs.sh"
;;      "/ssh:sp:/home/ywatanabe/proj/llemacs/apptainer/build/02_set_languages.sh"
;;      "/ssh:sp:/home/ywatanabe/proj/llemacs/apptainer/llemacs.def"
;;      "/ssh:sp:/home/ywatanabe/proj/llemacs/apptainer/build/01_apt_packages.sh"))
;;  '(etm-startup-layouts-list '("mngs"))
;;  '(package-selected-packages
;;    '(aggressive-indent all-the-icons-ibuffer ample-regexps auctex
;;                        auth-source-xoauth2 balanced-windows blacken
;;                        circe color-moccur command-log-mode
;;                        company-jedi consult corfu crdt csharp-mode
;;                        csv-mode dap-mode diff-hl dired-k diredfl direx
;;                        doom-modeline doom-themes dracula-theme
;;                        elisp-lint emacsql emojify ez-query-replace flx
;;                        flycheck-pos-tip flycheck-posframe flymake-json
;;                        gif-screencast git-commit helm-flycheck
;;                        helm-flymake helm-flyspell helm-lsp hide-lines
;;                        highlight-indent-guides highlight-parentheses
;;                        image-dired+ init-loader latex-preview-pane
;;                        lsp-ivy lsp-pyright lsp-ui magit marginalia
;;                        mermaid-mode mic-paren mini-frame mmm-mode mozc
;;                        mu4e-alert multi-term nerd-icons-ibuffer oauth
;;                        oauth2 oauth2-auto ob-mermaid orderless
;;                        org-download org-inline-anim org-modern
;;                        org-tree-slide pdf-tools persistent-soft
;;                        persp-mode popup popwin projectile pyimport
;;                        python-black python-isort queue rg stream
;;                        swiper tempel tree-sitter ts typescript-mode
;;                        undo-tree undohist url-http-oauth use-package
;;                        vba-sense vbasense vertico vimish-fold
;;                        visual-regexp-steroids vterm w3m web web-mode
;;                        web-server websocket which-key xwidgets-reuse
;;                        yaml-mode yasnippet zenburn-theme)))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(doom-modeline-face
;;    ((t :inherit default :background nil :foreground nil)))
;;  '(magit-diff-added
;;    ((t (:background "#335533" :foreground "#ddffdd"))))
;;  '(magit-diff-added-highlight
;;    ((t (:background "#336633" :foreground "#eeffee"))))
;;  '(magit-diff-hunk-heading
;;    ((t (:background "#444444" :foreground "#999999"))))
;;  '(magit-diff-hunk-heading-highlight
;;    ((t (:background "#555555" :foreground "#aaaaaa"))))
;;  '(magit-diff-removed
;;    ((t (:background "#553333" :foreground "#ffdddd"))))
;;  '(magit-diff-removed-highlight
;;    ((t (:background "#663333" :foreground "#ffeeff"))))
;;  '(markdown-code-face ((t (:background "gray26"))))
;;  '(paren-face-match
;;    ((t (:background "maroon3" :foreground "white" :weight normal))))
;;  '(paren-face-mismatch ((t (:background "red" :foreground "white"))))
;;  '(paren-face-no-match
;;    ((t (:background "yellow" :foreground "black"))))
;;  '(show-paren-match
;;    ((t (:background "maroon3" :foreground "white" :weight normal))))
;;  '(tab-bar ((t (:background "gray20" :foreground "white"))))
;;  '(tab-bar-tab
;;    ((t
;;      (:inherit tab-bar :background "dark green" :foreground "gray60"))))
;;  '(tab-bar-tab-inactive
;;    ((t (:inherit tab-bar :background "gray20" :foreground "gray80"))))
;;  '(term-color-black
;;    ((t (:foreground "#3F3F3F" :background "#2B2B2B"))))
;;  '(term-color-blue ((t (:foreground "#8CD0D3" :background "#4F7F7F"))))
;;  '(term-color-cyan ((t (:foreground "#93E0E3" :background "#4F7F7F"))))
;;  '(term-color-green
;;    ((t (:foreground "#7F9F7F" :background "#3F5F3F"))))
;;  '(term-color-magenta
;;    ((t (:foreground "#DC8CC3" :background "#7F4F7F"))))
;;  '(term-color-red ((t (:foreground "#CC9393" :background "#7C3F3F"))))
;;  '(term-color-white
;;    ((t (:foreground "#DCDCCC" :background "#656555"))))
;;  '(term-color-yellow
;;    ((t (:foreground "#F0DFAF" :background "#7F7F4F"))))
;;  '(term-default-bg-color ((t (:inherit term-color-black))))
;;  '(term-default-fg-color ((t (:inherit term-color-white)))))

(put 'list-timers 'disabled nil)


(provide 'init)

(when
    (not load-file-name)
  (message "init.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))