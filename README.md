# About

This repository makes it easy to compile software inside a Docker container.

## Files

### Dockerfiles/
 - This directory contains OS-specific Dockerfiles. These should prepare a Docker container with all necessary build software, and copy the files `env` and `build.sh` into a new volume `/build`, then execute `build.sh`. The compiled software can then be extracted from the volume later.

### software/
 - This directory contains sub-directories, which are software to be built inside the Docker container.

### docker-build.sh
 - The wrapper script which builds a Docker container, then runs build scripts for the software inside it.
