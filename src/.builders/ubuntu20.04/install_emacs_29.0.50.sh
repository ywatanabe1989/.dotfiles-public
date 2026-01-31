#!/bin/bash

## Preparation
sudo apt-get --purge autoremove emacs
sudo apt update
sudo apt-get install autoconf
sudo apt install adwaita-icon-theme-full
sudo apt install libxml2-dev


## Build from source
git clone git://git.sv.gnu.org/emacs.git
sudo apt install build-essential libgtk-3-dev libgnutls28-dev libtiff5-dev libgif-dev libjpeg-dev libpng-dev libxpm-dev libncurses-dev texinfo
cd emacs
./autogen.sh
./configure --prefix=/opt/emacs-29.0.50 --with-mailutils 
make -j 12
sudo make install

## EOF
