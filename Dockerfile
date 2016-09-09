#
# Dockerfile for shadowsocks-libev
#

FROM alpine:edge
MAINTAINER Tony.Shao <xiocode@gmail.com>

ENV SS_VERSION v2.5.0
ENV SS_URL https://github.com/shadowsocks/shadowsocks-libev.git
ENV SS_DIR shadowsocks-libev
ENV SS_DEP git autoconf build-base curl libtool linux-headers openssl-dev asciidoc xmlto

ENV KCPTUN_VERSION 20160906
ENV KCPTUN_FILE kcptun-linux-amd64-${KCPTUN_VERSION}.tar.gz
ENV KCPTUN_URL https://github.com/xtaci/kcptun/releases/download/v${KCPTUN_VERSION}/${KCPTUN_FILE}

RUN set -ex \
    && apk --no-cache --update add supervisor

ADD supervisord.conf /etc/supervisord.conf

RUN set -ex \
    && apk --no-cache --update add $SS_DEP \
    && git clone $SS_URL \
    && cd $SS_DIR \
    && git checkout tags/$SS_VERSION \
    && ./configure \
    && make install \
    && cd .. \
    && rm -rf $SS_DIR

RUN set -ex \
    && curl -sSL ${KCPTUN_URL} | tar xz -C /usr/local/bin

RUN set -ex \
    && apk del --purge $SS_DEP \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

ENV SS_PORT 7777
ENV KCP_PORT 8888

EXPOSE $SS_PORT/tcp
EXPOSE $SS_PORT/udp

EXPOSE $KCP_PORT/tcp
EXPOSE $KCP_PORT/udp

CMD ["supervisord", "-n"]
