#!/bin/bash

module load gcc/11.3.0-gcc-8.5.0-lsrw3b6 cuda/11.5.2-gcc-11.3.0-q5c23ej json-fortran/8.3.0-gcc-11.3.0-uhlef7u amdlibflame/3.2-gcc-11.3.0-ly2iy56 openmpi/4.1.4-gcc-11.3.0-dz42ws2 git/2.37.0-gcc-11.3.0-iri7lvp

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PWD/../neko/neko_install/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/.dacecache/ax/build
