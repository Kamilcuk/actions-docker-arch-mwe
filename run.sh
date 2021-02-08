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

groupadd --gid $user_gid $username
useradd -mrs /bin/bash --uid $user_uid --gid $user_gid $username
echo "$username ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$username
chmod 0440 /etc/sudoers.d/$username

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
sudo -u builder bash -s <<EOF
set -xeuo pipefail
$(declare -f work)
work
EOF

