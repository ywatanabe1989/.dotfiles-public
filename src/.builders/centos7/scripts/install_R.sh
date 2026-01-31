#!/bin/sh

## Pure R
sudo dnf -y config-manager --set-enabled PowerTools
sudo dnf -y install -y epel-release
sudo dnf -y install -y R R-core-devel

## R Studio, fixme


## EOF
