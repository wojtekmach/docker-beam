#!/bin/sh

function build {
  lang=$1
  version=$2
  variant=$3
  sh -c "cd $lang/$version/$variant && docker build . -t wojtekmach/$lang:$version-$variant"
}

build erlang 19 alpine
build erlang 22 alpine
build elixir 1.6 otp-19-alpine
build elixir 1.9 otp-22-alpine
