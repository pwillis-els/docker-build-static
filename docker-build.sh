#!/bin/bash
set -e -o pipefail

if [ $# -lt 2 ] ; then
    echo "Usage: $0 OS SOFTWARE [..]"
    echo ""
    echo "Build \$SOFTWARE (from ./software/*/) using Dockerfiles/Dockerfile.\$OS"
    echo "Runs $OS.sh inside /build in the $OS container."
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
    ./docker-run.sh "$OS" "$sw" \
        /bin/bash -c "cd /build && ./$OS.sh"
done
