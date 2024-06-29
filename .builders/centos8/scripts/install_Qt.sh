#!/bin/bash

# https://doc.qt.io/qt-5/gettingstarted.html
sudo yum groupinstall "C Development Tools and Libraries"
sudo yum install mesa-libGL-devel

# http://qt.io/download


## the Qt Online Installer
# https://www.qt.io/download-qt-installer?hsCtaTracking=99d9dd4f-5681-48d2-b096-470725510d34%7C074ddad0-fdef-4e53-8aa8-5e8a876d6ab4

cd ~/Downloads/
chmod +x qt-unified-linux-x64-4.0.1-online.run
sudo ./qt-unified-linux-x64-4.0.1-online.run
# /opt/Qt


###
