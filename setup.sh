#!/bin/bash

export DACE_PATH=$PWD/submodules/dace/dace/runtime/ # /home/mansande/Develop/scivenv/lib/python3.12/site-packages/dace/runtime/
export DACE_compiler_cpu_executable=/local/spack/linux-centos8-zen/gcc-8.5.0/gcc-11.3.0-lsrw3b6dbtevo63ogo6xhqdwcofcliio/bin/g++ #usr/bin/clang++

#set up neko and dep.
NEKO_PATH=submodules/neko/install_neko
JSONFORTRAN_PATH=submodules/json-fortran/install_jsonfortran

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PWD/$JSONFORTRAN_PATH/lib/pkgconfig
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PWD/$NEKO_PATH/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/$JSONFORTRAN_PATH/lib

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/src/cpp/lib
