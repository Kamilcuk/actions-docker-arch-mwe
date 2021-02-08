FROM archlinux:latest

ENV SHELL /bin/bash

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN echo "[multilib]" >> /etc/pacman.conf \
&& echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf \
&& pacman --noprogressbar --noconfirm --needed -Syyu base-devel git \
&& groupadd --gid $USER_GID $USERNAME \
&& useradd -mrs /bin/bash --uid $USER_UID --gid $USER_GID $USERNAME \
&& echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
&& chmod 0440 /etc/sudoers.d/$USERNAME \
&& mkdir -p /tmp/yay && cd /tmp/yay \
&& chown -R $USERNAME:$USERNAME /tmp/yay \
&& sudo -u $USERNAME git clone --depth 1 https://aur.archlinux.org/yay.git \
&& cd yay \
&& sudo -u $USERNAME makepkg --noprogressbar --noconfirm -si \
&& rm -rf /tmp/yay \
&& sudo -u $USERNAME yay -Syyu --removemake --noprogressbar --noconfirm --needed \
    cowsay \
&& rm -rf /home/${USERNAME}/.cache \
&& cowsay "Hello, World!"

USER $USERNAME
CMD ["/bin/bash"]
