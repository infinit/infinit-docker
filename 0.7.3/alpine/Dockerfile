FROM alpine:3.5

MAINTAINER Infinit <contact@infinit.sh>

ENV INFINIT_VERSION 0.7.3
ENV INFINIT_SHA256 390a33e2a6cd46a1062039760851bda4931b72619ad37b97411d44b23df057de

LABEL version="0.7.3"

# Get the packages:
#
# - fuse is used to be able to mount infinit's volume.
RUN apk update --no-cache fuse                                      \
                          curl                                      \
                          libstdc++                                 \
    &&                                                              \
    curl -o infinit.tbz https://storage.googleapis.com/sh_infinit_releases/alpine/infinit-x86_64-alpine-gcc-${INFINIT_VERSION}.tbz \
    &&                                                              \
    sha256sum infinit.tbz                                           \
    &&                                                              \
    echo "${INFINIT_SHA256} *infinit.tbz" | sha256sum -c -          \
    &&                                                              \
    tar -C / --strip-components=1  -xvjf infinit.tbz

ENTRYPOINT ["infinit"]

CMD ["--help"]
