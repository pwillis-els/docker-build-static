#!/bin/bash
set -e -o pipefail

if [ $# -lt 2 ] ; then
    echo "Usage: $0 OS SOFTWARE [..]"
    echo ""
    echo "Build \$SOFTWARE (from ./software/*/) using Dockerfiles/Dockerfile.\$OS"
    echo ""
    echo "OSes:"
    for f in ./Dockerfiles/Dockerfile.* ; do B=`basename $f`; echo "  $B" | sed -e 's/Dockerfile\.//' ; done
    echo ""
    echo "Software:"
    echo -n "  " ; ls ./software/
    exit 1
fi

OS="$1"; shift

set -x

docker build -t "$OS-build:latest" -f "./Dockerfiles/Dockerfile.$OS" ./Dockerfiles/

for sw in "$@" ; do
    docker run \
        --rm \
        -u `id -u` \
        -v "`pwd`/software/$sw":/build \
        "$OS-build:latest" \
        /bin/bash -c "cd /build && ./build.sh"
done
