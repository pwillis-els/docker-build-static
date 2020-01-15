#!/bin/bash
set -e -o pipefail -x -u

. ./env

sudo apk add -U -u openssl-dev openssl-libs-static

GPG_KEY_URL="https://daniel.haxx.se/mykey.asc"
GPG_KEY_PATH="/tmp/curl-gpg.pub"

#trap 'RC="\$?"; echo "***FAILED! RC=\${RC}"; exit \${RC}' EXIT

[ -e "$GPG_KEY_PATH" ] || curl -o $GPG_KEY_PATH "${GPG_KEY_URL}"
[ -e "$FILENAME".asc ] || curl -o "$FILENAME".asc "$URL".asc
[ -e "$FILENAME" ] || curl -o $FILENAME $URL

gpg --import --always-trust ${GPG_KEY_PATH}
gpg --verify "$FILENAME".asc "$FILENAME"

ROOTWD="$(pwd)"
SRCWD="$ROOTWD/$NAME-$VERSION"

[ -d "$FILENAME" ] || tar -xf $FILENAME
[ -d "tmp" ] && rm -rf tmp
mkdir tmp
cd tmp

"$SRCWD"/configure --disable-shared --with-ca-fallback

make curl_LDFLAGS=-all-static

strip src/curl

# Pack up the static binary
[ -n "$HOSTTYPE" ] || HOSTTYPE="$(uname -m)"
tar -czf "$ROOTWD/$NAME-$VERSION-$HOSTTYPE-$BUILDNAME-$BUILDVER.txz" -C src curl

# Clean up
cd "$ROOTWD"
rm -rf tmp "$SRCWD"

#trap - EXIT
