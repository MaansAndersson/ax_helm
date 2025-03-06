#!/usr/bin/env fish

set -x DACE_PATH "$PWD/submodules/dace/dace/runtime/"

#set -x up neko and dep.
set -x NEKO_PATH "submodules/neko/install_neko"
set -x JSONFORTRAN_PATH "submodules/json-fortran/install_jsonfortran"

set -x PKG_CONFIG_PATH "$PKG_CONFIG_PATH:$PWD/$JSONFORTRAN_PATH/lib/pkgconfig"
set -x PKG_CONFIG_PATH "$PKG_CONFIG_PATH:$PWD/$NEKO_PATH/lib/pkgconfig"
set -x LD_LIBRARY_PATH "$LD_LIBRARY_PATH:$PWD/$JSONFORTRAN_PATH/lib"

set -x LD_LIBRARY_PATH "$LD_LIBRARY_PATH:$PWD/src/cpp/lib"
