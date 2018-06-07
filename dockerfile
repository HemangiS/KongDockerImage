FROM kong:latest

RUN mkdir -p /var/cache/apk && \
    ln -s /var/cache/apk /etc/apk/cache && \
    apk add --update openssl-dev git gcc g++ build-base && \
    apk cache sync && \
    apk cache download && \
    luarocks install luacrypto OPENSSL_DIR=/usr && \
    luarocks install kong-oidc

EXPOSE 8000 8443 8001 8444

STOPSIGNAL SIGTERM
