#!/bin/sh
set -eux

USER="builder"

if command -v groupadd 2>/dev/null 1>/dev/null ; then

    groupadd -g ${BUILDER_GID} $USER \
    && useradd -ms /bin/bash -u ${BUILDER_UID} -g $USER $USER \
    && usermod -aG sudo $USER \
    && [ -d /etc/sudoers.d ] || mkdir -p /etc/sudoers.d/ \
    && echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USER

elif command -v addgroup 2>/dev/null 1>/dev/null; then

    addgroup -g ${BUILDER_GID} $USER \
    && adduser -D -h /home/$USER -s /bin/bash -u ${BUILDER_UID} -G $USER $USER \
    && adduser $USER wheel \
    && [ -d /etc/sudoers.d ] || mkdir -p /etc/sudoers.d/ \
    && echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USER

fi

chown $USER /build

sudo -u $USER "$@"
