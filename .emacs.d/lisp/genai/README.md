# Installation
```
EMACS_GENAI_DIR=~/.emacs.d/lisp/emacs-genai/
$ git clone git@github.com:ywatanabe1989/emacs-genai.git $EMACS_GENAI_DIR
```

# Demo
![Demo](docs/demo.gif)

# Python installation

``` elisp
cd $HOME
sudo apt install python3.11 python3.11-dev python3.11-tk python3.11-venv
python3.11 -m venv env-3.11 && source env-3.11/bin/activate && python3.11 -m pip install -U pip && pip install mngs
```

# Emacs config
``` elisp
(add-to-list 'load-path getenv("EMACS_GENAI_DIR"))
(require 'emacs-genai)
(setq genai-key getenv("GENAI_API_KEY"))
(setq genai-engine getenv("GENAI_ENGINE"))
(setq genai-script-path (concat getenv("EMACS_GENAI_DIR") emacs-genai.py))
(define-key global-map (kbd "M-C-g") 'genai-on-region)
```

# Templates 

``` elisp
Templates can be directly added / edited at ./templates dir.
Your input (or selected region) is inserted into "PLACEHOLDER"
```

