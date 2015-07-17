#!/bin/bash
set -e -x

cd $(dirname $0)

## Pre-requisites:
## - installed packages: apg, jq
## - installed azure cli
## - you are logged in with azure cli

. ./common.sh

RANCHEROS_HOST=rancheros-$(apg -a 1 -n 1 -m 7 -x 7 -M NL)

azure vm create -z Standard_D2 -l "West US" -e -P -t ${BUILD_USER_PUB} ${RANCHEROS_HOST} ${RANCHEROS_IMAGE} rancher

until ssh -F ./ssh_config -i ${BUILD_USER_KEY} rancher@${RANCHEROS_HOST}.cloudapp.net /bin/true; do
  sleep 2
done
