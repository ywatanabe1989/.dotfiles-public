#!/bin/sh

yum update -y

yum install libreswan -y

yum install epel-release -y

yum install xl2tpd -y

yum install NetworkManager-l2tp -y

yum install NetworkManager-l2tp-gnome -y

reboot

## EOF
