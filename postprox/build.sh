#!/bin/bash -e

#
# Builds postprox deb from source in a throwaway container
#
HERE="$(cd "$(dirname "$0")" && pwd)"
IMG_NAME=postprox-builder

function _docker_image_exists() {
  if docker history -q "$1" >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

if ! _docker_image_exists "${IMG_NAME}"; then
     docker build -t  "${IMG_NAME}" .
fi

# leave the deb behind
docker run --rm -v "$HERE":/build "${IMG_NAME}" "$@"

# trash the rest
docker rmi postprox-builder
