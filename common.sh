#!/bin/bash

ROS_VERSION="v0.3.4-dev"
ROS_IMAGE=RancherOS-${ROS_VERSION}-0

USER_PUB=${USER_PUB:-./vagrant.pub}
USER_CERT=${USER_CERT:-./vagrantCert.pem}
USER_KEY=${USER_KEY:-./vagrant}
USER_PASS=${USER_PASS:-"7An@h9rr"}

chmod 0600 ${USER_KEY} # this is freaking important

VNET_PREFIX=10.0.0.0/16
VNET_SUBNET=10.0.0.0/24
