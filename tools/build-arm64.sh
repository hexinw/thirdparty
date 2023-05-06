#!/bin/bash
#
# Script to build grpc debian in docker.
#

set -e
set -x

cd $(dirname $0)/..
BUILD_ROOT=./

export DEB_HOST_ARCH=arm64

${BUILD_ROOT}/tools/build.sh $@
