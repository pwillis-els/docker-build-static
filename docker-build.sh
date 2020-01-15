#!/bin/bash
set -e -o pipefail

_list_sw () {
    for f in Dockerfiles/Dockerfile.* ; do 
        OS=`basename "$f" | sed -e 's/^.*\.//'`
        echo -en "OS $OS:\n\tSOFTWARE: "
        for s in software/*/$OS.sh ; do echo $(basename $(dirname $s)) ; done | xargs
    done
}

if [ $# -lt 2 ] ; then
    echo "Usage: $0 OS SOFTWARE [..]"
    echo ""
    echo "Builds ./Dockerfiles/Dockerfile.OS and uses its container to run ./software/SOFTWARE/OS.sh"
    echo ""
    _list_sw
    exit 1
fi

OS="$1"; shift
if [ ! -r "./Dockerfiles/Dockerfile.$OS" ] ; then
    echo "$0: Error: './Dockerfiles/Dockerfile.$OS' does not exist"
    exit 1
fi

set -x

docker build -t "$OS-build:latest" -f "./Dockerfiles/Dockerfile.$OS" ./Dockerfiles/

for sw in "$@" ; do
    if [ -x "./software/$sw/$OS.sh" ] ; then
        ./docker-run.sh "$OS" "$sw" /bin/bash -c "cd /build && ./$OS.sh"
    else
        echo "$0: Error: could not find './software/$sw/$OS.sh"
        exit 1
    fi
done
