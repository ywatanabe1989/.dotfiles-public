;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2026-01-28 16:16:17>
;;; File: /home/ywatanabe/.dotfiles/src/.emacs.d/inits/90-mine-000-emacs-packages.el

;;; Copyright (C) 2026 Yusuke Watanabe (ywatanabe@scitex.ai)


;; Unload packages for reloading
(when (featurep 'emacs-tab-manager)
  (unload-feature 'emacs-tab-manager t))
(when (featurep 'genai)
  (unload-feature 'genai t))
(when (featurep 'elisp-test)
  (unload-feature 'elisp-test t))
(when (featurep 'emacs-buffer-navigation)
  (unload-feature 'emacs-buffer-navigation t))
(when (featurep 'emacs-claude-code)
  (unload-feature 'emacs-claude-code t))
(when (featurep 'emacs-message)
  (unload-feature 'emacs-message t))
(when (featurep 'emacs-monitor-repository)
  (unload-feature 'emacs-monitor-repository t))
(when (featurep 'emacs-recentf-project)
  (unload-feature 'emacs-recentf-project t))
(when (featurep 'emacs-gif-screencast)
  (unload-feature 'emacs-gif-screencast t))
(when (featurep 'whisper-live)
  (unload-feature 'whisper-live t))
(when (featurep 'python-import-manager)
  (unload-feature 'python-import-manager t))
(when (featurep 'esl)
  (unload-feature 'esl t))
(when (featurep 'emacs-header-footer-manager)
  (unload-feature 'emacs-header-footer-manager t))
(when (featurep 'epc)
  (unload-feature 'epc t))
(when (featurep 'emacs-password-manager)
  (unload-feature 'emacs-password-manager t))

;; Emacs Tab Manager

(use-package emacs-tab-manager
  :ensure
  nil
  :load-path "~/.emacs.d/lisp/emacs-tab-manager"
  :init
  ;; Load saved layout files
  (let ((layout-dir (expand-file-name "src/etm-layout/saved-layouts"
                                      "~/.emacs.d/lisp/emacs-tab-manager")))
    (dolist
        (layout-file
         (directory-files layout-dir t "etm-open-.*\\.el$"))
      (load layout-file)))
  :custom
  (etm-vterm-init-commands '((1 . "cld") (2 . nil)))
  (etm-protected-buffers '("*GenAI*" "*mu4e-headers*" "*mu4e-main*"
                           "*Async Shell Command*"))
  :bind
  (("C-S-k" . etm-buffer-kill-or-bury)
   ("M-w" . #'etm-close)
   ("M-1" . #'etm-navigation-jump-to-1)
   ("M-2" . #'etm-navigation-jump-to-2)
   ("M-3" . #'etm-navigation-jump-to-3)
   ("M-4" . #'etm-navigation-jump-to-4)
   ("M-5" . #'etm-navigation-jump-to-5)
   ("M-6" . #'etm-navigation-jump-to-6)
   ("M-7" . #'etm-navigation-jump-to-7)
   ("M-8" . #'etm-navigation-jump-to-8)
   ("M-9" . #'etm-navigation-jump-to-9)

   ;; ("M-h" . etm-navigation-jump-by-buffer-type-home)
   ;; ("M-s" . etm-navigation-jump-by-buffer-type-semi-home)
   ("C-c 1" . 'etm-jump-to-home-1)
   ("C-c 2" . 'etm-jump-to-home-2)
   ("C-c 3" . 'etm-jump-to-home-3)
   ("C-c 4" . 'etm-jump-to-home-4)
   ("C-c 5" . 'etm-jump-to-home-5)
   ("C-c 6" . 'etm-jump-to-home-6)
   ("C-c 7" . 'etm-jump-to-home-7)
   ("C-c 8" . 'etm-jump-to-home-8)
   ("C-c 9" . 'etm-jump-to-home-9)))

;; Generative AI
;; ----------------------------------------

(use-package genai
  :ensure
  nil
  :load-path "~/.emacs.d/lisp/genai"
  :custom
  (genai-python-bin-path (expand-file-name "~/.venv/bin/python3"))
  (genai-python-script-path
   (expand-file-name "~/.emacs.d/lisp/genai/genai.py"))
  (genai-n-history "7")
  (genai-max-tokens "8192")
  (genai-temperature "1")
  (genai-template-mapping
   '(("pr" . "ProgrammingRelentlessly")
     ("p"  . "Programming")
     ("ps" . "ProgrammingSort")
     ("pt" . "ProgrammingTest")
     ("d"  . "DebugPrint")
     ("pp" . "Paraphrase")
     ("r"  . "Remember")
     ("stx" . "SciTeX")
     ("sa" . "SciWriteAbstract")
     ("si" . "SciWriteIntroduction")
     ("sm" . "SciWriteMethods")
     ("sd" . "SciWriteDiscussion")
     ("bp" . "BluePrint")
     ("gw" . "GrantWriting")))
  :config
  (setq genai-llm-provider (getenv "GENAI_PROVIDER")
        genai-engine (getenv "GENAI_ENGINE")
        genai-api-keys (getenv "GENAI_API_KEYS")
        genai-home-dir (getenv "EMACS_GENAI_DIR")
        genai-history-human-path
        (expand-file-name
	     "~/.emacs.d/lisp/genai/histories/history-human-secret.json")
        genai-history-human-readable-path
        (expand-file-name
	     "~/.emacs.d/lisp/genai/histories/history-human-readable-secret.md"))
  :bind
  ("C-M-g" . genai-on-region))

;; Elisp Test

(use-package elisp-test
  :ensure
  nil
  :load-path "~/.emacs.d/lisp/elisp-test"
  :bind
  (("C-c C-t" . et-test-run)
   ("C-M-t" . elisp-test-buffer)))

(defalias 'etr 'elisp-test-run)

;; Emacs Buffer Navigation

(use-package emacs-buffer-navigation
  :ensure
  nil
  :load-path "~/.emacs.d/lisp/emacs-buffer-navigation"
  :bind
  (("C-S-p" . emacs-buffer-navigation-previous)
   ("C-S-n" . emacs-buffer-navigation-next)
   ("C-S-l" . emacs-buffer-navigation-show-history)))

;; Emacs Claude Code

(use-package emacs-claude-code
  :ensure
  nil
  :load-path "~/.emacs.d/lisp/emacs-claude-code"
  :demand t
  ;; :bind
  ;; (("C-S-p" . emacs-buffer-navigation-previous)
  ;;  ("C-S-n" . emacs-buffer-navigation-next)
  ;;  ("C-S-l" . emacs-buffer-navigation-show-history))
  ;; :init
  ;; (ecc-setup-keymap)
  )

;; Emacs Message
;; ----------------------------------------

(use-package emacs-message
  :ensure
  nil
  :load-path "~/.emacs.d/lisp/emacs-message")

;; Emacs Monitor Repository

(use-package emacs-monitor-repository
  :ensure
  nil
  :load-path "~/.emacs.d/lisp/emacs-monitor-repository")

;; Emacs Recentf Project

(use-package emacs-recentf-project
  :ensure
  nil
  :load-path "~/.emacs.d/lisp/emacs-recentf-project"
  :bind
  ("C-c C-r" . emacs-recentf-project-dispatch))

;; Emacs GIF Screencast

(use-package emacs-gif-screencast
  :ensure
  nil
  :load-path "~/.emacs.d/lisp/emacs-gif-screencast"
  :config
  (setq emacs-gif-screencast-resolution "3840:2160")
  :bind
  ("<f8>" . emacs-gif-screencast))

;; Whisper Live
;; ----------------------------------------

(use-package whisper-live
  :ensure
  nil
  :load-path "/home/ywatanabe/.emacs.d/lisp/whisper-live"
  :config
  ;; === Whisper Model Settings ===
  (setq whisper-install-directory
        (expand-file-name "~/.emacs.d/.cache/")
        whisper-model "base"
        whisper-quantize "q5_0"
        whisper-language "en"
        whisper-use-threads 4)

  ;; === Audio Recording Settings ===
  (setq whisper-live-audio-device "default"
        whisper-live-chunk-duration 3
        whisper-live-input-gain 20
        whisper-live-audio-feedback nil)

  ;; === Chunk Numbering & Formatting (NEW!) ===
  (setq whisper-live-number-chunks t
        whisper-live-chunk-format "[%d] %s\n")

  ;; === Initial Prompt (NEW! - Domain Vocabulary) ===
  ;; IMPORTANT: Use comma-separated keywords ONLY, NOT sentences!
  ;; Leave empty for general use (LLM conversations, documents)
  (setq whisper-live-initial-prompt "")

  ;; === UI/UX Settings (NEW!) ===
  (setq whisper-live-mode-line-indicator " 🎤LIVE")

  ;; === Transcription Mode ===
  ;; Options: 'independent (default), 'sliding-window, 'accumulative
  ;; - independent: Each chunk separately (fast, may miss context)
  ;; - sliding-window: Last N chunks concatenated (balanced)
  ;; - accumulative: ALL chunks concatenated (best accuracy, text diffing)
  ;; Try each mode and decide: M-x whisper-live-cycle-mode
  (setq whisper-live-transcription-mode 'accumulative)
  ;; For sliding-window: max chunks to keep (default 6 = ~18 sec with 3s chunks)
  ;; (setq whisper-live--max-chunks 6)
  ;; For accumulative: max duration before trimming (default 600 sec = 10 min)
  (setq whisper-live-accumulative-max-duration 600)

  ;; === LLM Cleanup Settings ===
  (setq whisper-live-start-tag-base "w"
        whisper-live-end-tag-base "w"
        whisper-live-anthropic-key (getenv "ANTHROPIC_API_KEY")
        whisper-live-anthropic-engine "claude-haiku-4-5-20251001"
        whisper-live-clean-with-llm nil
        whisper-live-llm-prompt
        "Clean up the following raw text transcribed from audio.

Since speech recognition is not perfect, could you understand the core messages and revise the sentences.

Fix minor errors to produce natural language output. As long as meaning is remained, you can revise as a English native speaker.

I often talk about computer terminologies so that I am quite welcome if you can estimate what I am saying.

Respond with only the corrected text and NEVER INCLUDE YOUR COMMENTS.

Now, the raw transcription is as follows: \n")

  :bind
  (("M-RET" . whisper-live-run)
   ("<escape>" . whisper-live-run)
   ("C-M-j" . whisper-live-run)))

;; === Whisper Live: What's New ===
;;
;; ✓ Better Model: large-v3-turbo (2-3x more accurate than base)
;; ✓ Chunk Numbering: Output appears as [1] text\n[2] text\n
;; ✓ VTerm Support: Text typed into terminal like keystrokes
;; ✓ Delta Detection: No more duplicate/repeated text
;; ✓ Mode Line: Shows 🎤LIVE when active
;; ✓ Robust Overlap: Handles Whisper rewording variations
;;
;; Usage: M-RET to start/stop, C-g for emergency stop
;; See: ~/.emacs.d/lisp/whisper-live/CONFIGURATION.MD

;; cd ~/.emacs.d/.cache/whisper.cpp
;; ./build/bin/quantize \
;;     models/ggml-large-v3-turbo.bin \
;;     models/ggml-large-v3-turbo-q5_0.bin \
;;     q5_0

;; cd ~/.emacs.d/.cache/whisper.cpp
;; ./build/bin/quantize \
;;     models/ggml-base.bin \
;;     models/ggml-base-q5_0.bin \
;;     q5_0

(use-package python-import-manager
  :ensure
  nil
  :load-path "/home/ywatanabe/.emacs.d/lisp/python-import-manager/"
  :config
  (pim-auto-mode t)
  (setq pim-python-path (expand-file-name "~/.venv/bin/python3")
        pim-flake8-path (expand-file-name "~/.venv/bin/flake8")
        pim-isort-path (expand-file-name "~/.venv/bin/isort")))

;; Emacs Slack

(use-package esl
  :ensure
  nil
  :load-path "~/.emacs.d/lisp/emacs-slack"
  :config
  (setq esl-user-token (getenv "SLACK_USER_TOKEN")))

;; Emacs Header Footer

(use-package emacs-header-footer-manager
  :ensure
  nil
  :load-path "/home/ywatanabe/.emacs.d/lisp/emacs-header-footer"
  :hook (before-save . ehf-update-header-and-footer)
  :bind (("C-c <delete>" . ehf-toggle-exclude-file))
  :config
  (add-to-list 'auto-mode-alist
               `(,(concat "\\."
                          (regexp-opt ehf-shell-extensions)
                          "\\'")
                 . sh-mode))
  (add-to-list 'auto-mode-alist
               `(,(concat "\\."
                          (regexp-opt ehf-source-extensions)
                          "\\'")
                 . sh-mode))
  :bind (:map dired-mode-map
              ("H" . ehf-dired-do-update-header-footer)))

;; Emacs Python Config

(use-package epc
  :ensure
  nil
  :load-path "/home/ywatanabe/.emacs.d/lisp/emacs-python-config/")

;; Emacs Password Manager

(use-package emacs-password-manager
  :ensure
  nil
  :load-path "/home/ywatanabe/.emacs.d/lisp/emacs-password-manager")

;; ;; LLEmacs

;; (use-package llemacs
;;   :ensure
;;   nil
;;   :load-path "~/proj/llemacs/llemacs.el"
;;   :config
;;   (setq lle-path-root "~/proj/llemacs")
;;   (setq lle-flag-debug-mode nil)
;;   (setq lle-flag-force-define-inner-recipe-variables-at-startup nil)
;;   (setq lle-flag-force-define-inner-recipe-functions-at-startup nil)
;;   (setq lle-flag-update-docs-at-startup t))


(provide '90-mine-000-emacs-packages)

(when
    (not load-file-name)
  (message "90-mine-000-emacs-packages.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))