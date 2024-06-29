#!/bin/bash

## LibKlustersShared
sudo yum install qt4 # @getpagespeed
sudo yum install qt-devel # @getpagespeed
sudo yum install qt-webkit # @getpagespeed
sudo yum install qt-webkit-devel # @getpagespeed      

cmake -DENFORCE_QT4_BUILD=ON .
make
sudo make install # libklustersshared.so is installed in /usr/local/lib
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH # or ldconfig for the dynamic library

## NdManager
cmake -DENFORCE_QT4_BUILD=ON .
mv config-ndmanager.h src
make
sudo make install

## EOF
