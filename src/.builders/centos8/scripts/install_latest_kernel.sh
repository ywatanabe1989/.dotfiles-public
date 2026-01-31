#!/bin/bash
# https://www.centlinux.com/2020/07/upgrade-to-latest-linux-kernel-centos-8.html
# https://qiita.com/kawaz/items/21637f5f0b443bbf7893
# https://linux.yebisu.jp/memo/1252


sudo dnf --disablerepo="*" --enablerepo="elrepo-kernel" list available | grep kernel-ml
# kernel-ml.x86_64                        5.10.7-1.el8.elrepo        elrepo-kernel
# kernel-ml-core.x86_64                   5.10.7-1.el8.elrepo        elrepo-kernel
# kernel-ml-devel.x86_64                  5.10.7-1.el8.elrepo        elrepo-kernel
# kernel-ml-doc.noarch                    5.10.7-1.el8.elrepo        elrepo-kernel
# kernel-ml-headers.x86_64                5.10.7-1.el8.elrepo        elrepo-kernel
# kernel-ml-modules.x86_64                5.10.7-1.el8.elrepo        elrepo-kernel
# kernel-ml-modules-extra.x86_64          5.10.7-1.el8.elrepo        elrepo-kernel
# kernel-ml-tools.x86_64                  5.10.7-1.el8.elrepo        elrepo-kernel
# kernel-ml-tools-libs.x86_64             5.10.7-1.el8.elrepo        elrepo-kernel
# kernel-ml-tools-libs-devel.x86_64       5.10.7-1.el8.elrepo        elrepo-kernel

sudo yum install -y --disablerepo="*" --enablerepo="elrepo-kernel" kernel-ml

reboot

yum remove kernel
sudo yum swap kernel-headers -- kernel-ml-headers
sudo yum swap kernel-devel kernel-ml-devel
sudo yum swap --allowerasing kernel-modules kernel-ml-modules
sudo yum swap --allowerasing kernel-core kernel-ml-core
sudo yum install --allowerasing kernel-ml-tools-libs kernel-ml-tools-libs-devel
sudo yum install kernel-ml-tools-devel

## Check
rpm -qa | grep "^kernel" | sort


## EOF
