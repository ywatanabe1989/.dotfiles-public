#!/bin/sh

## Check the SELinux Status
sestatus
## Disable SELinux temporarily
sudo setenforce 0
## Re-Check the SELinux Status
sestatus
## Disable SELinux permanently
sudo $EDITOR /etc/selinux/config # SELINUX=disabled # enforcing
reboot
## EOF
