#!/bin/sh

###
# Environment ${INSTALL_VERSION} pass from Dockerfile
###

SSL_DEP="openssl-dev c-ares-dev"
BUILD_DEPS="${SSL_DEP} autoconf autoconf-doc automake make g++ libc-dev libtool libevent-dev pkgconfig curl"

echo "###"
echo "# Will build package"
echo "###"
echo ""
echo $BUILD_DEPS
echo ""

apk add --virtual .build-deps $BUILD_DEPS

#/* put your install code here */#
mkdir -p /tmp/src
curl -Lk "https://github.com/pgbouncer/pgbouncer/releases/download/pgbouncer_${INSTALL_VERSION//./_}/pgbouncer-${INSTALL_VERSION}.tar.gz" \
  | tar -xz -C /tmp/src --strip-components=1
cd /tmp/src \
  && ./configure --prefix=/usr --with-cares \
  && make \
  && make install

# apk del -f .build-deps && rm -rf /var/cache/apk/* || exit 1

exit 0
