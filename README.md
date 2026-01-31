## Installation

Clone this repository and deploy the configuration files to your local system with the following steps. The original dotfiles are backed up and new configurations are symlinked:

``` bash
# Clone the repository to the local .dotfiles directory
git clone git@github.com:ywatanabe1989/.dotfiles.git ~/.dotfiles

# Run the deployment script
sh ~/.dotfiles/deploy.sh
```

## Encrypting secret files
Use the commands below to encrypt all files located in any "secret" directory, as well as any files whose names include the word "secret," using git-crypt.

``` bash
source .bash.d/all/030-git-encrypt.sh # To load the git-encrypt-secrets command
git-encrypt-secrets
```

For more details, please see [https://github.com/ywatanabe1989/git-crypt-example](https://github.com/ywatanabe1989/git-crypt-example).


# General pattern
git submodule add <repository-url> .emacs.d/lisp/<module-name>

# Example for each module
# First create backups if needed
cd ~/.emacs.d/lisp/elisp-test ;; Not all tests pass

cd ~/.emacs.d/lisp/emacs-llm
cd ~/.emacs.d/lisp/emacs-slack
cd ~/.emacs.d/lisp/emacs-tab-manager
cd ~/.emacs.d/lisp/python-import-manager

# Then add each as a submodule
git submodule add https://github.com/yourusername/elisp-test.git .emacs.d/lisp/elisp-test
git submodule add https://github.com/yourusername/emacs-header-footer.git .emacs.d/lisp/emacs-header-footer
git submodule add https://github.com/yourusername/emacs-llm.git .emacs.d/lisp/emacs-llm
git submodule add https://github.com/yourusername/emacs-request.git .emacs.d/lisp/emacs-request
git submodule add https://github.com/yourusername/emacs-slack.git .emacs.d/lisp/emacs-slack
git submodule add https://github.com/yourusername/emacs-tab-manager.git .emacs.d/lisp/emacs-tab-manager
git submodule add https://github.com/yourusername/python-import-manager.git .emacs.d/lisp/python-import-manager

# Finally commit the changes
git add .gitmodules
git add .emacs.d/lisp/
git commit -m "Add Emacs modules as submodules"
