(use-package tramp
  :ensure t
  :config
  ;; Optimize VC backends to avoid unnecessary checks
  (defadvice tramp-handle-vc-registered (around tramp-handle-vc-registered-around activate)
    (let ((vc-handled-backends '(SVN Git))) ad-do-it))
  
  ;; Disable backup for TRAMP files to avoid slow operations
  (add-to-list 'backup-directory-alist
               (cons tramp-file-name-regexp nil))
  
  ;; Adjust SSH ControlMaster options for performance
  (setq tramp-ssh-controlmaster-options
        "-o ControlMaster=auto -o ControlPersist=60s -o Compression=yes -o CompressionLevel=9")
  
  ;; Use a lightweight remote shell
  (setq tramp-default-remote-shell "sh")
  (setq tramp-remote-shell "/bin/sh")
  (setq tramp-remote-shell-args '("-c"))
  
  ;; Enable caching and specify the persistency file
  (setq tramp-persistency-file-name "~/.emacs.d/tramp")
  (setq tramp-use-ssh-controlmaster-options t)
  (setq remote-file-name-inhibit-cache nil)
  (setq vc-ignore-dir-regexp
        (format "%s\\|%s"
                vc-ignore-dir-regexp
                tramp-file-name-regexp))
  
  ;; Adjust verbosity as needed (lower numbers are quieter, higher numbers provide more debug info)
  (setq tramp-verbose 1)
)
