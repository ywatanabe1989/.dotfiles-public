#!/bin/bash

# https://sylabs.io/guides/3.8/user-guide/quick_start.html

sudo apt-get update && sudo apt-get install -y \
    build-essential \
    libssl-dev \
    uuid-dev \
    libgpgme11-dev \
    squashfs-tools \
    libseccomp-dev \
    wget \
    pkg-config \
    git \
    cryptsetup


## Install Go language
# rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.1.linux-amd64.tar.gz
# export PATH=$PATH:/usr/local/go/bin
# sudo apt install -y golang-go  # version 2:1.13~1ubuntu2
# go version
export VERSION=1.18.1 OS=linux ARCH=amd64 && \
    wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && \
    sudo tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz && \
    rm go$VERSION.$OS-$ARCH.tar.gz
export PATH=/usr/local/go/bin:$PATH
go version

## Download SingularityCE from a release
export VERSION=3.10.0 && # adjust this as necessary \
    wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-ce-${VERSION}.tar.gz && \
    tar -xzf singularity-ce-${VERSION}.tar.gz && \
    cd singularity-ce-${VERSION}


## Compile and Install it
./mconfig && \
    make -C builddir && \
    sudo make -C builddir install

singularity --version
## EOF
