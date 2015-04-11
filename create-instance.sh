#!/bin/bash
set -e -x

cd $(dirname $0)

## Pre-requisites:
## - installed packages: apg, jq
## - installed azure cli
## - you are logged in with azure cli

. ./common.sh

RANCHEROS_HOST=rancheros-$(apg -a 1 -n 1 -m 7 -x 7 -M NL)

azure vm create -l "West US" -e -P -t ./vagrantCert.pem ${RANCHEROS_HOST} ${RANCHEROS_IMAGE} rancher
