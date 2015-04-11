#!/bin/bash
set -e -x

cd $(dirname $0)

## Pre-requisites:
## - installed packages: apg, jq
## - installed azure cli
## - you are logged in with azure cli

. ./common.sh

RANCHEROS_HOST=rancheros-$(apg -a 1 -n 1 -m 7 -x 7 -M NL)
PASS=$(apg -a 1 -n 1 -m 8 -x 8 -M NLSC)

azure vm create -l "West US" -e -t ./vagrantCert.pem ${RANCHEROS_HOST} ${RANCHEROS_IMAGE} rancher "${PASS}"
