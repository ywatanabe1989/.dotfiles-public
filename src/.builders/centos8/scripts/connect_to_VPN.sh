#!/bin/bash

sudo yum update -y
sudo yum install libreswan -y
sudo yum install epel-release -y
sudo yum install xl2tpd -y
sudo yum install NetworkManager-l2tp -y
sudo yum install NetworkManager-l2tp-gnome -y

echo Now it\'s the time to reboot.
## EOF
