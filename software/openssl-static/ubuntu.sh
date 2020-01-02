#!/bin/bash
set -e -o pipefail -x -u

# 
# Statically compile OpenSSL
#

. ./env

# Install build-time dependencies
#sudo apt-get update -y
#sudo apt-get install -y zlib1g-dev libreadline-dev

echo "Downloading $NAME version $VERSION ..."

ROOTWD="`pwd`"
SRCWD="$ROOTWD/$NAME-$VERSION"

[ -r "$FILENAME" ] || curl -o "$FILENAME" "$URL"
[ -d "$SRCWD" ] || tar -xf "$FILENAME"

cd "$SRCWD"

# Strip it down to the essentials.
# Disable pthreads as it's causing linker problems
"$SRCWD"/config

make CFLAG="-O2 -fPIC -g -static"

# Pack up the static binary
[ -n "$HOSTTYPE" ] || HOSTTYPE="$(uname -m)"
tar -czf "$ROOTWD/$NAME-$VERSION-$HOSTTYPE-static.txz" -C apps openssl

# Clean up
cd "$ROOTWD"
rm -rf "$SRCWD"
