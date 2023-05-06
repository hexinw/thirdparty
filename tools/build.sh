#!/bin/bash
#
# Script to build grpc debian in docker.
#

set -e

if [ $# -lt 1 ] ; then
  echo "  Usage: $0 <submodule>"
  echo
  exit -1
fi

set -x

MODULE=$1
cd $(dirname $0)/..

git submodule update --init --recursive ${MODULE}-deb/${MODULE}

BUILD_ROOT=./
BUILD_CONTAINER=docker.io/hexinwang/ubuntu18-builder
BUILD_COMMAND=/buildroot/tools/docker-build-deb.sh

EXTRA_ENV=
if [ "${DEB_HOST_ARCH}" == "arm64" ] ; then
  EXTRA_ENV="--env DEB_HOST_ARCH=$DEB_HOST_ARCH"
fi

echo "Launching ${BUILD_CONTAINER} ${DOCKER_BUILD_COMMAND}"
docker run \
  --rm \
  --tty \
  --interactive \
  --volume $(readlink -f "${BUILD_ROOT}"):/buildroot:z \
  --env BUILD_ROOT=/buildroot \
  --env SUBMODULE=${MODULE}-deb \
  ${EXTRA_ENV} \
  --workdir /buildroot \
  ${BUILD_CONTAINER} \
  ${BUILD_COMMAND}
