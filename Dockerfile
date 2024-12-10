FROM alpine:3.20 AS builder

USER root

RUN mkdir /root/workdir
WORKDIR /root/workdir

RUN apk add \
    --no-cache \
        npm nodejs tar xz sed

COPY *.png .
COPY *.json .
COPY LICENSE.txt .
COPY base_version.txt .

COPY inst/npx.sh .
RUN /bin/sh npx.sh

FROM alpine:3.20 AS flatpak

USER root

RUN apk add \
    --no-cache \
        flatpak flatpak-builder \
        appstream-compose \
        git git-lfs \
        curl wget sudo \
        xz bc \
        flex bash man-db \
        man-pages file shadow \
        gawk diffutils findutils

RUN git config \
    --global \
    --add protocol.file.allow always

RUN flatpak remote-add \
    --if-not-exists \
        flathub https://flathub.org/repo/flathub.flatpakrepo

COPY --from=builder /root/workdir/*.tar.xz /tmp/
