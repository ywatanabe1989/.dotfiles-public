#!/bin/bash

sudo dnf install -y curl policycoreutils openssh-server
sudo systemctl enable sshd
sudo systemctl start sshd
# Check if opening the firewall is needed with: sudo systemctl status firewalld
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo systemctl reload firewalld
￼
## Installs postfix
sudo dnf install -y postfix
sudo systemctl enable postfix
sudo systemctl start postfix
￼
## Installs gitlab
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash

sudo EXTERNAL_URL="https://gitlab.ywatanabe1989.com" dnf install -y gitlab-ee
## EOF

￼
