#!/bin/bash


## Prerequisites
yum groupinstall "Development Tools"
yum -y install gnutls-devel ncurses-devel make gcc gcc-c++
yum -y install gtk2 gtk2-devel gtk3 gtk3-devel
yum install -y libXpm libXpm-devel
yum install -y libjpeg libjpeg-devel
# yum install -y libgif libgif-devel


# /libungif
yum install -y libtiff libtiff-devel
yum install -y gnutls gnutls-devel

# giflib-devel
yum install -y giflib giflib-devel


yum install -y elfutils-libelf-devel zlib-devel


yum install -y yum-utils


## EOF
