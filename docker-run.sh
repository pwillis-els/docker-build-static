#!/bin/bash
set -e -o pipefail

_list_sw () {
    for f in Dockerfiles/Dockerfile.* ; do 
        OS="$(basename "$f" | sed -e 's/^.*\.//')"
        echo -en "OS $OS:\n\tSOFTWARE: "
        for s in software/*/$OS.sh ; do echo $(basename $(dirname $s)) ; done | xargs
    done
}

if [ $# -lt 2 ] ; then
    echo "Usage: $0 OS SOFTWARE [ARGS ..]"
    echo ""
    echo "Runs a container OS-build:latest , volume-mapping in ./software/SOFTWARE, and passes in"
    echo "any extra ARGS passed."
    echo ""
    _list_sw
    exit 1
fi

OS="$1"; shift
sw="$1"; shift

set -x

docker run \
    --rm -it \
    -v "$(pwd)/software/$sw":/build \
    -e BUILDER_UID=$(id -u) -e BUILDER_GID=$(id -g) \
    -w /build \
    "$OS-build:latest" \
    "$@"
