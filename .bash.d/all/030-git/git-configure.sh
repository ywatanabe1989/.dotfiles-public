#!/usr/bin/env bash
# Script created on: 2024-06-24 19:04:59
# Script path: /home/ywatanabe/.dotfiles/.bash.d/all/030-git/git-configure.sh

git-configure-wyusuuke () {
    for lc in --local --global; do
        git config $lc user.email "wyusuuke@gmail.com"
        git config $lc user.name "Yusuke Watanabe"
        git config $lc init.templatedir "~/.git-templates"
        # git config $lc pull.ff only
        git config $lc pull.rebase false
        git config $lc push.autoSetupRemote true
    done
}


git-configure-ywatanabe-alumni () {
    for lc in --local --global; do
        git config $lc user.email "ywatanabe@alumni.u-tokyo.ac.jp"
        git config $lc user.name "Yusuke Watanabe"
        git config $lc init.templatedir "~/.git-templates"
        # git config pull.ff only
        git config $lc pull.rebase false
        git config $lc push.autoSetupRemote true
    done
}

git-configure-ywatanabe-work () {
    for lc in --local --global; do
        git config $lc user.email "work@example.com"
        git config $lc user.name "Yusuke Watanabe"
        git config $lc init.templatedir "~/.git-templates"
        # git config pull.rebase false
        git config $lc pull.rebase false
        git config $lc push.autoSetupRemote true
    done
}

# EOF
