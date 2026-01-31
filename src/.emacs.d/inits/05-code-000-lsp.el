;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-02 10:33:49>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/05-code-000-lsp.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; (use-package lsp-mode
;;   :init
;;   (setq lsp-keymap-prefix "C-c l")
;;   :config
;;   (setq lsp-auto-guess-root t)
;;   (setq lsp-prefer-flymake nil)
;;   (setq lsp-warn-about-unsupported-messages nil)

;;   (setq lsp-bin-dir "/home/ywatanabe/.venv/bin/")
;;   (setq lsp-pylsp-server-command (concat lsp-bin-dir "pylsp"))
;;   (setq lsp-ruff-server-command (concat lsp-bin-dir "ruff"))
;;   (setq lsp-ruff-lsp-server-command (concat lsp-bin-dir "ruff-lsp"))
;;   (setq lsp-semgrep-server-command (list (concat lsp-bin-dir "semgrep") "lsp"))
;;   (setq lsp-pyright-server-command "/home/ywatanabe/.venv/bin/pyright-langserver")

;;   (setq lsp-auto-register-remote-clients nil)

;;   (setq lsp-pylsp-plugins-black-enabled t)
;;   (setq lsp-pylsp-plugins-isort-enabled t)
;;   (setq lsp-pylsp-plugins-flake8-enabled t)
;;   (setq lsp-pylsp-plugins-flake8-max-line-length 88)
;;   (setq lsp-pylsp-plugins-flake8-ignore ["E501" "E712" "E302" "W503" "E203" "E266" "W291" "E402" "E722" "F541" "W293"])

;;   (dolist (client '((pylsp-remote . lsp-pylsp-server-command)
;;                     (ruff-lsp-remote . lsp-ruff-lsp-server-command)
;;                     (ruff-remote . lsp-ruff-server-command)
;;                     (semgrep-remote . lsp-semgrep-server-command)
;;                     (pyright-remote . lsp-pyright-server-command)))
;;     (lsp-register-client
;;      (make-lsp-client :new-connection (lsp-tramp-connection (symbol-value (cdr client)))
;;                       :major-modes '(python-mode)
;;                       :remote? t
;;                       :server-id (car client))))

;;   :hook ((python-mode . lsp-deferred))
;;   :commands lsp)

