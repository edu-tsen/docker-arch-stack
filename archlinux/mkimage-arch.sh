#!/usr/bin/env bash
# Generate a minimal filesystem for archlinux and load it into the local
# docker as "archlinux"
# requires root
set -e

hash pacstrap &>/dev/null || {
	echo "Could not find pacstrap. Run pacman -S arch-install-scripts"
	exit 1
}

hash expect &>/dev/null || {
	echo "Could not find expect. Run pacman -S expect"
	exit 1
}

export LANG="C.UTF-8"

ROOTFS=$(mktemp -d ${TMPDIR:-/var/tmp}/rootfs-archlinux-XXXXXXXXXX)
chmod 755 $ROOTFS

SNAPSHOT="2016-02-26"

PACMAN_CONF='./pacman.conf'
PACMAN_MIRRORLIST='Server = https://archive.archlinux.org/repos/'${SNAPSHOT//-//}'/$repo/os/$arch'
PACMAN_EXTRA_PKGS=''
EXPECT_TIMEOUT=60
ARCH_KEYRING=archlinux
DOCKER_IMAGE_NAME="archlinux:$SNAPSHOT"

(cat <<-EOF
	[options]
	HoldPkg     = pacman glibc
	Architecture = x86_64
	SigLevel    = Required DatabaseOptional
	LocalFileSigLevel = Optional

	NoExtract = usr/lib/systemd/system/*
	NoExtract = usr/share/doc/*
	NoExtract = usr/share/locale/* !usr/share/locale/en_US !usr/share/locale/locale.alias
	NoExtract = usr/share/info/*
	NoExtract = usr/share/man/*
	NoExtract = /usr/share/perl5/core_perl/pod/*/usr/share/perl5/core_perl/pod/*

	IgnorePkg = cryptsetup
	IgnorePkg = device-mapper
	IgnorePkg = dhcpcd
	IgnorePkg = iproute2
	IgnorePkg = jfsutils
	IgnorePkg = linux
	IgnorePkg = lvm2
	IgnorePkg = man-db
	IgnorePkg = man-pages
	IgnorePkg = mdadm
	IgnorePkg = nano
	IgnorePkg = netctl
	IgnorePkg = openresolv
	IgnorePkg = pciutils
	IgnorePkg = pcmciautils
	IgnorePkg = reiserfsprogs
	IgnorePkg = s-nail
	IgnorePkg = systemd-sysvcompat
	IgnorePkg = usbutils
	IgnorePkg = vi
	IgnorePkg = xfsprogs

	[core]
	$PACMAN_MIRRORLIST

	[extra]
	$PACMAN_MIRRORLIST

	[community]
	$PACMAN_MIRRORLIST
EOF
) > $PACMAN_CONF

export PACMAN_MIRRORLIST

expect <<EOF
	set send_slow {1 .1}
	proc send {ignore arg} {
		sleep .1
		exp_send -s -- \$arg
	}
	set timeout $EXPECT_TIMEOUT

	spawn pacstrap -C $PACMAN_CONF -c -d -G -i $ROOTFS base haveged $PACMAN_EXTRA_PKGS
	expect {
		-exact "anyway? \[Y/n\] " { send -- "n\r"; exp_continue }
		-exact "(default=all): " { send -- "\r"; exp_continue }
		-exact "installation? \[Y/n\]" { send -- "y\r"; exp_continue }
	}
EOF

arch-chroot $ROOTFS /bin/sh -c "haveged -w 1024; pacman-key --init; pkill haveged; pacman -Rs --noconfirm haveged; pacman-key --populate $ARCH_KEYRING; pkill gpg-agent"
arch-chroot $ROOTFS /bin/sh -c "ln -s /usr/share/zoneinfo/UTC /etc/localtime"
echo 'en_US.UTF-8 UTF-8' > $ROOTFS/etc/locale.gen
arch-chroot $ROOTFS locale-gen
arch-chroot $ROOTFS /bin/sh -c 'echo $PACMAN_MIRRORLIST > /etc/pacman.d/mirrorlist'

sed '/^IgnorePkg/d' $PACMAN_CONF > $ROOTFS/etc/pacman.conf
rm -f $PACMAN_CONF

arch-chroot $ROOTFS /bin/sh -c 'pacman -Scc --noconfirm'

# udev doesn't work in containers, rebuild /dev
DEV=$ROOTFS/dev
rm -rf $DEV
mkdir -p $DEV
mknod -m 666 $DEV/null c 1 3
mknod -m 666 $DEV/zero c 1 5
mknod -m 666 $DEV/random c 1 8
mknod -m 666 $DEV/urandom c 1 9
mkdir -m 755 $DEV/pts
mkdir -m 1777 $DEV/shm
mknod -m 666 $DEV/tty c 5 0
mknod -m 600 $DEV/console c 5 1
mknod -m 666 $DEV/tty0 c 4 0
mknod -m 666 $DEV/full c 1 7
mknod -m 600 $DEV/initctl p
mknod -m 666 $DEV/ptmx c 5 2
ln -sf /proc/self/fd $DEV/fd

tar --numeric-owner --xattrs --acls -C $ROOTFS -c . | docker import - $DOCKER_IMAGE_NAME
docker run --rm -t $DOCKER_IMAGE_NAME echo Success.
rm -rf $ROOTFS
