#!/bin/bash
set -e -o pipefail -x -u

. ./env

sudo apt-get install -y git

[ -d "$NAME" ] || git clone $URL

[ -n "$HOSTTYPE" ] || HOSTTYPE="$(uname -m)"
ROOTWD="$(pwd)"
SRCWD="$ROOTWD/$NAME"
INSTALLDIR="$ROOTWD/$NAME-$VERSION-$HOSTTYPE-$BUILDNAME-$BUILDVER/bin"

cd "$SRCWD"
# VERSION=1.5_abcdef
sha=$(echo "$VERSION" | cut -d _ -f 2)
git checkout "$sha"

#VERSION=$(grep '^Version:' jattach.spec | cut -d : -f 2 | xargs)

make CFLAGS="-O2 -fPIC -static" JATTACH_VERSION="$VERSION"

strip build/jattach

# Pack up the static binary
mkdir -p "$INSTALLDIR"
cp -f build/jattach "$INSTALLDIR"/

cd "$ROOTWD"
rm -rf "$NAME"
