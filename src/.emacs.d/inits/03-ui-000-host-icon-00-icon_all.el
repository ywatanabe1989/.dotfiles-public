;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-11-28 12:37:38>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-host-icon-00-icon_all.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(use-package nerd-icons
  :ensure
  t
  :custom
  (nerd-icons-font-family "Symbols Nerd Font Mono"))

(use-package all-the-icons
  :if
  (display-graphic-p)
  :config
  (unless (find-font (font-spec :name "all-the-icons"))
    (all-the-icons-install-fonts t)))

(use-package nerd-icons-ibuffer
  :ensure
  t
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode)
  :custom
  (nerd-icons-ibuffer-formats
   '((mark modified read-only locked " "
           (icon 2 2 :left :elide)
           (name 18 18 :left :elide)
           " "
           (size-h 9 -1 :right)
           " "
           (mode 16 16 :left :elide)
           " "
           filename-and-process))))

(use-package all-the-icons-ibuffer
  :ensure
  t
  :hook (ibuffer-mode . all-the-icons-ibuffer-mode))

(defvar my/icons-host-list
  '(("ywata-note-win" "f109" "dark gray")
    ("wsl" "f109" "dark gray")
    ("crest" "f0f8" "gold")
    ("sp" "f1e7" "deep sky blue")
    ("spartan" "f1e7" "deep sky blue")
    ("spartangpu" "f1e7" "dark magenta")
    ("titan" "f28f" "dark magenta")
    ("scitex" "f28f" "#8fa4b0")
    ("SciTeX" "f28f" "#8fa4b0")
    ("DXP480TPLUS-994" "f28f" "cyan3")
    ("dxp480tplus-994" "f28f" "cyan3")
    ("ugreen" "f28f" "cyan3")
    ("ug" "f28f" "cyan3")
    ("nas" "f28f" "cyan3")
    ("tt" "f28f" "dark magenta")
    ("g1" "f0e8" "indian red")
    ("g2" "f0e8" "indian red")
    ("g3" "f0e8" "indian red")
    ("g5" "f0e8" "indian red")
    ("g6" "f0e8" "indian red")
    ("g7" "f0e8" "indian red")
    ("g8" "f0e8" "indian red")
    ("c1" "f0e8" "indian red")
    ("c2" "f0e8" "indian red")
    ("c3" "f0e8" "indian red")
    ("c5" "f0e8" "indian red")
    ("c6" "f0e8" "indian red")
    ("c7" "f0e8" "indian red")
    ("c8" "f0e8" "indian red"))
  "List of host-specific icons and colors.")

(defun --my/get-host-icon-and-color (hostname)
  "Return an icon and color based on the hostname."
  (let ((host-icon (assoc hostname my/icons-host-list)))
    (if host-icon
        (cons (char-to-string (string-to-number (nth 1 host-icon) 16))
              (nth 2 host-icon))
      (cons (char-to-string (string-to-number "f109" 16))
            "black"))))

(defun my/show-nerd-icons ()
  "Display a list of nerd-icons with simple names and optional colors in a new buffer."
  (interactive)
  (let* ((colored (y-or-n-p "Only registered icons? "))
         (buffer (get-buffer-create "*Nerd Icons*"))
         (icons-per-row 4)
         (simple-names '(("f109" . ("laptop" . "green"))
                         ("f1e7" . ("spartan" . "yellow"))
                         ("f28f" . ("titan" . "orange"))
                         ("f173" . ("titan" . "blue"))
                         ("f0f8" . ("crest-hospital" . "red"))
                         ("f0e8" . ("gX" . "purple")))))
    (with-current-buffer buffer
      (erase-buffer)
      (dolist
          (range
           '(("f000" . "f2e0") ("e000" . "e0a0") ("ea60" . "ebeb")))
        (let ((start (string-to-number (car range) 16))
              (end (string-to-number (cdr range) 16))
              (col 0))
          (while (<= start end)
            (let* ((char (format "%04x" start))
                   (simple-name-color (or
                                       (cdr (assoc char simple-names))
                                       (cons
                                        (format "nf-icon-%s" char)
                                        "black"))))
              (when
                  (or (not colored)
                      (not (string= (cdr simple-name-color) "black")))
                (insert (propertize
                         (char-to-string (string-to-number char 16))
                         'face
                         `(:family "Symbols Nerd Font Mono"
                                   :height 200 :foreground
                                   ,(cdr simple-name-color)))
                        " " (car simple-name-color) "  ")
                (setq col (1+ col))
                (when (= col icons-per-row)
                  (insert "\n")
                  (setq col 0))))
            (setq start (1+ start))))
        (insert "\n\n"))
      (goto-char (point-min)))
    (switch-to-buffer buffer)))

(defun hex2char (hex)
  "Convert hex string to character."
  (char-to-string (string-to-number hex 16)))

(defun my/insert-icon (hex)
  "Insert a nerd-font icon based on its hexadecimal code."
  (insert (propertize (hex2char hex)
                      'face
                      `(:family "Symbols Nerd Font Mono" :height 200))))


(provide '03-ui-000-host-icon-00-icon_all)

(when
    (not load-file-name)
  (message "03-ui-000-host-icon-00-icon_all.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))