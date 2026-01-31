;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-05 22:08:50>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/02-base-999-ispell.el

;;; -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Time-stamp: <2024-11-09 12:04:14>
;;; File: ./.dotfiles/.emacs.d/inits/100-editing/999-ispell.el

(use-package flyspell
  :hook
  ((text-mode . flyspell-mode)
   (prog-mode . flyspell-prog-mode))
  :config
  (setq ispell-program-name "aspell"
        ispell-dictionary "american"
        ispell-extra-args '("--sug-mode=ultra")))

;; (use-package ispell
;;   :config
;;   (setq ispell-program-name "aspell"
;;         ispell-dictionary "american"
;;         ispell-extra-args '("--sug-mode=ultra"))

;;   ;; Words to ignore during spell checking
;;   (setq ispell-local-dictionary-alist
;;         '((nil
;;            "[A-Za-z]" "[^A-Za-z]"
;;            "[']"
;;            nil
;;            ("-B" "-d" "en_US")
;;            nil
;;            utf-8)))

;;   ;; Custom words to be ignored
;;   (setq ispell-local-pdict
;;         (append ispell-local-pdict
;;                 '("TODO"
;;                   "filepath"
;;                   "utils"
;;                   "numpy"
;;                   "sklearn"
;;                   "argv"
;;                   "args"
;;                   "kwargs"
;;                   "init"
;;                   "params"
;;                   "config"
;;                   "async"
;;                   "const"
;;                   "stdin"
;;                   "stdout"
;;                   "stderr"
;;                   "ywatanabe"
;;                   ))))

(when (not load-file-name)
  (message "%s loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide '02-base-999-ispell)

(when
    (not load-file-name)
  (message "02-base-999-ispell.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))