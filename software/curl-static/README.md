# About

Builds a static binary of `curl`.

# Notes
 - Often when you statically build the `curl` app, running `file curl` will show it is dynamically linked. But when you run `ldd curl`, it says it's statically linked. So I'm just going to assume it's actually statically linked, and figure out that weirdness later.
   ```bash
   vagrant@vagrant:~/git/docker-build-static/software/curl-static (master)$ file curl
   curl: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, stripped
   vagrant@vagrant:~/git/docker-build-static/software/curl-static (master)$ ldd curl
           statically linked
   ```

 - The Alpine build is working (it seems).

 - The Ubuntu build is probably broken right now. (#FIXME)

