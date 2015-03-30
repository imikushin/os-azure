#!/bin/bash
set -x -e

cat <<EOF >/var/lib/rancher/conf/start-agent.sh
#!/bin/sh
set -x -e

system-docker stop logspout && system-docker rm logspout && :
system-docker run -d --name=logspout --restart=always --net=host -v=/var/run/system-docker.sock:/tmp/docker.sock \
    gliderlabs/logspout \
    syslog://logs2.papertrailapp.com:46270

system-docker stop walinuxagent && system-docker rm walinuxagent && :
system-docker run -d --name=walinuxagent --privileged --restart=always \
  --volumes-from=all-volumes --ipc=host --net=host --pid=host \
  imikushin/walinuxagent -daemon
EOF

chmod +x /var/lib/rancher/conf/start-agent.sh

if [[ ${CLOUD_INIT_NETWORK} != false ]]; then
  nohup /var/lib/rancher/conf/start-agent.sh >/var/log/start-agent.log 2>&1 &
fi
