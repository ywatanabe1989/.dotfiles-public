(use-package whisper
  :load-path "/home/ywatanabe/.emacs.d/lisp/whisper.el"
  :bind (("M-RET" . whisper-run)
         ("C-M-T" . whisper-run))
  :config
  (setq whisper-install-directory "/tmp/"
        whisper-model "base"
        whisper-language "en"
        whisper-translate nil
        whisper-use-threads (num-processors)
        whisper-quantize "q8_0"
        )  
  )


(message "350-whisper.el was loaded.")
