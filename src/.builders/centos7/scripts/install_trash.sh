#!/bin/sh

sudo yum -y install git
git clone https://github.com/andreafrancia/trash-cli.git
sudo python setup.py install
