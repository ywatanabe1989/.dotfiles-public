;; -*- lexical-binding: t -*-

(use-package doom-modeline
  ;;;; Doom mode line
  ;; cd ~/Downloads
  ;; wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/NerdFontsSymbolsOnly.zip
  ;; unzip NerdFontsSymbolsOnly.zip -d NerdFontsSymbolsOnly
  ;; cd NerdFontsSymbolsOnly
  ;; cp *.ttf ~/.local/share/fonts
  ;; fc-cache -f -v
  ;; M-x all-the-icons-install-fonts
  ;; (all-the-icons-install-fonts)
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-buffer-file-name-style 'truncate-nil)
  (setq doom-modeline-vcs t)
  (setq doom-modeline-percent-position '(-3 "%p"))
  (setq doom-modeline-minor-modes nil)
  (setq doom-modeline-buffer-encoding nil)
  (setq doom-modeline-battery nil)
  (setq inhibit-compacting-font-caches t)
  (setq find-file-visit-truename t)
  (setq all-the-icons-font-families nil)
  (setq all-the-icons-font-names nil)
  (setq all-the-icons-mode-icon-alist
        '((emacs-lisp-mode all-the-icons-fileicon "elisp" :height 1.0 :v-adjust -0.2 :face all-the-icons-purple)))

  ;; Add host machine name to mode line
  (setq doom-modeline-env-enable-python nil)
  (setq doom-modeline-env-enable-go nil)
  (setq doom-modeline-misc-info t)

  (doom-modeline-def-segment host
    "Display the hostname."
    (let* ((default-directory (or (buffer-file-name) default-directory))
           (remote-host (when (file-remote-p default-directory)
                          (tramp-file-name-host (tramp-dissect-file-name default-directory))))
           (host (or remote-host (system-name))))
      (concat
       (doom-modeline-spc)
       (propertize (format "@%s" host)
                   'face 'doom-modeline-debug))))

  ;; ;; Define a custom segment for the host machine
  ;; (doom-modeline-def-segment host
  ;;   "Display the hostname."
  ;;   (let ((host (system-name)))
  ;;     (concat
  ;;      (doom-modeline-spc)
  ;;      ;; (propertize (format "%s@%s" user-login-name host)
  ;;      ;;             'face 'doom-modeline-debug))))
  ;;      (propertize (format "@%s" host)
  ;;                  'face 'doom-modeline-debug))))

  ;; Add the custom segment to an existing modeline
  (doom-modeline-def-modeline 'main
    '(bar host workspace-name window-number modals matches buffer-info remote-host buffer-position parrot selection-info)
    '(misc-info minor-modes input-method indent-info buffer-encoding major-mode process vcs))

  (doom-modeline-set-modeline 'main t)

  :hook (after-init . doom-modeline-mode)
  )

(use-package all-the-icons
  :if (display-graphic-p)
)

(message "020-display-doom.el was loaded.")
