#!/bin/bash
set -e -o pipefail -x -u

# 
# Statically compile bash 3
#

. ./env

# Install build-time dependencies
#sudo apt-get update -y
sudo apt-get install -y bison

echo "Downloading $NAME version $VERSION ..."

ROOTWD="`pwd`"
SRCWD="$ROOTWD/$NAME-$VERSION"

[ -r "$FILENAME" ] || curl -o "$FILENAME" "$URL"
[ -d "$SRCWD" ] || tar -xf "$FILENAME"

[ -d "tmp" ] && rm -r tmp
mkdir tmp
cd tmp

"$SRCWD"/configure --prefix=/usr --disable-shared --enable-static

make -j8 CFLAGS="-O2 -fPIC -static"
strip "$NAME"

cd ..

# Pack up the static binary
[ -n "$HOSTTYPE" ] || HOSTTYPE="$(uname -m)"
tar -czf "$ROOTWD/$NAME-$VERSION-$HOSTTYPE-$BUILDNAME-$BUILDVER.txz" -C tmp "$NAME"

# Clean up
cd "$ROOTWD"
rm -rf tmp "$SRCWD"
