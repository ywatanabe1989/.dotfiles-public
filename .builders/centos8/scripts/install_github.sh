#!/bin/bash

sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install -y gh
sudo dnf update -y gh

## EOF
