#!/bin/bash
set -e -o pipefail

if [ $# -lt 2 ] ; then
    echo "Usage: $0 OS SOFTWARE [ARGS ..]"
    echo ""
    echo "Run \$OS-build:latest Docker container, volume-mapping ./software/\$SOFTWARE/ to /build."
    echo "Passes any ARGS on to the container to run."
    echo ""
    echo "OSes:"
    for f in ./Dockerfiles/Dockerfile.* ; do B=`basename $f`; echo "  $B" | sed -e 's/Dockerfile\.//' ; done
    echo ""
    echo "Software:"
    echo -n "  " ; ls ./software/
    exit 1
fi

OS="$1"; shift
sw="$1"; shift

set -x

docker run \
    --rm -it \
    -u `id -u` \
    -v "`pwd`/software/$sw":/build \
    -w /build \
    "$OS-build:latest" \
    "$@"
