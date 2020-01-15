#!/bin/bash
# github-release-tag.sh - release an already-created tag to GitHub
set -e -o pipefail -u
[ "${DEBUG:-}" = "1" ] && set -x

[ -n "${GITHUB_TOKEN:-}" ] || GITHUB_TOKEN=$(cat ~/.github-token)
[ -n "${GITHUB_USER:-}" ] || GITHUB_USER="pwillis-els"
[ -n "${GITHUB_REPO:-}" ] || GITHUB_REPO="docker-build-static"
export GITHUB_TOKEN GITHUB_USER GITHUB_REPO

if [ $# -ne 1 ] ; then
    echo "Usage: $0 TAG"
    echo ""
    echo "Creates a GitHub release based on TAG. Uses the message from the annotated tag for the release message."
    exit 1
fi
export TAG="$1"; shift

if [ ! "$(git cat-file -t $TAG)" = "tag" ] ; then
    echo "$0: Error: tag $TAG was not an annotated tag"
    exit 1
fi

# Make sure the tag is there before we do a release
git push --tags

#gothub delete \
#    -u "$GITHUB_USER" \
#    -r "$GITHUB_REPO" \
#    -t "$TAG"

tag_msg="$(git tag -n999 -l "$TAG")"
if [ -z "$tag_msg" ] ; then
    echo "$0: Error: there was no message along with the annotated tag"
    exit 1
fi

if gothub info -u "$GITHUB_USER" -r "$GITHUB_REPO" -t "$TAG" ; then
    echo "$0: INFO: Release already exists, but we'll try to upload files anyway"
else

    gothub release \
        --pre-release \
        -u "$GITHUB_USER" \
        -r "$GITHUB_REPO" \
        -t "$TAG" \
        -d "$tag_msg"
fi

for file in software/*/*-static-*/bin/* ; do
    filename="$(basename "$file")"
    echo "$0: INFO: Uploading file '$file' ..."
    gothub upload \
        -u "$GITHUB_USER" \
        -r "$GITHUB_REPO" \
        -t "$TAG" \
        -n "$filename" \
        -f "$file" \
        -R
done

