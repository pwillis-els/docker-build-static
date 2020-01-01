#!/bin/bash
set -e -o pipefail -x -u

. ./env

sudo apt-get install -y git

[ -d "$NAME" ] || git clone $URL

ROOTWD="$(pwd)"
SRCWD="$ROOTWD/$NAME"

cd "$SRCWD"

VERSION=$(grep '^Version:' jattach.spec | cut -d : -f 2 | xargs)

make CFLAGS="-O2 -fPIC -static"

tar -czf "$ROOTWD/$NAME-$VERSION-$HOSTTYPE-static.txz" -C build jattach

cd "$ROOTWD"
rm -r "$NAME"
