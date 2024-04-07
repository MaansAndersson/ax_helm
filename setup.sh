#!/bin/bash

module load gcc/11.3.0-gcc-8.5.0-lsrw3b6 json-fortran/8.3.0-gcc-11.3.0-uhlef7u amdlibflame/3.2-gcc-11.3.0-ly2iy56 openmpi/4.1.4-gcc-11.3.0-dz42ws2 git/2.37.0-gcc-11.3.0-iri7lvp

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PWD/../../Plasma-PEPSC/neko_nekobench/neko_install/lib/pkgconfig
for i in 1 2 3 4 5 6 7 8 
do
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/src/python/.dacecache/ax${i}/build
done
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/src/python/.dacecache/ax/build
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/src/python/.dacecache/add3s2/build
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$PWD/src/python/.dacecache/ax/build

