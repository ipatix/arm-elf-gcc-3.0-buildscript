#!/bin/bash

set -eu

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

BINUTILS_PKG="binutils-2.35.1"
GCC_PKG="gcc-3.0"
PREFIX_DIR="./install"

PREFIX_DIR="$(readlink -f "$PREFIX_DIR")"

mkdir -p "$PREFIX_DIR"

# download binutils 2.35.1
rm -f "$BINUTILS_PKG.tar.xz"
wget "https://ftp.gnu.org/gnu/binutils/$BINUTILS_PKG.tar.xz"
sha256sum --check "$BINUTILS_PKG.sha256"

# download gcc-3.0
rm -f "$GCC_PKG.tar.bz2"
wget "ftp://ftp.fu-berlin.de/unix/languages/gcc/old-releases/gcc-3/$GCC_PKG.tar.bz2"
sha256sum --check "$GCC_PKG.sha256"

# compile binutils
tar -xvf "$BINUTILS_PKG.tar.xz"
mkdir -p "$BINUTILS_PKG/build"
pushd "$BINUTILS_PKG/build"
../configure --target=arm-elf --prefix="$PREFIX_DIR" --disable-werror
make -j$(nproc)
make install
popd
export PATH="$PREFIX_DIR/bin:$PATH"

# compile gcc
tar -xvf "$GCC_PKG.tar.bz2"
patch "$GCC_PKG/gcc/config/arm/arm.c" "gcc-3.0.patch"
mkdir -p "$GCC_PKG/build"
pushd "$GCC_PKG/build"
# TODO remove --disable-multilib
../configure --host=i686-linux-gnu --build=i686-linux-gnu --target=arm-elf --prefix="$PREFIX_DIR" --with-cpu=arm7tdmi --enable-languages=c --disable-multilib --disable-werror
make -j$(nproc)
make install
popd
