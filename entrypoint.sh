#!/usr/bin/env sh

if [ "$#" -gt 0 ]; then
  exec upsies "$@"
else
  exec sleep infinity
fi
