#!/bin/bash
set -e -o pipefail -x -u

# 
# Statically compile GDB
#

. ./env

# Install build-time dependencies
sudo apt-get update -y
sudo apt-get install -y zlib1g-dev libreadline-dev

echo "Downloading $NAME version $VERSION ..."

ROOTWD="`pwd`"
SRCWD="$RWD/$NAME-$VERSION"

[ -r "$FILENAME" ] || curl -o "$FILENAME" "$URL"
[ -d "$SRCWD" ] || tar -xf "$FILENAME"

#cd "$NAME-$VERSION"
[ -d "tmp" ] && rm -r tmp
mkdir tmp
cd tmp

#export CXXFLAGS="-fPIC -static"
#export LDFLAGS="-static"

# Strip it down to the essentials
"$SRCWD"/configure --prefix=/usr --enable-static --disable-interprocess-agent --disable-unit-tests --disable-profiling --disable-plugins --disable-gdbmi --disable-curses --disable-tui --disable-gdbtk --disable-ubsan --disable-sim --disable-gdbserver --with-system-zlib --with-system-readline --without-expat --without-lzma --without-mpfr --without-python --without-guile

make -j8 CXXFLAGS="-fPIC -static" all-gdb

# Pack up the static binary
[ -n "$HOSTTYPE" ] || HOSTTYPE="$(uname -m)"
tar -czf "$ROOTWD/$NAME-$VERSION-$HOSTTYPE-static.txz" -C gdb gdb gcore

rm -rf tmp "$SRCWD"
