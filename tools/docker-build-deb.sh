#!/bin/bash

set -e
set -x

# Run the build with the same uid as the outside user so that
# the build output has the same permission.
extuid=$(stat -c %u /buildroot)
extgid=$(stat -c %g /buildroot)
if [ $(id -u) != "$extuid" ]; then
  groupadd build --gid $extgid
  useradd build --groups sudo \
    --home-dir /buildroot \
    --uid $extuid \
    --gid $extgid \
    --no-create-home
  # Hack. Moved it to base image in future.
  su build "$0" "$@"
  exit 0
fi

cd ${BUILD_ROOT}/${SUBMODULE}/
echo "Cleaning ${SUBMODULE} source tree..."
dh clean

echo "Building ${SUBMODULE} source tree..."
dh build

echo "Generate ${SUBMODULE} deb file..."
fakeroot dh binary
