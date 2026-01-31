#!/bin/sh


YUM_REPO_SRC_DIR=$HOME/.builders/centos8/src/yum.repos.d/


# EPEL
sudo yum install epel-release -y
sudo yum repolist all
sudo yum config-manager --enable epel
sudo yum update -y


# ELRepo
sudo yum -y install elrepo-release
sudo yum repolist all
sudo yum update -y


## ELRepo Kernel
sudo dnf -y install https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
# Enable elrepo-kernel
# sudo emacs /etc/yum.repos.d/elrepo.repo
# [elrepo-kernel]
# enabled=1


# Google Chrome
SRC=${YUM_REPO_SRC_DIR}google-chrome.repo
TGT=/etc/yum.repos.d/
sudo cp $SRC $TGT
sudo yum install -y google-chrome-stable


# Power Tools
yum install dnf-plugins-core
yum config-manager --set-enabled powertools # CentOS8-Stream


# Remi
sudo yum -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
sudo yum repolist all


# ripgrep
sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo


# GitHub
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo


## EOF
