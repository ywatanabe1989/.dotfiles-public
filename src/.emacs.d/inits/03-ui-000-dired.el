;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-12-22 02:24:45>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/inits/03-ui-000-dired.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)

(require 'dired)
(require 'dired-x)

(require 'direx)

(require 'image-mode)

;; Define colors for different file types
(setq dired-format-files-filter-function #'identity)
(setq dired-dwim-target t)
(setq dired-tree-mode nil)

;; Basic settings
(setq dired-listing-switches "-alh"
      dired-use-ls-dired nil
      dired-find-file-visit-truename nil
      find-file-visit-truename nil
      dired-omit-files "^\\...+$\\|^~\\|^#.*#$"
      dired-omit-files-p t
      dired-recursive-copies 'always
      dired-recursive-deletes 'always
      dired-dwim-target t
      dired-clean-confirm-killing-deleted-buffers nil)

(add-hook 'dired-mode-hook
          (lambda
            ()
            (dired-omit-mode t)
            (dired-hide-details-mode t)
            (setq truncate-lines t)))

(defun my/dired-zip
    ()
  "Zip the directory or file at point in dired."
  (interactive)
  (let*
      ((file
        (dired-get-filename))
       (zip-name
        (concat
         (file-name-nondirectory file)
         ".zip")))
    (when file
      (if
          (file-directory-p file)
          (shell-command
           (format "zip -r %s %s"
                   (shell-quote-argument zip-name)
                   (shell-quote-argument
                    (file-name-nondirectory file))))
        (shell-command
         (format "zip %s %s"
                 (shell-quote-argument zip-name)
                 (shell-quote-argument
                  (file-name-nondirectory file)))))
      (revert-buffer))))

(defun my/dired-smart-find-file
    ()
  "Handle file opening in dired with special cases for remote files."
  (interactive)
  (let
      ((file
        (dired-get-filename nil t)))
    (when file
      (cond
       ((file-directory-p file)
        (dired-find-alternate-file))
       ((file-remote-p file)
        (let
            ((tramp-mode t))
          (find-file file)))
       (t
        (dired-find-file))))))

(defun my/copy-to-win-downloads
    ()
  "Copy marked files or directories using rsync.
Handles both WSL and NAS environments:
- On WSL: pulls from remote to /mnt/c/Users/wyusu/Downloads/
- On NAS: pushes to Windows via ywata SSH host (through b2 bastion)"
  (interactive)
  (let*
      ((files
        (if
            (eq major-mode 'dired-mode)
            (or
             (dired-get-marked-files)
             (list
              (dired-get-filename)))
          (when buffer-file-name
            (list buffer-file-name))))
       (on-nas-p
        (or (string-match-p "nas\\|ugreen\\|DXP480" (system-name))
            (not (file-exists-p "/mnt/c"))))
       (destination-dir
        (if on-nas-p
            "ywata:/c/Users/wyusu/Downloads/"
          "/mnt/c/Users/wyusu/Downloads/"))
       (temp-script
        (make-temp-file "copy-script" nil ".sh")))
    (if files
        (progn
          (with-temp-file temp-script
            (insert "#!/bin/bash\n")
            (dolist
                (source files)
              (cond
               ;; On NAS with TRAMP path to nas itself - use local path
               ((and on-nas-p
                     (string-match-p
		      "^/ssh:\\([^@]+@\\)?\\(nas\\|ug\\|ugreen\\):" source))
                (let
                    ((local-path
                      (replace-regexp-in-string "^/ssh:[^:]+:" ""
						source)))
                  (insert
                   (format
                    "rsync -avzL --progress -e 'ssh -o StrictHostKeyChecking=no' %s %s\n"
                    (shell-quote-argument local-path)
                    destination-dir))))
               ;; On NAS with local path - push directly
               (on-nas-p
                (insert
                 (format
                  "rsync -avzL --progress -e 'ssh -o StrictHostKeyChecking=no' %s %s\n"
                  (shell-quote-argument source)
                  destination-dir)))
               ;; On WSL with TRAMP path to NAS - use scp (rsync blocked by Ugreen)
               ((string-match-p "^/ssh:\\([^@]+@\\)?\\(nas\\|ug\\|ugreen\\)"
				source)
                (let*
                    ((remote-host
                      (replace-regexp-in-string ":.*" ""
                                                (replace-regexp-in-string
                                                 "^/ssh:" "" source)))
                     (remote-path
                      (replace-regexp-in-string "^.*:" "" source)))
                  (insert
                   (format
                    "scp -r -o StrictHostKeyChecking=no %s:%s %s\n"
                    remote-host
                    (shell-quote-argument remote-path)
                    (shell-quote-argument destination-dir)))))
               ;; On WSL with other TRAMP paths - use rsync
               ((string-match-p "^/ssh:" source)
                (let*
                    ((remote-host
                      (replace-regexp-in-string ":.*" ""
                                                (replace-regexp-in-string
                                                 "^/ssh:" "" source)))
                     (remote-path
                      (replace-regexp-in-string "^.*:" "" source)))
                  (insert
                   (format
                    "rsync -avzL --progress -e 'ssh -o StrictHostKeyChecking=no' %s:%s %s\n"
                    remote-host remote-path
                    (shell-quote-argument destination-dir)))))
               ;; On WSL with local path
               (t
                (insert
                 (format "rsync -avzL --progress %s %s\n"
                         (shell-quote-argument source)
                         (shell-quote-argument destination-dir)))))))
          (start-process "debugging" "*copy-log*" "cat" temp-script)
          (start-process "background-copy" "*copy-log*" "bash"
                         temp-script)
          (message
           "Copy process started in background. Check *copy-log* buffer."))
      (user-error "No files selected for copying"))))

(defun my/dired-rename
    (pattern replacement)
  "Rename files in marked directories using find.
Pattern is searched in filenames and replaced with Replacement.
Shows dry run preview first and asks for confirmation."
  (interactive "sPattern: \nsReplacement: \n")
  (require 'seq)
  (let*
      ((marked
        (dired-get-marked-files nil nil nil t))
       (dirs
        (or
         (seq-filter #'file-directory-p marked)
         (list
          (dired-current-directory))))
       (find-cmd
        (format "find %s -name '*%s*'"
                (mapconcat #'shell-quote-argument dirs " ")
                pattern))
       (paths
        (seq-filter #'file-exists-p
                    (split-string
                     (shell-command-to-string find-cmd)
                     "\n" t)))
       changed-pairs)
    ;; Build rename pairs list
    (dolist
        (old paths)
      (when
          (file-exists-p old)
        (let
            ((new
              (replace-regexp-in-string
               (regexp-quote pattern)
               replacement
               old
               nil
               'literal)))
          (push
           (cons old new)
           changed-pairs))))
    ;; Show preview
    (with-current-buffer
        (get-buffer-create "*my/dired-rename-dry-run*")
      (erase-buffer)
      (insert "Dry run:\n\n")
      (dolist
          (pair
           (nreverse changed-pairs))
        (insert
         (format "Before: %s\nAfter:  %s\n\n"
                 (car pair)
                 (cdr pair)))))
    (pop-to-buffer "*my/dired-rename-dry-run*")
    ;; Execute rename if confirmed
    (when
        (and changed-pairs
             (y-or-n-p "Proceed with rename? "))
      ;; First create all necessary directories
      (dolist
          (pair changed-pairs)
        (let
            ((new-dir
              (file-name-directory
               (cdr pair))))
          (unless
              (file-exists-p new-dir)
            (make-directory new-dir t))))
      ;; Then move files with new names
      (dolist
          (pair
           (sort changed-pairs
                 (lambda
                   (a b)
                   (>
                    (length
                     (car a))
                    (length
                     (car b))))))
        (let
            ((old
              (car pair))
             (new
              (cdr pair)))
          (when
              (and
               (file-exists-p old)
               (not
                (file-exists-p new)))
            (if
                (file-directory-p old)
                (rename-file old new t)
              (rename-file old new)))))
      (ignore-errors
        (revert-buffer nil t t))
      (kill-buffer "*my/dired-rename-dry-run*"))))

(defun my/dired-apply-pim
    ()
  "Apply pim to marked .py files in dired."
  (interactive)
  (let*
      ((files
        (dired-get-marked-files))
       (py-files
        (seq-filter
         (lambda
           (file)
           (string-match-p "\\.py$" file))
         files)))
    (if py-files
        (progn
          (dolist
              (file py-files)
            (with-current-buffer
                (find-file-noselect file)
              (pim)
              (save-buffer)
              (kill-buffer))
            (message "Applied pim to %s" file))
          (revert-buffer))
      (user-error "No .py files selected"))))

(defun my/dired-touch
    ()
  "Touch a file in dired mode."
  (interactive)
  (let*
      ((dir
        (dired-current-directory))
       (filename
        (read-string "Touch file: "))
       (fullpath
        (expand-file-name filename dir)))
    (shell-command
     (concat "touch "
             (shell-quote-argument fullpath)))
    (revert-buffer)))

(defun find-file-revert-buffer-no-confirm
    (filename)
  "Visit FILENAME and revert buffer without confirmation."
  (let
      ((buf
        (find-file-noselect filename)))
    (switch-to-buffer buf)
    (with-current-buffer buf
      (revert-buffer nil t nil))))

(defun dired-find-file-revert-buffer
    ()
  "In Dired, visit the file or directory named on this line and revert without confirmation."
  (interactive)
  ;; (message "Debug: Starting dired-find-file-revert-buffer")
  (let*
      ((find-file-run-dired t)
       (file-to-visit
        (dired-get-file-for-visit)))
    ;; (message "Debug: File to visit: %s" file-to-visit)
    (find-file-revert-buffer-no-confirm file-to-visit)))

(defun my/dired-copy-the-selected-file
    ()
  "Copy the selected file with '_copied' suffix."
  (interactive)
  (let*
      ((file
        (dired-get-filename))
       (dir
        (file-name-directory file))
       (name
        (file-name-nondirectory file))
       (ext
        (file-name-extension file))
       (base
        (file-name-sans-extension name))
       (new-name
        (concat dir base "_." ext)))
    (copy-file file new-name)
    (revert-buffer)))

(defun my/dired-rename
    (pattern replacement)
  "Rename files in marked directories using find.
Pattern is searched in filenames and replaced with Replacement.
Shows dry run preview first and asks for confirmation."
  (interactive "sPattern: \nsReplacement: \n")
  (require 'seq)
  (let*
      ((marked
        (dired-get-marked-files nil nil nil t))
       (dirs
        (or
         (seq-filter #'file-directory-p marked)
         (list
          (dired-current-directory))))
       (find-cmd
        (format "find %s -name '*%s*' -depth"
                (mapconcat #'shell-quote-argument dirs " ")
                pattern))
       (paths
        (seq-filter #'file-exists-p
                    (split-string
                     (shell-command-to-string find-cmd)
                     "\n" t)))
       changed-pairs)
    ;; Build rename pairs list
    (dolist
        (old paths)
      (when
          (file-exists-p old)
        (let
            ((new
              (replace-regexp-in-string
               (regexp-quote pattern)
               replacement
               old
               nil
               'literal)))
          (push
           (cons old new)
           changed-pairs))))
    ;; Show preview
    (with-current-buffer
        (get-buffer-create "*my/dired-rename-dry-run*")
      (erase-buffer)
      (insert "Dry run:\n\n")
      (dolist
          (pair
           (reverse changed-pairs))
        (insert
         (format "Before: %s\nAfter:  %s\n\n"
                 (car pair)
                 (cdr pair)))))
    (pop-to-buffer "*my/dired-rename-dry-run*")
    ;; Execute rename if confirmed
    (when
        (and changed-pairs
             (y-or-n-p "Proceed with rename? "))
      ;; First create all necessary directories
      (dolist
          (pair changed-pairs)
        (let
            ((new-dir
              (file-name-directory
               (cdr pair))))
          (unless
              (file-exists-p new-dir)
            (make-directory new-dir t))))
      ;; Then move files with new names
      (dolist
          (pair
           (reverse changed-pairs))
        (let
            ((old
              (car pair))
             (new
              (cdr pair)))
          (when
              (and
               (file-exists-p old)
               (not
                (file-exists-p new)))
            (if
                (file-directory-p old)
                (rename-file old new t)
              (copy-file old new t t)
              (delete-file old)))))
      (ignore-errors
        (revert-buffer nil t t))
      (kill-buffer "*my/dired-rename-dry-run*"))))

(defun my/dired-versioning-file
    ()
  "Create versioned backup of the selected file in Dired.
Copies file to a hidden directory with version suffix (e.g., '_v001').
Creates copy in the original location with same name.
Versions are stored in .<basename>-versions/ directory."
  (interactive)
  (let*
      ((file
        (dired-get-filename))
       (dir
        (file-name-directory file))
       (name
        (file-name-nondirectory file))
       (base-pattern
        (replace-regexp-in-string "_v[0-9]+$" "" name))
       (versions-dir
        (expand-file-name
         (concat "." base-pattern "-versions")
         dir))
       (version-files
        (if
            (file-exists-p versions-dir)
            (directory-files versions-dir t
                             (concat "^"
                                     (regexp-quote base-pattern)
                                     "_v[0-9]+$"))
          nil))
       (next-version
        (if version-files
            (1+
             (string-to-number
              (replace-regexp-in-string
               ".*_v\\([0-9]+\\)$" "\\1"
               (car
                (last
                 (sort version-files #'string<))))))
          1))
       (new-name
        (expand-file-name
         (format "%s_v%03d" base-pattern next-version)
         versions-dir))
       (remote-p
        (file-remote-p file))
       (buf
        (find-buffer-visiting file)))

    (when buf
      (with-current-buffer buf
        (save-buffer)
        (kill-buffer)))

    (unless
        (file-exists-p versions-dir)
      (make-directory versions-dir t))

    (let
        ((default-directory dir))
      (shell-command
       (format "cp -f %s %s"
               (shell-quote-argument name)
               (shell-quote-argument
                (concat "." base-pattern "-versions/"
                        (format "%s_v%03d" base-pattern next-version)))))

      (shell-command
       (format "cp -f %s %s"
               (shell-quote-argument
                (concat "." base-pattern "-versions/"
                        (format "%s_v%03d" base-pattern next-version)))
               (shell-quote-argument name))))

    (revert-buffer)
    (message "Created version %03d of %s" next-version name)))

(defun my/dired-im2vid
    ()
  "Convert selected image files to video using ffmpeg in background."
  (interactive)
  (unless
      (eq major-mode 'dired-mode)
    (user-error "Not in dired mode"))

  (let*
      ((files
        (dired-get-marked-files))
       (dir
        (file-name-directory
         (car files)))
       (filelist-file
        (make-temp-file "im2vid" nil ".txt"))
       (output-name
        (concat
         (file-name-base
          (car files))
         "_video.mp4")))

    (with-temp-file filelist-file
      (dolist
          (file files)
        (when
            (string-match-p "\\.\\(jpe?g\\|png\\)$" file)
          (insert
           (format "file '%s'\nduration %f\n"
                   (expand-file-name file)
                   (/ 1.0 30.0)))))
      (when files
        (insert
         (format "file '%s'\n"
                 (expand-file-name
                  (car
                   (last files)))))))

    (let
        ((default-directory dir))
      (start-process "ffmpeg" "*ffmpeg*"
                     "ffmpeg" "-y" "-f" "concat" "-safe" "0"
                     "-i" filelist-file
                     "-vf"
                     "scale=1920:1920:force_original_aspect_ratio=decrease,pad=1920:1920:-1:-1:color=black"
                     "-c:v" "libx264" "-preset" "faster" "-crf" "23"
                     "-pix_fmt" "yuv420p" "-threads" "4"
                     "-maxrate" "10M" "-bufsize" "20M"
                     "-movflags" "+faststart"
                     output-name))

    (run-with-timer 1 nil
                    (lambda
                      ()
                      (delete-file filelist-file)))
    (message "Converting to video in background...")))

(defun my/dired-open-in-explorer ()
  "Open current dired directory with Windows Explorer (WSL2)."
  (interactive)
  (let* ((dir (dired-current-directory))
         (win-path (string-trim
                    (shell-command-to-string
                     (format "wslpath -w %s"
                             (shell-quote-argument dir))))))
    (start-process "explorer" nil "explorer.exe" win-path)))

(defun my/ensure-no-dired-line-numbers ()
  "Ensure line numbers are disabled in dired."
  (display-line-numbers-mode -1)
  (when (bound-and-true-p global-display-line-numbers-mode)
    (setq-local display-line-numbers nil))
  (setq-local display-line-numbers nil))

(add-hook 'dired-mode-hook 'my/ensure-no-dired-line-numbers)

;; (define-key dired-mode-map
;;             (kbd "C-c v")
;;             #'my/dired-im2vid)

;; ;; Keybindings
;; ;; (define-key dired-mode-map (kbd "C-m") 'my/dired-smart-find-file)

;; (define-key dired-mode-map
;;             (kbd "RET")
;;             'dired-find-file-revert-buffer)

;; (define-key dired-mode-map
;;             (kbd "R")
;;             'my/dired-rename)

;; (define-key dired-mode-map
;;             (kbd "C-c z")
;;             #'my/dired-zip)

;; (define-key dired-mode-map
;;             (kbd "C-c c")
;;             #'dcc-run)

;; (define-key dired-mode-map
;;             (kbd "C-c C-a")
;;             nil)

;; (define-key dired-mode-map
;;             (kbd "S")
;;             'dired-do-relsymlink)

;; (define-key dired-mode-map
;;             (kbd "h")
;;             'dired-hide-details-mode)

;; (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;; (define-key dired-mode-map
;;             (kbd "C-t")
;;             'other-window)

;; (define-key dired-mode-map
;;             (kbd "C-i")
;;             'image-dired-dired-toggle-marked-thumbs)

;; (define-key dired-mode-map
;;             (kbd "S-s")
;;             'dired-do-relsymlink)

;; (define-key dired-mode-map
;;             (kbd "M-h")
;;             (lambda
;;               ()
;;               (interactive)
;;               (etm-navigation-jump-by-buffer-type "home")))

;; (define-key dired-mode-map
;;             (kbd "M-H")
;;             (lambda
;;               ()
;;               (interactive)
;;               (my/tab-set-buffer "home")))

;; (define-key dired-mode-map
;;             (kbd "M-s")
;;             (lambda
;;               ()
;;               (interactive)
;;               (etm-navigation-jump-by-buffer-type "semi-home")))

;; (define-key dired-mode-map
;;             (kbd "M-S")
;;             (lambda
;;               ()
;;               (interactive)
;;               (my/tab-set-buffer "semi-home")))

;; (define-key dired-mode-map
;;             (kbd "C-C r")
;;             'my/copy-to-win-downloads)

;; (define-key dired-mode-map
;;             (kbd "C-c p")
;;             #'my/dired-apply-pim)

(provide '03-ui-000-dired)

(when
    (not load-file-name)
  (message "03-ui-000-dired.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))
