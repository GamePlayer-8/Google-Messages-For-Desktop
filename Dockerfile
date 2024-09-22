FROM alpine:3.20 AS builder

USER root

RUN mkdir /root/workdir
WORKDIR /root/workdir

COPY *.png .
COPY *.json .
COPY LICENSE.txt .

COPY inst/npx.sh .
RUN /bin/sh npx.sh


FROM alpine:3.20 AS flatpak

USER root

RUN mkdir /root/workdir
WORKDIR /root/workdir

COPY *.png .
COPY *.desktop .
COPY *.xml .
COPY *.yaml .
COPY LICENSE.txt .
COPY *.sh .
COPY --from=builder /root/workdir/*.tar.xz .

COPY inst/package.sh .
COPY inst/post.sh .
CMD ["/bin/sh", "-c", "cd /root/workdir/; sh package.sh; sh post.sh"]
