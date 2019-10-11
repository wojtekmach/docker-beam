# built with ./build.sh, do not edit manually
FROM wojtekmach/erlang:%OTP_VERSION%-alpine AS builder

ENV GLEAM_VERSION="%GLEAM_VERSION%" \
  GLEAM_SHA256="%GLEAM_SHA256%" \
  LANG=C.UTF-8

RUN set -xe \
  && GLEAM_DOWNLOAD_URL="https://github.com/lpil/gleam/archive/v${GLEAM_VERSION}.tar.gz" \
  && buildDeps=' \
    ca-certificates \
    curl \
    build-base \
    cargo \
  ' \
  && apk add --no-cache --virtual .build-deps $buildDeps \
  && curl -fSL -o gleam-src.tar.gz $GLEAM_DOWNLOAD_URL \
  && sha256sum gleam-src.tar.gz \
  && echo "$GLEAM_SHA256  gleam-src.tar.gz" | sha256sum -c - \
  && mkdir -p /usr/local/src/gleam \
  && tar -xzC /usr/local/src/gleam --strip-components=1 -f gleam-src.tar.gz \
  && rm gleam-src.tar.gz
RUN set -xe \
  && cd /usr/local/src/gleam \
  && make build \
  && make install

FROM wojtekmach/erlang:%OTP_VERSION%-alpine

RUN set -xe \
  && apk add -vv --no-cache so:libgcc_s.so.1

COPY --from=builder /root/.cargo/bin/gleam /usr/local/bin

CMD ["gleam"]
