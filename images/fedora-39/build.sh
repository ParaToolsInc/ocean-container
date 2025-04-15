#!/bin/bash -e

. ../utilities.sh

if [[ -f vars.env ]]; then
  cmd . vars.env
fi

require_env RIFT_REPO
require_env OCEAN_VM_PATH


# Get Rift
rift_src=assets/rift
if [[ -d $rift_src ]] ; then
  cmd rm -rf $rift_src
fi

if [[ -d $RIFT_REPO ]] ; then
  # RIFT_REPO is a FS directory; copy it to assets/
  cmd cp -r $RIFT_REPO $rift_src
else
  # assume RIFT_REPO is a remote git repository; clone it
  cmd git clone --quiet $RIFT_REPO $rift_src
  if is_set RIFT_CHECKOUT ; then
    cmd git -C rift checkout --quiet $RIFT_CHECKOUT
  fi
fi

# Get Ocean VMs
for img in $(ls $OCEAN_VM_PATH/*.qcow); do
  bn=$(basename img)
  if [[ -f assets/$bn ]] ; then
    echo "info: vm image already exists: $bn"
    continue
  fi
  cmd cp $img assets/.
done

REGISTRY_DEFAULT=
REGISTRY=${REGISTRY:-$REGISTRY_DEFAULT}
BUILD_DATE=$(printf '%(%Y%m%d%H%M)T' -1)
BUILD_TAG=${BUILD_TAG:-fedora39-${BUILD_DATE}}
IMAGE_REPO=ocean-container

IMAGE_NAME="$IMAGE_REPO:$BUILD_TAG"
if [[ "$REGISTRY" -ne "" ]] ; then
  IMAGE_NAME="$REGISTRY/$IMAGE_REPO:$BUILD_TAG"
fi

if ! is_set BUILDKIT_PROGRESS ; then
  export BUILDKIT_PROGRESS=plain
fi


log=output.log

set +e
cmd 'docker build -t "'$IMAGE_NAME'" -f ./Dockerfile assets >'$log' 2>&1'
rc=$?
set -e

if [[ $rc -ne 0 ]]; then
  echo "error: docker build failed."
  echo "for more information, see $log"
  exit 1
else
  echo "image build succeeded!"
  echo "new image name = $IMAGE_NAME"
fi
