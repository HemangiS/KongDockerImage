## Kong-docker

- This is a kong image with kong-oidc plugin.

## Prerequisite

- [Docker](https://www.docker.com/docker-mac)

## dockerfile

```
FROM kong:latest

RUN mkdir -p /var/cache/apk && \
    ln -s /var/cache/apk /etc/apk/cache && \                   # These 2 cmds to enable cache
    apk add --update openssl-dev git gcc g++ build-base && \   # To add packages
    apk cache sync && \
    apk cache download && \                                    # These 2 cmds to download and install added packages
    luarocks install luacrypto OPENSSL_DIR=/usr && \           # To install luacrypto dependency for oidc
    luarocks install kong-oidc                                 # To install kong-oidc

EXPOSE 8000 8443 8001 8444

STOPSIGNAL SIGTERM
```

## CMDs

- To build image
`docker build -t kong .`

- Create a Docker network
`docker network create kong-net`

- Start your database

```
docker run -d --name kong-database \
              --network=kong-net \
              -p 5432:5432 \
              -e "POSTGRES_USER=kong" \
              -e "POSTGRES_DB=kong" \
              postgres:9.6
```

- Prepare your database

```
docker run --rm \
    --network=kong-net \
    -e "KONG_DATABASE=postgres" \
    -e "KONG_PG_HOST=kong-database" \
    -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
    kong:latest kong migrations up
```

- Start Kong

```
docker run -d --name kong \
    --network=kong-net \
    -e "KONG_DATABASE=postgres" \
  -e "KONG_CUSTOM_PLUGINS=oidc" \
    -e "KONG_PG_HOST=kong-database" \
    -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
    -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
    -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
    -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
    -e "KONG_ADMIN_LISTEN_SSL=0.0.0.0:8444" \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8001:8001 \
    -p 8444:8444 \
    kong:latest
```

- kong is running at `http://localhost:8001/`

## To test container

```
docker build -t my_kong .

docker run --name my_first_instance -i -t my_kong:latest

docker exec -it my_first_instance /bin/sh
```

## Important Links

- [kong-docker](https://getkong.org/install/docker/)
- [kong-oidc](https://github.com/nokia/kong-oidc)
- [apk pkg mgr](http://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management)
- [centralized authentication using kong gateway](https://developer.okta.com/blog/2017/12/04/use-kong-gateway-to-centralize-authentication)
