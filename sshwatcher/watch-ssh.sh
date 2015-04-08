#!/bin/bash
set -e -x

mkdir -p /home/rancher/.ssh
chown -R rancher:rancher /home/rancher/.ssh
chmod -R go-rwx /home/rancher/.ssh

while inotifywait -q -e attrib /home/rancher/.ssh; do
  if [[ "$(stat -c '%U' /home/rancher/.ssh)" != "rancher" ]]; then
    chown -R rancher:rancher /home/rancher/.ssh
    chmod -R go-rwx /home/rancher/.ssh
  fi
done
