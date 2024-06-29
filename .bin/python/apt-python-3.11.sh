#!/usr/bin/env bash
# Script created on: 2024-06-23 19:45:21
# Script path: /home/ywatanabe/proj/singularity_template/modules/post/python/apt-python3.sh

PYTHON_VERSION=3.11

# Downloads the latest package lists (important).
apt-get update -y

# Add deadsnakes PPA to get specific Python versions
apt-get install -y software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa
apt-get update -y

# Runs apt-get while ensuring that there are no user prompts that would
# cause the build process to hang.
# python3-tk is required by matplotlib.
# python3-dev is needed to require some packages.
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
                               python${PYTHON_VERSION} \
                               python${PYTHON_VERSION}-venv \
                               python${PYTHON_VERSION}-dev \
                               python3-tk \
                               python3-pip

# Reduce the size of the image by deleting the package lists we downloaded,
# which are useless now.
rm -rf /var/lib/apt/lists/*

# Install Pipenv
pip3 install pipenv

# Set up alternatives for python3 and python
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1
update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_VERSION} 1

# Verify Python version
python --version

# EOF
