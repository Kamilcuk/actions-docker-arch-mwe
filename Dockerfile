FROM archlinux:latest
COPY run.sh /run.sh
RUN bash /run.sh
USER builder
CMD ["/bin/bash"]
