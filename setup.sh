#!/bin/bash

###module load "whatever"

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PWD/../neko/installation_folder/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/src/python/.dacecache/ax/build
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$PWD/src/python/.dacecache/ax/build

