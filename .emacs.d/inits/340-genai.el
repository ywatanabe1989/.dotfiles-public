(add-to-list 'load-path (getenv "EMACS_GENAI_DIR"))

(require 'genai)

;; Model
(setq genai-api-key (getenv "CLAUDE_API_KEY"))
(setq genai-engine "claude-3-5-sonnet-20240620")

;; (setq genai-api-key (getenv "OPENAI_API_KEY"))
;; (setq genai-engine "gpt-4")

;; (setq genai-api-key (getenv "GOOGLE_API_KEY"))
;; (setq genai-engine "gemini-1.5-pro-latest")

;; PATH
(setq genai-home-dir "/home/ywatanabe/.emacs.d/lisp/genai/")
(setq genai-python-bin-path (concat (getenv "HOME") "/env-3.11/bin/python"))
(setq genai-python-script-path (concat (getenv "EMACS_GENAI_DIR") "genai.py"))
(setq genai-history-path (concat (getenv "EMACS_GENAI_DIR") "history-secret.json"))
(setq genai-n-history "5")
(setq genai-max-tokens "2000")
(setq genai-temperature "0")

;; Key Bindings
(define-key global-map (kbd "C-M-g") 'genai-on-region)



;; (use-package genai
;;   :bind (("C-M-g" . genai-on-region)
;;          :map genai-mode-map
;;          ("C-S-I" . genai-mode-prefix-map))
;;   :config
;;   (define-prefix-command 'my/genai-mode-prefix-map)
;;   (define-key my/genai-mode-prefix-map (kbd "r") 'genai-on-region)
;;   (define-key my/genai-mode-prefix-map (kbd "h") 'genai-show-history)
;;   (define-key my/genai-mode-prefix-map (kbd "q") 'genai-stop-python-process))

(message "340-genai.el was loaded.")
