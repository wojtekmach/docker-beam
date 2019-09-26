# built with ./build.sh, do not edit manually
FROM wojtekmach/erlang:22-alpine

ENV LFE_VERSION="1.2.1" \
  LFE_SHA256="1967c6d3f604ea3ba5013b021426d8a28f45eee47fd208109ef116af2e74ab23" \
  LANG=C.UTF-8

RUN set -xe \
  && LFE_DOWNLOAD_URL="https://github.com/rvirding/lfe/archive/v${LFE_VERSION}.tar.gz" \
  && buildDeps=' \
    ca-certificates \
    curl \
    build-base \
  ' \
  && apk add --no-cache --virtual .build-deps $buildDeps \
  && curl -fSL -o lfe-src.tar.gz $LFE_DOWNLOAD_URL \
  && echo "$LFE_SHA256  lfe-src.tar.gz" | sha256sum -c - \
  && mkdir -p /usr/local/src/lfe \
  && tar -xzC /usr/local/src/lfe --strip-components=1 -f lfe-src.tar.gz \
  && rm lfe-src.tar.gz \
  && cd /usr/local/src/lfe \
  && make compile \
  && make install \
  && apk del .build-deps

CMD ["lfe"]
