#!/bin/sh

## Installing Python3
sudo yum install python3 python3-devel python3-pip

# ## Installing Virtualenv
# cd /tmp
# wget https://bootstrap.pypa.io/get-pip.py
# python3 get-pip.py --user
# pip install virtualenv --user


## Parameters
ENVS_DIR=$HOME/envs
NEW_ENV_NAME=py3


## Make the Python Environment
mkdir $ENVS_DIR
NEW_ENV_PATH=${ENVS_DIR}/${NEW_ENV_NAME}
python3 -m venv $NEW_ENV_PATH

## Activate and Deactivate
source $NEW_ENV_PATH/bin/activate # Activate the Created Environment
pip install pip --upgrade ## pip upgrade
deactivate # Deactivate the Environment

## Aliasing
echo "men3='source $HOME/envs/py3/bin/activate'" >> ~/.bashrc
echo "men3" command  enables the created python3 environment.
