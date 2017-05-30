FROM debian:jessie

MAINTAINER Infinit <contact@infinit.sh>

ENV INFINIT_VERSION 0.8.0
LABEL version="0.8.0"

# Get the packages:
#
# - fuse is used to be able to mount infinit's volume.
RUN apt-get update                                                      && \
    apt-get install -y fuse                                                \
                       software-properties-common                          \
                       apt-transport-https                              && \
    export GNUPGHOME="$(mktemp -d)"                                     && \
    gpg --keyserver keyserver.ubuntu.com                                   \
        --recv-keys 6B302345264A43989D4EA9D25D81444E6821EB43            && \
    gpg --export 6B302345264A43989D4EA9D25D81444E6821EB43                  \
        > /etc/apt/trusted.gpg.d/infinit.sh.gpg                         && \
    add-apt-repository "deb https://debian.infinit.sh/ trusty main"     && \
    apt-get update                                                      && \
    apt-get install -y infinit=$INFINIT_VERSION                         && \
    rm -r "$GNUPGHOME"                                                  && \
    rm -rf /var/lib/apt/lists/*

ENV PATH=/opt/infinit/bin:$PATH

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

CMD ["infinit", "--help"]
