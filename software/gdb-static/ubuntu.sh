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
SRCWD="$ROOTWD/$NAME-$VERSION"

[ -r "$FILENAME" ] || curl -o "$FILENAME" "$URL"
[ -d "$SRCWD" ] || tar -xf "$FILENAME"

#cd "$NAME-$VERSION"
[ -d "tmp" ] && rm -r tmp
mkdir tmp
cd tmp

#export CXXFLAGS="-fPIC -static"
#export LDFLAGS="-static"

# Strip it down to the essentials.
# You can add --disable-gdbserver to skip a potentially problematic set of tools
# (they won't finish building properly due to NSS library use for network calls)
"$SRCWD"/configure --prefix=/usr --enable-static --disable-interprocess-agent --disable-inprocess-agent --disable-unit-tests --disable-profiling --disable-plugins --disable-gdbmi --disable-curses --disable-tui --disable-gdbtk --disable-ubsan --disable-sim --disable-gdbserver --with-system-zlib --with-system-readline --without-expat --without-lzma --without-mpfr --without-python --without-guile

make -j8 CXXFLAGS="-fPIC -static" all-gdb

strip gdb/gdb

# Pack up the static binary
[ -n "$HOSTTYPE" ] || HOSTTYPE="$(uname -m)"
tar -czf "$ROOTWD/$NAME-$VERSION-$HOSTTYPE-$BUILDNAME-$BUILDVER.txz" -C gdb gdb gcore gdbserver/gdbserver gdbserver/gdbreplay

# Clean up
cd "$ROOTWD"
rm -rf tmp "$SRCWD"
