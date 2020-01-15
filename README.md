# About

This repository makes it easy to compile software into a static binary. It uses a Dockerfile for the base OS, and then runs a script to compile the app as a static binary in that OS, and archives it in a tarball.

## Usage
 - To see what OSes and software are available, run `./docker-build.sh` or `./docker-run.sh` with no options.

 - To build software in an Ubuntu container, run:
   ```bash
   $ ./docker-build.sh ubuntu jattach-static
   ```
 - The compiled binary will be put in a compressed tarball in the target software directory:
   ```bash
   $ tar -tvf software/jattach-static/jattach-1.5-x86_64-static.txz
   -rwxr-xr-x ubuntu/ubuntu 855312 2020-01-01 18:05 jattach
   ```
 - If you have a problem with a build, you can drop into a container to debug it:
   ```bash
   $ ./docker-run.sh ubuntu jattach-static
   ```

## Files

### `docker-build.sh`
The wrapper script which builds a Docker container, then runs build scripts for the software inside it.

This script will build a Docker container based on a Dockerfile specific to the OS selected. Then it will run an OS-specific build script, in the target directory of the software to build.

### `docker-run.sh`
The wrapper script that runs a Docker container.

This script will run the previously-built Docker container, volume-map in the target software directory, and change the Docker user to your current user id, so that reading & writing files will not have conflicting file permissions.

### `Dockerfiles/`
This directory contains OS-specific Dockerfiles.

These should prepare a Docker container with all necessary build software, and copy the files `env` and `build.sh` into a new volume `/build`, then execute `build.sh`. The compiled software can then be extracted from the volume later.

### `software/`
This directory contains sub-directories, which are software to be built inside the Docker container.

Each directory contains an OS-specific shell script which will build the software.
