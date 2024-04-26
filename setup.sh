#!/bin/bash

NEKO_PATH=
JSONFORTRAN_PATH=
DACE_PATH= 

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PWD/$JSONFORTRAN_PATH/lib/pkgconfig
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PWD/$NEKO_PATH/lib/pkgconfig
for i in 1 2 3 4 5 6 7 8 
do
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/src/python/.dacecache/ax${i}/build
done
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/src/python/.dacecache/ax/build
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/src/python/.dacecache/add3s2/build
#export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$PWD/src/python/.dacecache/ax/build

