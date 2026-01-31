;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-05-19 06:58:51>
;;; File: /home/ywatanabe/.emacs.d/inits/03-ui-000-vterm-10-new.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


(defun --my/vterm-new (term-name)
  (interactive "sVterm Name: ")
  (let* ((term-name
          (concat term-name "-" (format-time-string "%H:%M:%S")))
         (buffer-name (format "%s" term-name))
         (counter 1)
         (dir default-directory)
         (default-directory (expand-file-name
                             (if (and dir
                                      (not (file-remote-p dir))
                                      (file-exists-p dir))
                                 dir
                               "~/"))))
    (while (get-buffer buffer-name)
      (setq buffer-name (format "Term: %s<%d>" term-name counter)
            counter (1+ counter)))
    (let ((vterm-buffer (vterm buffer-name)))
      (with-current-buffer vterm-buffer
        vterm-buffer))))

(defvar ----my/vterm-counter 0
  "Counter to track the number of terminals opened.")

(defun --my/vterm-new-there (vterm-name)
  "Open a new vterm buffer in the current directory.
With prefix VTERM-NAME, prompt for a terminal name."
  (interactive "P")
  (let* ((host (my/find-host))
         (current-dir (if (file-remote-p default-directory)
                          (file-remote-p default-directory 'localname)
                        default-directory))
         (dir-name
          (file-name-nondirectory (directory-file-name current-dir)))
         (default-name (format "%s-%s" host dir-name))
         (term-name (if vterm-name
                        (read-string "Vterm Name: " default-name)
                      default-name))
         (buffer-name (format "vterm: %s" term-name))
         (counter 1)
         (original-directory default-directory))
    (while (get-buffer buffer-name)
      (setq buffer-name (format "vterm: %s<%d>" term-name counter)
            counter (1+ counter)))
    (condition-case err
        (let ((vterm-buffer (vterm buffer-name)))
          (with-current-buffer vterm-buffer
            (condition-case nil
                (if (file-remote-p original-directory)
                    ;; Remote
                    (let* ((vec
                            (tramp-dissect-file-name
                             original-directory))
                           (remote-host (tramp-file-name-host vec))
                           (remote-path
                            (tramp-file-name-localname vec)))
                      (vterm-send-string
                       (format "ssh %s\n" remote-host))
                      (sit-for 1)
                      (vterm-send-string
                       (format "cd %s\n"
                               (shell-quote-argument remote-path))))
                  ;; Local
                  (vterm-send-string
                   (format "cd %s && clear\n"
                           (shell-quote-argument
                            (expand-file-name default-directory)))))
              (error nil))
            vterm-buffer))
      (error nil))))


(provide '03-ui-000-vterm-10-new)

(when
    (not load-file-name)
  (message "03-ui-000-vterm-10-new.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))