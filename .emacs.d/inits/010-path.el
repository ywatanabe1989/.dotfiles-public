;; -*- lexical-binding: t -*-

;; bin paths
(add-to-list 'exec-path "/usr/bin")
(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "/opt/local/bin")
(add-to-list 'exec-path "~/env-3.11/bin/")

;; custom file
(setq custom-file (locate-user-emacs-file "custom.el"))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file 'noerror)

(defun my/clean-ssh-path (file-path)
  "Clean the given FILE-PATH by removing SSH prefixes."
  (cond
   ((string-match "^/ssh:[^:]+:\\(.*\\)$" file-path)
    (match-string 1 file-path))
   ((string-match "^/scp:[^:]+:\\(.*\\)$" file-path)
    (match-string 1 file-path))
   ((string-match "^/rsync:[^:]+:\\(.*\\)$" file-path)
    (match-string 1 file-path))
   ((string-match "^/sshx:[^:]+:\\(.*\\)$" file-path)
    (match-string 1 file-path))
   (t file-path)))

(defun my/get-current-path ()
  "Return the current buffer's file path without SSH prefixes."
  (interactive)
  (let* ((file-path (or buffer-file-name default-directory))
         (clean-path (my/clean-ssh-path file-path)))
    (message "Current path: %s" clean-path)
    clean-path))

(defun my/get-current-dir ()
  "Return the current directory without SSH prefixes."
  (interactive)
  (let* ((current-path (my/get-current-path))
         (current-dir (if (file-directory-p current-path)
                          current-path
                        (file-name-directory current-path))))
    (when (called-interactively-p 'any)
      (message "Current directory: %s" current-dir))
    current-dir))




(defun my/copy-current-path ()
  "Copy the current buffer's file path to the clipboard."
  (interactive)
  (let* ((file-path (or buffer-file-name default-directory))
         (path-to-copy (my/clean-ssh-path file-path)))
    (kill-new path-to-copy)
    (message "Copied path: %s" path-to-copy)))

(defun my/find-file ()
  "Open a file with the default minibuffer input being the current file's path without its extension."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if filename
        (find-file (read-file-name "Open file: " nil (file-name-sans-extension filename) t))
      (find-file (read-file-name "Open file: ")))))


(bind-key* (kbd "C-c C-f") 'my/copy-current-path)

(message "010-path.el was loaded.")
