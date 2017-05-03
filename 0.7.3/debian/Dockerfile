FROM debian:jessie

MAINTAINER Infinit <contact@infinit.sh>

ENV INFINIT_VERSION 0.7.3
LABEL version="0.7.3"

# Get the packages:
#
# - fuse is used to be able to mount infinit's volume.
RUN apt-get update                                                      && \
    apt-get install -y fuse                                                \
                       software-properties-common                          \
                       apt-transport-https                              && \
    export GNUPGHOME="$(mktemp -d)"                                     && \
    gpg --keyserver keyserver.ubuntu.com --recv-keys 3D2C3B0B           && \
    gpg --export 3D2C3B0B > /etc/apt/trusted.gpg.d/infinit.sh.gpg       && \
    add-apt-repository "deb https://debian.infinit.sh/ trusty main"     && \
    apt-get update                                                      && \
    apt-get install -y infinit=$INFINIT_VERSION                         && \
    rm -r "$GNUPGHOME"                                                  && \
    rm -rf /var/lib/apt/lists/*

ENV PATH=/opt/infinit/bin:$PATH

ENTRYPOINT ["infinit"]

CMD ["--help"]
