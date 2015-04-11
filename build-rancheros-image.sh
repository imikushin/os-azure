#!/bin/bash
set -e -x

cd $(dirname $0)

## Pre-requisites:
## - installed packages: apg, jq
## - you are logged in with azure cli

. ./common.sh

BUILD_HOST=build-$(apg -a 1 -n 1 -m 7 -x 7 -M NL)
BUILD_HOST_IMAGE="2b171e93f07c4903bcad35bda10acf22__CoreOS-Alpha-647.0.0"
BUILD_HOST_USER="core"

BUILD_USER_CERT=${BUILD_USER_CERT:-./vagrantCert.pem}
BUILD_USER_KEY=${BUILD_USER_KEY:-./vagrant}

azure vm create -l "West US" -e -P -t ${BUILD_USER_CERT} ${BUILD_HOST} ${BUILD_HOST_IMAGE} ${BUILD_HOST_USER}
azure vm disk attach-new ${BUILD_HOST} 40

sftp -i ${BUILD_USER_KEY} ${BUILD_HOST_USER}@${BUILD_HOST}.cloudapp.net:/home/${BUILD_HOST_USER} <<EOF
put waagent.yml
put rancher.yml
EOF

ssh -i ${BUILD_USER_KEY} ${BUILD_HOST_USER}@${BUILD_HOST}.cloudapp.net \
  docker run --privileged --net=host --entrypoint=/scripts/set-disk-partitions imikushin/os-installer /dev/sdc

ssh -i ${BUILD_USER_KEY} ${BUILD_HOST_USER}@${BUILD_HOST}.cloudapp.net \
  docker run --privileged --net=host -v=/home:/home \
    imikushin/os-installer \
      -d /dev/sdc -t generic -c /home/${BUILD_HOST_USER}/rancher.yml -f /home/${BUILD_HOST_USER}/waagent.yml

mkdir -p ./tmp

azure vm disk list --json -d ${BUILD_HOST}.cloudapp.net > ./tmp/disks.json

DISK_NAME=$(cat tmp/disks.json | jq '.[1].name' | xargs -I{} echo {})
IMAGE_VHD=$(cat tmp/disks.json | jq '.[1].mediaLink' | xargs -I{} echo {})

azure vm disk detach ${BUILD_HOST} 0
echo "Sleeping for 60 seconds... (let azure finish with detaching the disk)"
sleep 60

azure vm disk delete ${DISK_NAME}

azure vm delete -q -b ${BUILD_HOST}

azure vm image create -o linux -u ${IMAGE_VHD} RancherOS-${RANCHEROS_VERSION}
