#!/bin/sh
# Build (and optionally push) Dockerfiles based on builds.txt

while IFS= read -r line; do
  eval $line
  ID="wojtekmach/${LANG}:${VERSION}-${VARIANT}"
  echo Building $ID

  DIR=${LANG}/${VERSION}/${VARIANT}
  mkdir -p $DIR
  cat templates/$LANG.dockerfile \
    | sed "s/%LINE%/${line}/g" \
    | sed "s/%ALPINE_VERSION%/${ALPINE_VERSION}/g" \
    | sed "s/%OTP_VERSION%/${OTP_VERSION}/g" \
    | sed "s/%OTP_SHA256%/${OTP_SHA256}/g" \
    | sed "s/%ELIXIR_VERSION%/${ELIXIR_VERSION}/g" \
    | sed "s/%ELIXIR_SHA256%/${ELIXIR_SHA256}/g" \
    | sed "s/%REBAR3_VERSION%/${REBAR3_VERSION}/g" \
    | sed "s/%REBAR3_SHA256%/${REBAR3_SHA256}/g" \
    | sed "s/%LFE_VERSION%/${LFE_VERSION}/g" \
    | sed "s/%LFE_SHA256%/${LFE_SHA256}/g" \
    | sed "s/%GLEAM_VERSION%/${GLEAM_VERSION}/g" \
    | sed "s/%GLEAM_SHA256%/${GLEAM_SHA256}/g" \
    > $DIR/Dockerfile

  sh -c "cd ${DIR} && docker build . -t ${ID}"

  if [[ "$1" == "push" ]]; then
    docker push $ID
  fi
done < builds.txt
