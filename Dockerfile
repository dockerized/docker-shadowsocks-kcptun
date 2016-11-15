# Shadowsocks Server with KCPTUN support Dockerfile

FROM jonsun30/shadowsocks-docker

ENV KCP_VER 20161111

RUN \
    apk add --no-cache --virtual .build-deps curl \
    && mkdir -p /opt/kcptun \
    && cd /opt/kcptun \
    && curl -fSL https://github.com/xtaci/kcptun/releases/download/v$KCP_VER/kcptun-linux-amd64-$KCP_VER.tar.gz | tar xz \
    && rm client_linux_amd64 \
    && cd ~ \
    && apk del .build-deps \
    && apk add --no-cache supervisor
    -ADD supervisord.conf /etc/supervisord.conf

ENV SS_PORT 7777
ENV SS_PASSWORD 1234567890
ENV SS_METHOD rc4-md5

ENV KCP_TARGET 127.0.0.1:7777
ENV KCP_PORT 8888
ENV KCP_CRYPT salsa20
ENV KCP_KEY 1234567890
ENV KCP_SEND_WINDOW 2048
ENV KCP_RECEIVE_WINDOW 2048
ENV KCP_MTU 1400
ENV KCP_DATASHARD 70
ENV KCP_PARITYSHARD 30
ENV KCP_INTERVAL 50
ENV KCP_NODELAY 0
ENV KCP_RESEND 0
ENV KCP_NC 0
ENV KCP_ACKNODELAY true
ENV KCP_NOCOMP false
ENV KCP_SOCKBUF 4194304
ENV KCP_DSCP 0
ENV KCP_MODE fast2 


EXPOSE $SS_PORT
EXPOSE $KCP_PORT

CMD ["supervisord", "-n"]
