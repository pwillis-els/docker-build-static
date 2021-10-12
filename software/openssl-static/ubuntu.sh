#!/bin/bash
set -e -o pipefail -x -u

. ./env

# Install build-time dependencies
#sudo apt-get update -y
#sudo apt-get install -y zlib1g-dev libreadline-dev

echo "Downloading $NAME version $VERSION ..."

[ -n "$HOSTTYPE" ] || HOSTTYPE="$(uname -m)"
ROOTWD="`pwd`"
SRCWD="$ROOTWD/$NAME-$VERSION"
INSTALLDIR="$ROOTWD/$NAME-$VERSION-$HOSTTYPE-$BUILDNAME-$BUILDVER/bin"

[ -r "$FILENAME" ] || curl -L -o "$FILENAME" "$URL"
[ -d "$SRCWD" ] || tar -xf "$FILENAME"

cd "$SRCWD"

# Strip it down to the essentials.
# Disable pthreads as it's causing linker problems
"$SRCWD"/config

make CFLAG="-O2 -fPIC -g -static"

strip apps/openssl

# Pack up the static binary
mkdir -p "$INSTALLDIR"
cp -f apps/openssl "$INSTALLDIR"/

# Clean up
cd "$ROOTWD"
rm -rf "$SRCWD"
