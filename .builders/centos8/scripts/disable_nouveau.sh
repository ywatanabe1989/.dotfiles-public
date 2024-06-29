#!/bin/bash

lsmod | grep nouveau

lspci | grep VGA

# https://qiita.com/mokemokechicken/items/d9b35c29d6ed4d60b63c
sudo tee /etc/modprobe.d/blacklist-nouveau.conf << EOF > /dev/null
blacklist nouveau
options nouveau modeset=0
EOF

