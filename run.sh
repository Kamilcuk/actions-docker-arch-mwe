#!/bin/bash
#set -euo pipefail
set -x

exec 2>&1

if [ ! -e /.dockerenv ]; then echo "error: this script is meant to be in docker" >&2; exit 2; fi

pacman --noconfirm --needed -Syu sudo
useradd -m builder
echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder
chmod 0440 /etc/sudoers.d/builder

work() {
	if [[ -r /etc/makepkg.conf ]]; then echo readable here; fi
	(
		if [[ -r /etc/makepkg.conf ]]; then echo readable here; fi
	)
	id||:;who||:;whoami||:;
	stat /etc/makepkg.conf ||:
	wc /etc/makepkg.conf ||:
	bash -c 'wc /etc/makepkg.conf' ||:
	stat /usr/bin/makepkg ||:
}
sudo -u builder bash -s <<EOF
set -xeuo pipefail
$(declare -f work)
work
EOF

