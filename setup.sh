#!/bin/bash

###module load "whatever"

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PWD/../neko_nekobench/neko_install/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/src/python/.dacecache/ax/build
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/src/python/.dacecache/add3s2/build
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$PWD/src/python/.dacecache/ax/build

