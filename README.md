# About

This repository makes it easy to compile software inside a Docker container. Most of the software builds are designed to build a statically-compiled binary.

## Usage
 - To build software in an Ubuntu container, run:
   ```bash
   $ ./docker-build.sh ubuntu jattach-static
   ```
 - To drop into a container to debug a build, run:
   ```bash
   $ ./docker-run.sh ubuntu jattach-static
   ```

## Files

### Dockerfiles/
 - This directory contains OS-specific Dockerfiles. These should prepare a Docker container with all necessary build software, and copy the files `env` and `build.sh` into a new volume `/build`, then execute `build.sh`. The compiled software can then be extracted from the volume later.

### software/
 - This directory contains sub-directories, which are software to be built inside the Docker container.
 - Each directory contains an OS-specific shell script which will build the software.

### docker-build.sh
 - The wrapper script which builds a Docker container, then runs build scripts for the software inside it.

### docker-run.sh
 - The wrapper script that runs a Docker container.
