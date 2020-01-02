#!/bin/bash
set -e -o pipefail -x -u

. ./env

GPG_KEY_URL="https://daniel.haxx.se/mykey.asc"
GPG_KEY_PATH="/out/curl-gpg.pub"

##Print failure message we exit unexpectedly
#trap 'RC="\$?"; echo "***FAILED! RC=\${RC}"; exit \${RC}' EXIT

[ -e "$GPG_KEY_PATH" ] || curl -o $GPG_KEY_PATH "${GPG_KEY_URL}"
[ -e "$FILENAME".asc ] || curl -o "$FILENAME".asc "$URL".asc
[ -e "$FILENAME" ] || curl -o $FILENAME $URL

gpg --import --always-trust ${GPG_KEY_PATH}
gpg --verify \${TARBALL_PATH}.asc \${TARBALL_PATH}

ROOTWD="$(pwd)"
SRCWD="$ROOTWD/$NAME-$VERSION"

[ -d "$FILENAME" ] || tar -xf $FILENAME
[ -d "tmp" ] && rm -rf tmp
mkdir tmp
cd tmp

apk add openssl-dev openssl-libs-static

"$SRCWD"/configure --disable-shared --with-ca-fallback

make curl_LDFLAGS=-all-static


#Clear the trap so when we exit there is no failure message
#trap - EXIT
#echo SUCCESS
