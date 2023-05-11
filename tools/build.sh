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

if [ "${DEB_HOST_ARCH}" == "arm64" ] ; then
  BUILD_CONTAINER=quay.io/ubyon/ubuntu20-builder-arm64-cross
  EXTRA_ENVS="--env DEB_HOST_ARCH=arm64 --env DEB_HOST_GNU_CPU=aarch64"
else
  BUILD_CONTAINER=quay.io/ubyon/ubuntu20-builder:latest
  EXTRA_ENVS=
fi
BUILD_COMMAND=/buildroot/tools/docker-build-deb.sh

echo "Launching ${BUILD_CONTAINER} ${DOCKER_BUILD_COMMAND}"
docker run \
  --rm \
  --tty \
  --interactive \
  --volume $(readlink -f "${BUILD_ROOT}"):/buildroot:z \
  --env BUILD_ROOT=/buildroot \
  --env SUBMODULE=${MODULE}-deb \
  ${EXTRA_ENVS} \
  --workdir /buildroot \
  ${BUILD_CONTAINER} \
  ${BUILD_COMMAND}
