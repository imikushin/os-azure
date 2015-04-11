#!/bin/bash
set -e -x

mkdir -p /home/rancher/.ssh
chown -R rancher:rancher /home/rancher/.ssh
chmod -R go-rwx /home/rancher/.ssh

while inotifywait -q -r -e attrib /home/rancher/.ssh || true; do
  if  [[ "$(stat -c '%U' /home/rancher/.ssh)" != "rancher" ]] || \
      [[ "$(stat -c '%U' /home/rancher/.ssh/authorized_keys)" != "rancher" ]]; then
    chown -R rancher:rancher /home/rancher
    chmod -R go-rwx /home/rancher/.ssh
  fi
done
