(defvar shell-template
  "#!/usr/bin/env bash
# Script created on: %s
# Script path: %s

################################################################################
# Argument Parser
################################################################################
# usage() {
#     echo \"Usage: $0 -a ARGUMENT_A -b ARGUMENT_B -c ARGUMENT_C... [-h]\"
#     echo \"  -a Argument_A             Example Argument\"
#     echo \"  -b Argument_B             Example Argument\"
#     echo \"  -c Argument_C             Example Argument\"
#     echo \"  -h                   Display this help message\"
#     exit 1
# }
#
# while getopts \"a:b::h\" opt; do
#     case $opt in
#         a) ARGUMENT_A=$OPTARG ;;
#         b) ARGUMENT_B=$OPTARG ;;
#         c) ARGUMENT_C=$OPTARG ;;
#         h) usage ;;
#         *) usage ;;
#     esac
# done
#
# if [ -z \"$ARGUMENT_A\" ] || [ -z \"$$ARGUMENT_B\" ] || [ -z \"$$ARGUMENT_C\" ]; then
#     usage
# fi

################################################################################

# Global Parameters
LOG_PATH=\"$0\".log

################################################################################
# Main
################################################################################

# Functions
main() {
    # Opening
    echo -e \"$0 starts.\"

    # Main
    # YOUR_AWESOME_CODE

    # Closing
    echo -e \"$0 ends\"
}

################################################################################

touch $LOG_PATH
main | tee $LOG_PATH
echo -e \"\nLogged to: $LOG_PATH\"

# EOF
"
  "Shell script template.")

(defun my/shell-insert-template ()
  "Insert a shell script template with a timestamp and filename at the top of the buffer."
  (interactive)
  (when (string= (file-name-extension (or buffer-file-name "")) "sh")
    (let ((time-stamp (format-time-string "%Y-%m-%d %H:%M:%S"))
          (file-name-or-path (my/clean-ssh-path buffer-file-name)))
      ;; Insert the template with the current timestamp and file path at the beginning of the buffer
      (save-excursion
        (goto-char (point-min))
        (insert (format shell-template time-stamp file-name-or-path))))
    (goto-char (point-min))))

(defun my/shell-insert-template-if-new-file ()
  (interactive)
  (when (and (string= (file-name-extension (or buffer-file-name "")) "sh")
             (= (point-min) (point-max))) ; Check if the file is new
    (my/shell-insert-template)))


;; (defun my/shell-insert-template ()
;;   "Insert a shell script template with a timestamp and filename at the top of the buffer."
;;   (interactive)
;;   (when (string= (file-name-extension (or buffer-file-name "")) "sh")
;;     (let ((time-stamp (format-time-string "%Y-%m-%d %H:%M:%S"))
;;           (file-name-or-path (my/clean-ssh-path buffer-file-name)))
;;       ;; Insert the template with the current timestamp and file path at the beginning of the buffer
;;       (save-excursion
;;         (goto-char (point-min))
;;         (insert (format shell-template time-stamp file-name-or-path))))
;;     (goto-char (point-min))))

;; (defun my/shell-insert-template-if-new-file ()
;;   (interactive)
;;   (when (and (string= (file-name-extension (or buffer-file-name "")) "sh")
;;              (= (point-min) (point-max))) ; Check if the file is new
;;     (my/shell-insert-template)))


;; ;; working
;; (defun my/shell-insert-template-if-new-file ()
;;   "Insert the shell script template into a new file.
;;   If the file name contains 'ssh', 'sshx', 'rsync', or 'scp', the same template is used,
;;   but this function can be customized to handle such cases differently."
;;   (interactive)
;;   (when (and (string= (file-name-extension (or buffer-file-name "")) "sh")
;;              (= (point-min) (point-max))) ; Check if the file is new
;;     (let ((time-stamp (format-time-string "%Y-%m-%d %H:%M:%S"))
;;           (file-name-or-path (or buffer-file-name "")))
;;       ;; Insert the template with the current timestamp and file path
;;       (insert (format shell-template time-stamp file-name-or-path))
;;       (goto-char (point-min)))))

;; (add-hook 'shell-mode-hook (lambda ()
;;                           (when (and (buffer-file-name)
;;                                      (string-match "\\.sh\\'" (buffer-file-name))
;;                                      (= (point-min) (point-max)))
;;                             (shell/insert-template-if-new-file)))
;;           (define-key shell-mode-map (kbd "C-c C-f") 'my/copy-current-path)
;;           )

;; (defun my/shell-insert-template-if-new-file ()
;;   "Insert the shell script template into a new file.
;;   If the file name contains 'ssh', 'sshx', 'rsync', or 'scp', the same template is used,
;;   but this function can be customized to handle such cases differently."
;;   (interactive)
;;   (when (and (string= (file-name-extension (or buffer-file-name "")) "sh")
;;              (= (point-min) (point-max))) ; Check if the file is new
;;     (let ((time-stamp (format-time-string "%Y-%m-%d %H:%M:%S"))
;;           (file-name-or-path (or buffer-file-name "")))
;;       ;; Insert the template with the current timestamp and file path
;;       (insert (format shell-template time-stamp file-name-or-path))
;;       (goto-char (point-min)))))

(add-hook 'sh-mode-hook (lambda ()
                          (when (and (buffer-file-name)
                                     (string-match "\\.sh\\'" (buffer-file-name))
                                     (= (point-min) (point-max)))
                            (my/shell-insert-template-if-new-file)))
          (define-key shell-mode-map (kbd "C-c C-f") 'my/copy-current-path)
          )

(message "310-shell-templates.el was loaded.")
