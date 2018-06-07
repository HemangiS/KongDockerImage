mkdir -p /var/cache/apk
ln -s /var/cache/apk /etc/apk/cache
apk cache sync
apk cache download

usr/bin/openssl

apk add --update openssl-dev gcc g++ build-base git

apk info -L openssl-dev (lists the related file paths)

usr/include/openssl/evp.h

luarocks install luacrypto OPENSSL_DIR=/usr

```
Warning: The directory '/root/.cache/luarocks' or its parent directory is not owned by the current user and the cache has been disabled. Please check the permissions and owner of that directory. If executing /usr/local/bin/luarocks with sudo, you may want sudo's -H flag.
Installing https://luarocks.org/luacrypto-0.3.2-2.src.rock
gcc -O2 -fPIC -I/usr/local/openresty/luajit/include/luajit-2.1 -c src/lcrypto.c -o src/lcrypto.o -I/usr/include
src/lcrypto.c:6:20: fatal error: string.h: No such file or directory
 #include <string.h>
                    ^
compilation terminated.

Error: Build error: Failed compiling object src/lcrypto.o
```

apk add --update alpine-sdk
