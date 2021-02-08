#!/bin/bash
#set -euo pipefail
set -x

exec 2>&1

if [ ! -e /.dockerenv ]; then echo "error: this script is meant to be in docker" >&2; exit 2; fi

username=builder
user_uid=1000
user_gid=1000

pacman-key --init
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
pacman --noconfirm --needed -Syyu base-devel git go strace

groupadd --gid $user_gid $username
useradd -mrs /bin/bash --uid $user_uid --gid $user_gid $username
echo "$username ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$username
chmod 0440 /etc/sudoers.d/$username

pwd
echo "Overwrite makepkg binary"
cp -va ./makepkg /usr/bin/makepkg
mount ||:
findmnt ||:

if [[ -r /etc/makepkg.conf ]]; then echo readable here; fi
(
	if [[ -r /etc/makepkg.conf ]]; then echo readable here; fi
)

work() {
if [[ -r /etc/makepkg.conf ]]; then echo readable here; fi
(
	if [[ -r /etc/makepkg.conf ]]; then echo readable here; fi
)
	stat /etc/makepkg.conf ||:
	wc /etc/makepkg.conf ||:
	bash -c 'wc /etc/makepkg.conf' ||:
	stat /usr/bin/makepkg ||:
	whereis makepkg ||:
	cd ~
	git clone --depth 1 https://aur.archlinux.org/yay.git
	cd yay
	mount ||:
	findmnt ||:
	. makepkg --noprogressbar --noconfirm -si ||:
	makepkg --noprogressbar --noconfirm -si ||:
	strace bash makepkg --noprogressbar --noconfirm -si ||:
	yay -Syyu --removemake --noprogressbar --noconfirm --needed cowsay archivemount
	cowsay "Hello, World!"
}
sudo -u builder bash -s <<EOF
set -xeuo pipefail
$(declare -f work)
work
EOF

