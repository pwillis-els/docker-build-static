#!/bin/bash
set -e -o pipefail -x -u

# 
# Statically compile zstd
#

. ./env

# Install build-time dependencies
sudo apt-get update -y
sudo apt-get install -y liblzma-dev liblz4-dev zlib1g-dev

echo "Downloading $NAME version $VERSION ..."

ROOTWD="`pwd`"
SRCWD="$ROOTWD/$NAME-$VERSION"

[ -r "$FILENAME" ] || curl -L -o "$FILENAME" "$URL"
[ -d "$SRCWD" ] || tar -xf "$FILENAME"

cd "$SRCWD"

make -C programs zstd CFLAGS="-O3 -fPIC -g -static"

strip programs/zstd

# Pack up the static binary
[ -n "$HOSTTYPE" ] || HOSTTYPE="$(uname -m)"
tar -czf "$ROOTWD/$NAME-$VERSION-$HOSTTYPE-$BUILDNAME-$BUILDVER.txz" -C programs zstd

# Clean up
cd "$ROOTWD"
rm -rf "$SRCWD"