;; (use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; (use-package dap-mode)
;; (use-package which-key :config (which-key-mode))

;; (use-package lsp-mode
;;   :init
;;   (setq lsp-keymap-prefix "C-c l")
;;   :config
;;   (setq lsp-auto-guess-root t)
;;   (setq lsp-prefer-flymake nil)  ; Disable Flymake
;;   (setq lsp-warn-about-unsupported-messages nil)

;;   (setq lsp-bin-dir "/home/ywatanabe/.venv/bin/")
;;   (setq lsp-pylsp-server-command (concat lsp-bin-dir "pylsp"))
;;   (setq lsp-ruff-server-command (concat lsp-bin-dir "ruff"))
;;   (setq lsp-ruff-lsp-server-command (concat lsp-bin-dir "ruff-lsp"))
;;   (setq lsp-semgrep-server-command (list (concat lsp-bin-dir "semgrep") "lsp"))
;;   (setq lsp-pyright-server-command "/home/ywatanabe/.venv/bin/pyright-langserver")

;;   (setq lsp-auto-register-remote-clients nil)

;;   (setq lsp-pylsp-plugins-black-enabled t)
;;   (setq lsp-pylsp-plugins-isort-enabled t)
;;   (setq lsp-pylsp-plugins-flake8-enabled t)
;;   (setq lsp-pylsp-plugins-flake8-max-line-length 88)  ; Adjust as needed
;;   (setq lsp-pylsp-plugins-flake8-ignore ["E501" "E712" "E302" "W503" "E203" "E266" "W291" "E402" "E722" "F541" "W293"])

;;   (lsp-register-client
;;    (make-lsp-client :new-connection (lsp-tramp-connection lsp-pylsp-server-command)
;;                     :major-modes '(python-mode)
;;                     :remote? t
;;                     :server-id 'pylsp-remote))

;;   (lsp-register-client
;;    (make-lsp-client :new-connection (lsp-tramp-connection lsp-ruff-lsp-server-command)
;;                     :major-modes '(python-mode)
;;                     :remote? t
;;                     :server-id 'ruff-lsp-remote))

;;   (lsp-register-client
;;    (make-lsp-client :new-connection (lsp-tramp-connection lsp-ruff-server-command)
;;                     :major-modes '(python-mode)
;;                     :remote? t
;;                     :server-id 'ruff-remote))

;;   (lsp-register-client
;;    (make-lsp-client :new-connection (lsp-tramp-connection lsp-semgrep-server-command)
;;                     :major-modes '(python-mode)
;;                     :remote? t
;;                     :server-id 'semgrep-remote))

;;   (lsp-register-client
;;    (make-lsp-client :new-connection (lsp-tramp-connection lsp-pyright-server-command)
;;                     :major-modes '(python-mode)
;;                     :remote? t
;;                     :server-id 'pyright-remote))

;;   :hook
;;   ((python-mode . lsp-deferred)
;;    )
;;   :commands lsp)

;; ;; (use-package lsp-ui
;; ;;   :ensure t
;; ;;   :after lsp-mode
;; ;;   :config
;; ;;   (setq lsp-ui-doc-enable t)
;; ;;   (setq lsp-ui-doc-show-with-cursor t))

;; ;; optionally
;; ;; (use-package lsp-ui :commands lsp-ui-mode)
;; ;; if you are helm user
;; (use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; ;; ;; if you are ivy user
;; ;; (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;; ;; (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; ;; optionally if you want to use debugger
;; (use-package dap-mode)
;; ;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; ;; optional if you want which-key integration
;; (use-package which-key
;;     :config
;;     (which-key-mode))

;; ;; (use-package lsp-mode
;; ;;   :init
;; ;;   (setq lsp-keymap-prefix "C-c l")
;; ;;   :config
;; ;;   (setq lsp-auto-guess-root t)
;; ;;   (setq lsp-prefer-flymake nil)  ; Disable Flymake
;; ;;   (setq lsp-warn-about-unsupported-messages nil)

;; ;;   (setq lsp-bin-dir "/home/ywatanabe/.venv/bin/")
;; ;;   (setq lsp-pylsp-server-command (concat lsp-bin-dir "pylsp"))
;; ;;   (setq lsp-ruff-server-command (concat lsp-bin-dir "ruff"))
;; ;;   (setq lsp-ruff-lsp-server-command (concat lsp-bin-dir "ruff-lsp"))
;; ;;   (setq lsp-semgrep-server-command (list (concat lsp-bin-dir "semgrep") "lsp"))
;; ;;   (setq lsp-pyright-server-command "/home/ywatanabe/.venv/bin/pyright-langserver")

;; ;;   (setq lsp-auto-register-remote-clients nil)

;; ;;   (setq lsp-pylsp-plugins-black-enabled t)
;; ;;   (setq lsp-pylsp-plugins-isort-enabled t)
;; ;;   (setq lsp-pylsp-plugins-flake8-enabled t)
;; ;;   (setq lsp-pylsp-plugins-flake8-max-line-length 88)  ; Adjust as needed
;; ;;   (setq lsp-pylsp-plugins-flake8-ignore ["E501" "E712" "E302" "W503" "E203" "E266" "W291" "E402" "E722" "F541" "W293"])

;; ;;   (lsp-register-client
;; ;;    (make-lsp-client :new-connection (lsp-tramp-connection lsp-pylsp-server-command)
;; ;;                     :major-modes '(python-mode)
;; ;;                     :remote? t
;; ;;                     :server-id 'pylsp-remote))

;; ;;   (lsp-register-client
;; ;;    (make-lsp-client :new-connection (lsp-tramp-connection lsp-ruff-lsp-server-command)
;; ;;                     :major-modes '(python-mode)
;; ;;                     :remote? t
;; ;;                     :server-id 'ruff-lsp-remote))

;; ;;   (lsp-register-client
;; ;;    (make-lsp-client :new-connection (lsp-tramp-connection lsp-ruff-server-command)
;; ;;                     :major-modes '(python-mode)
;; ;;                     :remote? t
;; ;;                     :server-id 'ruff-remote))

;; ;;   (lsp-register-client
;; ;;    (make-lsp-client :new-connection (lsp-tramp-connection lsp-semgrep-server-command)
;; ;;                     :major-modes '(python-mode)
;; ;;                     :remote? t
;; ;;                     :server-id 'semgrep-remote))

;; ;;   (lsp-register-client
;; ;;    (make-lsp-client :new-connection (lsp-tramp-connection lsp-pyright-server-command)
;; ;;                     :major-modes '(python-mode)
;; ;;                     :remote? t
;; ;;                     :server-id 'pyright-remote))

;; ;;   :hook
;; ;;   ((python-mode . lsp-deferred)
;; ;;    )
;; ;;   :commands lsp)

;; ;; ;; (use-package lsp-ui
;; ;; ;;   :ensure t
;; ;; ;;   :after lsp-mode
;; ;; ;;   :config
;; ;; ;;   (setq lsp-ui-doc-enable t)
;; ;; ;;   (setq lsp-ui-doc-show-with-cursor t))

;; ;; ;; optionally
;; ;; ;; (use-package lsp-ui :commands lsp-ui-mode)
;; ;; ;; if you are helm user
;; ;; (use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; ;; ;; ;; if you are ivy user
;; ;; ;; (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;; ;; ;; (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; ;; ;; optionally if you want to use debugger
;; ;; (use-package dap-mode)
;; ;; ;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; ;; ;; optional if you want which-key integration
;; ;; (use-package which-key
;; ;;     :config
;; ;;     (which-key-mode))

;; ;; (setq jedi:environment-root "jedi")
;; ;; (setq jedi:environment-virtualenv
;; ;;       (append python-environment-virtualenv
;; ;;               '("--python" "/home/ywatanabe/.venv/bin/python3")))


(provide '05-code-000-lsp)

(when
    (not load-file-name)
  (message "05-code-000-lsp.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))