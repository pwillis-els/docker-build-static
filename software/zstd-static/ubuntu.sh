#!/bin/bash
set -e -o pipefail -x -u

. ./env

# Install build-time dependencies
sudo apt-get update -y
sudo apt-get install -y liblzma-dev liblz4-dev zlib1g-dev

echo "Downloading $NAME version $VERSION ..."

[ -n "$HOSTTYPE" ] || HOSTTYPE="$(uname -m)"
ROOTWD="`pwd`"
SRCWD="$ROOTWD/$NAME-$VERSION"
INSTALLDIR="$ROOTWD/$NAME-$VERSION-$HOSTTYPE-$BUILDNAME-$BUILDVER/bin"

[ -r "$FILENAME" ] || curl -L -o "$FILENAME" "$URL"
[ -d "$SRCWD" ] || tar -xf "$FILENAME"

cd "$SRCWD"

make -C programs zstd CFLAGS="-O3 -fPIC -g -static"

strip programs/zstd

# Pack up the static binary
mkdir -p "$INSTALLDIR"
cp -f programs/zstd "$INSTALLDIR"/

# Clean up
cd "$ROOTWD"
rm -rf "$SRCWD"
