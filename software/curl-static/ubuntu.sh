#!/bin/bash
set -e -o pipefail -x -u

# 
# Statically compile GDB
#

. ./env

# Install build-time dependencies
#sudo apt-get update -y
#sudo apt-get install -y libc-ares-dev libwolfssl-dev
sudo apt-get install -y libc-ares-dev libssl-dev
#sudo apt-get install -y libc-ares-dev libgnutls28-dev

echo "Downloading $NAME version $VERSION ..."

ROOTWD="`pwd`"
SRCWD="$ROOTWD/$NAME-$VERSION"

[ -r "$FILENAME" ] || curl -o "$FILENAME" "$URL"
[ -d "$SRCWD" ] || tar -xf "$FILENAME"

[ -d "tmp" ] && rm -r tmp
mkdir tmp
cd tmp

#export CXXFLAGS="-fPIC -static"
#export LDFLAGS="-static"

# Strip it down to the essentials.
# Disable pthreads as it's causing linker problems
#"$SRCWD"/configure --prefix=/usr --disable-shared --enable-static --disable-pthreads --disable-threaded-resolver -disable-ldap --disable-sspi --without-librtmp --disable-ftp --disable-dict --disable-telnet --disable-tftp --disable-rtsp --disable-pop3 --disable-imap --disable-smtp --disable-gopher --disable-smb --without-libidn --enable-ares \
#	--with-ssl --with-schannel --with-secure-transport
#	--with-wolfssl --with-schannel --with-secure-transport

#"$SRCWD"/configure --prefix=/usr --with-ca-fallback --without-ssl --with-gnutls
"$SRCWD"/configure --prefix=/usr --with-ca-fallback --with-ssl --without-gnutls --without-wolfssl


# Fix a bad build process
sed -i -e 's?<wolfssl/options\.h>?"../../projects/wolfssl_options.h"?g' $SRCWD/lib/vtls/wolfssl.c
sed -i -e 's?^.*define.*WOLFSSL_ALLOW_SSLV3??g' $SRCWD/projects/wolfssl_options.h

#make -j8 CFLAGS="-O2 -fPIC"
#rm -f src/curl
#make -j8 CFLAGS="-O2 -fPIC -all-static"
make -j8 curl_LDFLAGS=-all-static

# Pack up the static binary
[ -n "$HOSTTYPE" ] || HOSTTYPE="$(uname -m)"
tar -czf "$ROOTWD/$NAME-$VERSION-$HOSTTYPE-static.txz" -C src curl

# Clean up
cd "$ROOTWD"
rm -rf tmp "$SRCWD"
