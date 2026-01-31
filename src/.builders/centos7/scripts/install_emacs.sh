#!/bin/sh
## Please add executable permission with the following command
## $ sudo chown +x install_emacs.sh

# sudo yum remove emacs
# sudo rm /usr/local/bin/emacs*


## Install Emacs
VERSION=26.1

cd /tmp
echo $VERSION
curl -O http://ftp.gnu.org/pub/gnu/emacs/emacs-${VERSION}.tar.gz
tar xvf emacs-${VERSION}.tar.gz
cd emacs-$VERSION
./configure
make -j 16
sudo make install -j 16
echo `which emacs-$VERSION`


## EOF
