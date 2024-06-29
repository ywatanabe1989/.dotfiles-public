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
