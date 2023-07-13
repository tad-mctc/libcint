#!/bin/bash

# git clone git@github.com:marvinfriede/libcint.git && cd libcint
# ./autocode.sh
# ./build.sh

DIR="libcint"

if [[ "$(basename "$(pwd)")" == "$DIR" ]]; then
    BUILD_DIR="$PWD/_build"
    if [ ! -d "$BUILD_DIR" ]; then
        mkdir "$BUILD_DIR"
    fi
    cd $BUILD_DIR

    cmake \
        -DCMAKE_INSTALL_PREFIX:PATH=/opt/$DIR \
        -DWITH_F12=OFF \
        -DWITH_FORTRAN=OFF \
        -DWITH_CINT2_INTERFACE=OFF \
        -DPYPZPX=ON \
        ..
    make install
else
    echo "The current directory is not '$DIR'."
    exit 1
fi
