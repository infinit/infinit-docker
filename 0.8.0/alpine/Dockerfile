FROM alpine:3.5

MAINTAINER Infinit <contact@infinit.sh>

ENV INFINIT_VERSION 0.8.0
ENV INFINIT_SHA256 cbb263a0d6aef09f9eb9b89e504e9aff4e11c89b99f596246dee0149143cf4bb

LABEL version="0.8.0"

# Get the packages:
#
# - fuse is used to be able to mount infinit's volume.
RUN apk add --no-cache fuse                                         \
                       curl                                         \
                       libstdc++                                    \
    &&                                                              \
    curl -o infinit.tbz https://storage.googleapis.com/sh_infinit_releases/alpine/infinit-x86_64-alpine-gcc-${INFINIT_VERSION}.tbz \
    &&                                                              \
    sha256sum infinit.tbz                                           \
    &&                                                              \
    echo "${INFINIT_SHA256} *infinit.tbz" | sha256sum -c -          \
    &&                                                              \
    tar -C / --strip-components=1  -xvjf infinit.tbz                \
    &&                                                              \
    rm infinit.tbz

ENTRYPOINT ["infinit"]

CMD ["--help"]
