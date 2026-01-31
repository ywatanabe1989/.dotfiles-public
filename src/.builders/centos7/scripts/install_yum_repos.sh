#!/bin/sh

# EPEL
sudo yum install epel-release -y
sudo yum update -y
# nux-dextop
sudo yum install http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm -y
sudo yum update -y
# Add ELRepo
yum install http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm -y
sudo yum update -y

## EOF
