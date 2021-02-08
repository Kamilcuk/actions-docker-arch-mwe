#!/bin/bash
set -xeuo pipefail

if [ ! -e /.dockerenv ]; then echo "error: this script is meant to be in docker" >&2; exit 2; fi

username=builder
user_uid=1000
user_gid=1000

pacman-key --init
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
pacman --noconfirm --needed -Syyu base-devel git go

sed -i -e 's/if (( EUID == 0 )); then/if false; then/' /usr/bin/makepkg

work() {
	stat /etc/makepkg.conf ||:
	wc /etc/makepkg.conf ||:
	cd ~
	git clone --depth 1 https://aur.archlinux.org/yay.git
	cd yay
	makepkg --noprogressbar --noconfirm -si
	yay -Syyu --removemake --noprogressbar --noconfirm --needed cowsay archivemount
	cowsay "Hello, World!"
}
work
