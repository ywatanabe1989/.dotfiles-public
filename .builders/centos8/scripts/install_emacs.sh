#!/bin/sh

# sudo yum remove emacs
# sudo rm /usr/local/bin/emacs*

## Install Emacs
VERSION=27.2

cd /tmp
echo $VERSION
curl -O http://ftp.gnu.org/pub/gnu/emacs/emacs-${VERSION}.tar.gz
tar xvf emacs-${VERSION}.tar.gz
cd emacs-$VERSION
./configure --prefix=/opt/emacs-$VERSION
make -j 16
sudo make install -j 16
echo `which emacs-$VERSION`

export PATH=''


## EOF
