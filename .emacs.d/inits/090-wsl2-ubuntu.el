;; -*- lexical-binding: t -*-

;; https://emacsredux.com/blog/2021/12/19/using-emacs-on-windows-11-with-wsl2/

;; $ git clone git://git.sv.gnu.org/emacs.git
;; $ sudo apt install build-essential libgtk-3-dev libgnutls28-dev libtiff5-dev libgif-dev libjpeg-dev libpng-dev libxpm-dev libncurses-dev texinfo
;; $ cd emacs
;; $ ./autogen.sh
;; $ ./configure # --with-pgtk
;; $ make -j8
;; $ sudo make install


(pixel-scroll-precision-mode)

(defun copy-selected-text (start end)
  (interactive "r")
    (if (use-region-p)
        (let ((text (buffer-substring-no-properties start end)))
            (shell-command (concat "echo '" text "' | clip.exe")))))

(defun wsl-copy (start end)
  (interactive "r")
  (shell-command-on-region start end "clip.exe")
  (deactivate-mark))

(defun wsl-paste ()
  (interactive)
  (let ((clipboard
         (shell-command-to-string "powershell.exe -comand 'Get-Clipboard' 2> /dev/null")))
    (setq clipboard (replace-regexp-in-string "\r" "" clipboard))
    (setq clipboard (substring clipboard 0 -1))
    (insert clipboard)))

(global-set-key (kbd "C-c C-w") 'wsl-copy)
(global-set-key (kbd "C-c C-y") 'wsl-paste)




(message "090-wsl2-ubuntu.el was loaded.")
