;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-09-27 17:03:30>
;;; File: /home/ywatanabe/.emacs.d/inits/01-core-001-package-02-use-package.el

;;; Copyright (C) 2025 Yusuke Watanabe (ywatanabe@scitex.ai)


;; Install use-package if needed
(unless
    (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; --------------------------------------------------------------------------------

;; (use-package NAME &rest ARGS)

;; Declare an Emacs package by specifying a group of configuration options.

;; For full documentation, please see the README file that came with
;; this file.  Usage:

;;   (use-package package-name
;;      [:keyword [option]]...)

;; :init            Code to run before PACKAGE-NAME has been loaded.
;; :config          Code to run after PACKAGE-NAME has been loaded.  Note that
;;                  if loading is deferred for any reason, this code does not
;;                  execute until the lazy load has occurred.
;; :preface         Code to be run before everything except ‘:disabled’; this
;;                  can be used to define functions for use in ‘:if’, or that
;;                  should be seen by the byte-compiler.

;; :mode            Form to be added to ‘auto-mode-alist’.
;; :magic           Form to be added to ‘magic-mode-alist’.
;; :magic-fallback  Form to be added to ‘magic-fallback-mode-alist’.
;; :interpreter     Form to be added to ‘interpreter-mode-alist’.

;; :commands        Define autoloads for commands that will be defined by the
;;                  package.  This is useful if the package is being lazily
;;                  loaded, and you wish to conditionally call functions in your
;;                  ‘:init’ block that are defined in the package.
;; :hook            Specify hook(s) to attach this package to.

;; :bind            Bind keys, and define autoloads for the bound commands.
;; :bind*           Bind keys, and define autoloads for the bound commands,
;;                  *overriding all minor mode bindings*.
;; :bind-keymap     Bind a key prefix to an auto-loaded keymap defined in the
;;                  package.  This is like ‘:bind’, but for keymaps.
;; :bind-keymap*    Like ‘:bind-keymap’, but overrides all minor mode bindings

;; :defer           Defer loading of a package -- this is implied when using
;;                  ‘:commands’, ‘:bind’, ‘:bind*’, ‘:mode’, ‘:magic’, ‘:hook’,
;;                  ‘:magic-fallback’, or ‘:interpreter’.  This can be an integer,
;;                  to force loading after N seconds of idle time, if the package
;;                  has not already been loaded.
;; :after           Delay the use-package declaration until after the named modules
;;                  have loaded. Once load, it will be as though the use-package
;;                  declaration (without ‘:after’) had been seen at that moment.
;; :demand          Prevent the automatic deferred loading introduced by constructs
;;                  such as ‘:bind’ (see ‘:defer’ for the complete list).

;; :if EXPR         Initialize and load only if EXPR evaluates to a non-nil value.
;; :disabled        The package is ignored completely if this keyword is present.
;; :defines         Declare certain variables to silence the byte-compiler.
;; :functions       Declare certain functions to silence the byte-compiler.
;; :load-path       Add to the ‘load-path’ before attempting to load the package.
;; :diminish        Support for diminish.el (if installed).
;; :delight         Support for delight.el (if installed).
;; :custom          Call ‘custom-set’ or ‘set-default’ with each variable
;;                  definition without modifying the Emacs ‘custom-file’.
;;                  (compare with ‘custom-set-variables’).
;; :custom-face     Call ‘customize-set-faces’ with each face definition.
;; :ensure          Loads the package using package.el if necessary.
;; :pin             Pin the package to an archive.


(provide '01-core-001-package-02-use-package)

(when
    (not load-file-name)
  (message "01-core-001-package-02-use-package.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))