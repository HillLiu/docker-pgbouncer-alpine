ARG VERSION=${VERSION:-[VERSION]}

FROM alpine:3.15 AS builder

ARG VERSION

# apk
COPY ./install-packages.sh /usr/local/bin/install-packages
RUN apk update \
  && INSTALL_VERSION=$VERSION install-packages

FROM alpine:3.15

RUN apk update && apk add bash postgresql-client openssl c-ares ca-certificates libevent

COPY --from=builder /usr/bin/pgbouncer /usr/bin/pgbouncer

RUN \
  mkdir /var/log/pgbouncer/ /var/run/pgbouncer/ && \
  chown -R nobody:nobody /var/log/pgbouncer && \
  chown -R nobody:nobody /var/run/pgbouncer

COPY ./entrypoint.sh /entrypoint.sh
USER postgres
EXPOSE 5432
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/pgbouncer", "/etc/pgbouncer/pgbouncer.ini"]
