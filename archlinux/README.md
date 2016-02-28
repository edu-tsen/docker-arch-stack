# mkimage script for archlinux base image

Generates a minimal arch base image.

Following adaptions were made on [mkimage-arch.sh](https://github.com/docker/docker/blob/master/contrib/mkimage-arch.sh):
* Use [Arch Linux Archive](https://wiki.archlinux.org/index.php/Arch_Linux_Archive) as snapshot repository
* ```NoExtract``` systemd units and non-english messages
* Clean pacman cache (```pacman -Scc```)

Current snapshot version is 2016-02-26.

[![Archlinux](https://d11xdyzr0div58.cloudfront.net/static/logos/archlinux-logo-dark-scalable.518881f04ca9.svg)](https://www.archlinux.org)
