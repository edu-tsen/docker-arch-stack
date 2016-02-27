# mkimage script for archlinux base image

Generates a minimal arch base image.

Based on [mkimage-arch.sh](https://github.com/docker/docker/blob/master/contrib/mkimage-arch.sh)
with [Arch Linux Archive](https://wiki.archlinux.org/index.php/Arch_Linux_Archive) as snapshot repository
and cleaned up with [localepurge](https://packages.debian.org/source/sid/localepurge).

Current version is 2016-02-26.

[![Archlinux](https://d11xdyzr0div58.cloudfront.net/static/logos/archlinux-logo-dark-scalable.518881f04ca9.svg)](https://www.archlinux.org)


###### TODO
- [ ] Check `NoExtraxt` option in favor of localepurge
