#!/bin/bash

sudo sh -c "echo `whoami`:100000:65536 >> /etc/subuid"
sudo sh -c "echo `whoami`:100000:65536 >> /etc/subgid"

## EOF
