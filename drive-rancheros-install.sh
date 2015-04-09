#!/bin/bash

## make sure /dev/sdc exists
# ls -lAh /dev/disk/by-id/

docker run --privileged --net=host -it --entrypoint=/scripts/set-disk-partitions imikushin/os-installer /dev/sdc

## vi agent-init.sh
## chmod +x agent-init.sh
##docker run --privileged --net=host -it -v=/home:/home imikushin/os-installer -d /dev/sdc -t generic -c /home/core/agent-init.sh

# vi waagent-init.yml
# vi waagent.yml
docker run --privileged --net=host -it -v=/home:/home imikushin/os-installer -d /dev/sdc -t generic -c /home/core/waagent-init.yml -f waagent.yml
