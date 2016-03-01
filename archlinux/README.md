# mkimage script for archlinux base image

Generates a minimal arch base image.

[![Archlinux](https://upload.wikimedia.org/wikipedia/en/thumb/a/ac/Archlinux-official-fullcolour.svg/320px-Archlinux-official-fullcolour.svg.png)](https://www.archlinux.org)

Following adaptions were made on [mkimage-arch.sh](https://github.com/docker/docker/blob/master/contrib/mkimage-arch.sh):
* Use [Arch Linux Archive](https://wiki.archlinux.org/index.php/Arch_Linux_Archive) as snapshot repository
* Generate `pacman.conf` on-the-fly.
* `NoExtract` systemd units, docs and non-english messages
* Clean pacman cache `pacman -Scc`
* No `arm` support

Current snapshot version is 2016-02-26

#### How to use this script

On an archlinux system run `mkimage-arch.sh` as `root`
