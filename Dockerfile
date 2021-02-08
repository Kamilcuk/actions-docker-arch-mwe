FROM archlinux:latest
COPY run.sh /run.sh
COPY makepkg /makepkg
RUN bash /run.sh
USER builder
CMD ["/bin/bash"]
