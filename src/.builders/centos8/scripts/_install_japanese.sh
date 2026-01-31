#!/bin/bash

# https://akkisino02.hatenablog.com/entry/2017/10/14/211106
# https://www.alprovs.com/wordpress/?p=693
# http://note.kurodigi.com/centos7-fcitx/#id03

### http://note.kurodigi.com/centos7-fcitx/#id03 ###
# Fcitx
sudo dnf remove -y mozc ibus-mozc
sudo dnf --enablerepo=epel install -y fcitx

## 1st
# http://www.rpmfind.net/
sudo yum install fcitx
sudo yum install -y fcitx fcitx-configtool
# fc33.x86_64.rpm
sudo yum localinstall \
     fcitx-configtool-0.4.10-11.fc33.x86_64.rpm \
     fcitx-libs-4.2.9.8-1.fc33.x86_64.rpm # from http://www.rpmfind.net/
     # from http://www.rpmfind.net/



## 2nd
sudo yum localinstall \
    zinnia-0.06-50.fc33.x86_64.rpm \
    protobuf-3.12.4-1.fc33.x86_64.rpm \
    zinnia-tomoe-0.6.0-7.18.noarch.rpm \
    mozc-2.23.2815.102-13.fc33.x86_64.rpm \
    fcitx-mozc-2.25.4150.102-1.2.x86_64.rpm \
    mozc-gui-tools-2.25.4150.102-1.2.x86_64.rpm # OpenSuSE Tumbleweed for x86_64


## 3rd
gsettings set org.gnome.settings-daemon.plugins.keyboard active false
imsetting-swich fcitx
fcitx-configtool


## EOF
