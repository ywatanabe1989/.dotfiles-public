#!/bin/bash

# https://dan-project.blog.ss-blog.jp/2015-10-04

# sudo yum -y install ibus-kkc
sudo yum -y install ibus-kkc

export XMODIFIERS=@im=ibus
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus

ibus-setup

gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'kkc')]"


## EOF
