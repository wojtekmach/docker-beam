# built with ./build.sh, do not edit manually
FROM wojtekmach/erlang:%OTP_VERSION%-alpine

ENV ELIXIR_VERSION="%ELIXIR_VERSION%" \
  ELIXIR_SHA256="%ELIXIR_SHA256%" \
  LANG=C.UTF-8

RUN set -xe \
  && ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/v${ELIXIR_VERSION}.tar.gz" \
  && buildDeps=' \
    ca-certificates \
    curl \
    make \
  ' \
  && apk add --no-cache --virtual .build-deps $buildDeps \
  && curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
  && echo "$ELIXIR_SHA256  elixir-src.tar.gz" | sha256sum -c - \
  && mkdir -p /usr/local/src/elixir \
  && tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
  && rm elixir-src.tar.gz \
  && cd /usr/local/src/elixir \
  && make install clean \
  && apk del .build-deps \
  && mix local.hex --force \
  && mix local.rebar --force

CMD ["iex"]
